// lib/features/dashboard/providers/employee_status_provider.dart
// Riverpod provider for employee status management including availability, clock-in/out states, and specialization tracking.
// Integrates with time entry system, ticket assignments, and employee data to provide real-time employee status calculation.
// Usage: ACTIVE - Core employee status management system used by dashboard, assignments, and scheduling features

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/technician_model.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/models/employee_model.dart';
import '../../shared/data/models/time_entry_model.dart';
import '../../shared/data/repositories/drift_employee_repository.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../shared/data/repositories/drift_time_entry_repository.dart';
import '../../employees/providers/employees_provider.dart';
import '../../../core/database/database.dart' as db;
import '../../../core/utils/app_logger.dart';

part 'employee_status_provider.g.dart';
part 'employee_status_provider.freezed.dart';

/// Employee status provider for managing employee operational states
/// Handles availability, assignments, and clock-in status for all employees regardless of role
@riverpod
class EmployeeStatus extends _$EmployeeStatus {
  @override
  Future<EmployeeStatusState> build() async {
    // Watch the employees master provider instead of loading independently
    final employeesAsync = ref.watch(employeesMasterProvider);
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final timeEntryRepo = ref.watch(timeEntryRepositoryProvider);
    
    // Wait for employees data to be available
    final employees = await employeesAsync.future;
    final activeEmployees = employees.where((e) => e.status == 'active').toList();
    
    try {
      await ticketRepo.initialize();
      final allActiveTickets = await ticketRepo.getInServiceTickets();
      
      final employeeStates = <String, EmployeeState>{};
      final currentTickets = <String, String?>{};
      
      int turnNumber = 1;
      for (final emp in activeEmployees) {
        final empId = emp.id.toString();
        
        // Check if employee is clocked in via time_entries
        final activeTimeEntry = await timeEntryRepo.getActiveTimeEntry(emp.id);
        final isClockedIn = activeTimeEntry != null;
        
        // Calculate employee status based on clock-in status and assigned tickets
        final empStatus = _calculateEmployeeStatus(empId, allActiveTickets, emp, isClockedIn);
        final currentTicketId = _findCurrentTicketId(empId, allActiveTickets);
        
        // Load specializations from database
        final specializations = await _loadEmployeeSpecializations(emp.id);
        
        // Create dashboard employee model (using Technician for now, represents any dashboard employee)
        final employee = Technician(
          id: empId,
          name: '${emp.firstName} ${emp.lastName}'.trim(),
          status: empStatus.status,
          turnNumber: turnNumber++,
          avatarColor: _getAvatarColor('${emp.firstName} ${emp.lastName}'),
          avatarInitial: _getInitials('${emp.firstName} ${emp.lastName}'),
          currentTicketId: currentTicketId,
          isOff: !isClockedIn,
          specializations: specializations,
        );
        
        // Create immutable employee state
        final state = EmployeeState(
          employee: employee,
          status: empStatus.status,
          currentTicketId: currentTicketId,
          isOff: !isClockedIn,
          specializations: specializations,
          lastUpdated: DateTime.now(),
        );
        
        employeeStates[empId] = state;
        currentTickets[empId] = currentTicketId;
        
        AppLogger.logInfo('Loaded employee: ${employee.name} (Role: ${emp.role}, Status: ${empStatus.status}, Ticket: $currentTicketId)');
      }
      
      AppLogger.logInfo('EmployeeStatusProvider: Loaded ${employeeStates.length} employees');
      
      return EmployeeStatusState(
        employeeStates: employeeStates,
        currentTickets: currentTickets,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stack) {
      AppLogger.logError('EmployeeStatusProvider.build', e, stack);
      return EmployeeStatusState(
        errorMessage: 'Failed to load employees: $e',
        lastUpdated: DateTime.now(),
      );
    }
  }
  
  /// Update employee status
  void updateEmployeeStatus(String empId, String status, String? ticketId) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final existingState = currentState.employeeStates[empId];
    if (existingState == null) {
      AppLogger.logWarning('Cannot update status for unknown employee: $empId');
      return;
    }
    
    // Update with immutable state
    final updatedEmployee = existingState.employee.copyWith(
      status: status,
      currentTicketId: ticketId,
    );
    
    final updatedEmpState = existingState.copyWith(
      employee: updatedEmployee,
      status: status,
      currentTicketId: ticketId,
      lastUpdated: DateTime.now(),
    );
    
    final newStates = Map<String, EmployeeState>.from(currentState.employeeStates);
    newStates[empId] = updatedEmpState;
    
    final newTickets = Map<String, String?>.from(currentState.currentTickets);
    newTickets[empId] = ticketId;
    
    state = AsyncValue.data(
      currentState.copyWith(
        employeeStates: newStates,
        currentTickets: newTickets,
      ),
    );
    
    AppLogger.logInfo('Updated employee $empId: $status (Ticket: $ticketId)');
  }
  
  /// Set employee offline status
  void setEmployeeOffline(String empId, bool isOff) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final existingState = currentState.employeeStates[empId];
    if (existingState == null) return;
    
    final updatedEmployee = existingState.employee.copyWith(isOff: isOff);
    final updatedEmpState = existingState.copyWith(
      employee: updatedEmployee,
      isOff: isOff,
      lastUpdated: DateTime.now(),
    );
    
    final newStates = Map<String, EmployeeState>.from(currentState.employeeStates);
    newStates[empId] = updatedEmpState;
    
    state = AsyncValue.data(
      currentState.copyWith(employeeStates: newStates),
    );
    
    AppLogger.logInfo('Set employee $empId offline status: $isOff');
  }
  
  /// Clear employee's current ticket
  void clearEmployeeTicket(String empId) {
    updateEmployeeStatus(empId, 'available', null);
  }
  
  /// Clock in an employee
  Future<void> clockIn(int employeeId) async {
    try {
      final timeEntryRepo = ref.read(timeEntryRepositoryProvider);
      
      await timeEntryRepo.clockIn(employeeId);
      
      // Refresh the state to reflect the clock-in
      await refresh();
      
      AppLogger.logInfo('Employee $employeeId clocked in successfully');
    } catch (e, stack) {
      AppLogger.logError('Failed to clock in employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// Clock out an employee
  Future<void> clockOut(int employeeId) async {
    try {
      final timeEntryRepo = ref.read(timeEntryRepositoryProvider);
      
      await timeEntryRepo.clockOut(employeeId);
      
      // Refresh the state to reflect the clock-out
      await refresh();
      
      AppLogger.logInfo('Employee $employeeId clocked out successfully');
    } catch (e, stack) {
      AppLogger.logError('Failed to clock out employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// Refresh employee data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
  
  // ========== PRIVATE HELPER METHODS ==========
  
  EmployeeStatusCalculation _calculateEmployeeStatus(
    String empId,
    List<Ticket> allActiveTickets,
    Employee employee,
    bool isClockedIn,
  ) {
    // PRIMARY FACTOR: Clock-in status determines base availability
    if (!isClockedIn) {
      return const EmployeeStatusCalculation(
        status: 'off',
        reason: 'Not clocked in - unavailable for assignments',
      );
    }
    
    // Check for in-service tickets
    try {
      final inServiceTicket = allActiveTickets.firstWhere(
        (ticket) => ticket.assignedTechnicianId == empId && ticket.status == 'in-service',
      );
      return EmployeeStatusCalculation(
        status: 'busy',
        ticketId: inServiceTicket.ticketNumber,
        reason: 'Actively working on in-service ticket',
      );
    } catch (_) {}
    
    // Check for assigned tickets
    try {
      final assignedTicket = allActiveTickets.firstWhere(
        (ticket) => ticket.assignedTechnicianId == empId && ticket.status == 'assigned',
      );
      return EmployeeStatusCalculation(
        status: 'assigned',
        ticketId: assignedTicket.ticketNumber,
        reason: 'Has assigned ticket awaiting service',
      );
    } catch (_) {}
    
    // Check for queued tickets with employee pre-assignment
    try {
      final queuedAssignedTicket = allActiveTickets.firstWhere(
        (ticket) => ticket.assignedTechnicianId == empId && ticket.status == 'queued',
      );
      return EmployeeStatusCalculation(
        status: 'assigned',
        ticketId: queuedAssignedTicket.ticketNumber,
        reason: 'Pre-assigned to queued ticket (likely appointment)',
      );
    } catch (_) {}
    
    // DEFAULT: Clocked in with no assignments = available
    return const EmployeeStatusCalculation(
      status: 'available',
      reason: 'Clocked in and available for assignment',
    );
  }
  
  String? _findCurrentTicketId(String empId, List<Ticket> allActiveTickets) {
    for (final ticket in allActiveTickets) {
      if (ticket.assignedTechnicianId == empId) {
        return ticket.ticketNumber;
      }
    }
    return null;
  }
  
  Future<List<String>> _loadEmployeeSpecializations(int employeeId) async {
    try {
      final database = db.PosDatabase.instance;
      
      // Query the employee_service_categories table
      final categories = await (database.select(database.employeeServiceCategories)
        ..where((t) => t.employeeId.equals(employeeId)))
        .get();
      
      final specializations = categories
          .map((c) => c.categoryName ?? '')
          .where((c) => c.isNotEmpty)
          .toList();
      
      // Return actual specializations or default if none found
      return specializations.isNotEmpty ? specializations : ['general'];
    } catch (e, stack) {
      AppLogger.logError('Failed to load employee specializations for employee $employeeId', e, stack);
      return ['general']; // Fallback
    }
  }
  
  String _getAvatarColor(String name) {
    final colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FECA57',
      '#FF9FF3', '#54A0FF', '#5F27CD', '#00D2D3', '#FF9F43'
    ];
    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'T';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

// ========== REPOSITORY PROVIDERS ==========

@riverpod
DriftEmployeeRepository employeeRepository(Ref ref) {
  return DriftEmployeeRepository.instance;
}

@riverpod
DriftTimeEntryRepository timeEntryRepository(Ref ref) {
  return DriftTimeEntryRepository.instance();
}

// ========== COMPUTED PROVIDERS ==========

/// Available employees (any role)
@riverpod
List<Technician> availableEmployees(Ref ref) {
  final state = ref.watch(employeeStatusProvider).value;
  if (state == null) return [];
  
  return state.employeeStates.entries
      .where((entry) => entry.value.isAvailable)
      .map((entry) => entry.value.employee)
      .toList();
}

/// Busy employees
@riverpod
List<Technician> busyEmployees(Ref ref) {
  final state = ref.watch(employeeStatusProvider).value;
  if (state == null) return [];
  
  return state.employeeStates.entries
      .where((entry) => entry.value.status == 'busy')
      .map((entry) => entry.value.employee)
      .toList();
}

/// Assigned employees
@riverpod
List<Technician> assignedEmployees(Ref ref) {
  final state = ref.watch(employeeStatusProvider).value;
  if (state == null) return [];
  
  return state.employeeStates.entries
      .where((entry) => entry.value.status == 'assigned')
      .map((entry) => entry.value.employee)
      .toList();
}

/// Offline employees
@riverpod
List<Technician> offlineEmployees(Ref ref) {
  final state = ref.watch(employeeStatusProvider).value;
  if (state == null) return [];
  
  return state.employeeStates.entries
      .where((entry) => entry.value.isOffline)
      .map((entry) => entry.value.employee)
      .toList();
}

/// All dashboard employees
@riverpod
List<Technician> allDashboardEmployees(Ref ref) {
  final state = ref.watch(employeeStatusProvider).value;
  if (state == null) return [];
  
  return state.employeeStates.values
      .map((state) => state.employee)
      .toList();
}

/// Filter employees by role - technicians only (for dashboard compatibility)
@riverpod
List<Technician> availableTechnicians(Ref ref) {
  final allAvailable = ref.watch(availableEmployeesProvider);
  // Note: We'll need to add role filtering logic here or get role from base employee data
  return allAvailable; // For now, return all available (TODO: filter by role)
}

@riverpod
List<Technician> busyTechnicians(Ref ref) {
  final allBusy = ref.watch(busyEmployeesProvider);
  return allBusy; // TODO: filter by role = technician
}

@riverpod
List<Technician> assignedTechnicians(Ref ref) {
  final allAssigned = ref.watch(assignedEmployeesProvider);
  return allAssigned; // TODO: filter by role = technician  
}

@riverpod
List<Technician> offlineTechnicians(Ref ref) {
  final allOffline = ref.watch(offlineEmployeesProvider);
  return allOffline; // TODO: filter by role = technician
}

@riverpod
List<Technician> allTechnicians(Ref ref) {
  final allEmployees = ref.watch(allDashboardEmployeesProvider);
  return allEmployees; // TODO: filter by role = technician
}

/// Count providers
@riverpod
int availableCount(Ref ref) {
  return ref.watch(availableTechniciansProvider).length;
}

@riverpod
int busyCount(Ref ref) {
  return ref.watch(busyTechniciansProvider).length;
}

@riverpod
int assignedCount(Ref ref) {
  return ref.watch(assignedTechniciansProvider).length;
}

@riverpod
int offlineCount(Ref ref) {
  return ref.watch(offlineTechniciansProvider).length;
}

/// Get specific employee state
@riverpod
EmployeeState? getEmployeeState(Ref ref, String empId) {
  final state = ref.watch(employeeStatusProvider).value;
  return state?.employeeStates[empId];
}

/// Get specific employee (dashboard model)
@riverpod
Technician? getEmployee(Ref ref, String empId) {
  final state = ref.watch(getEmployeeStateProvider(empId));
  return state?.employee;
}

/// Check if employee is available
@riverpod
bool isEmployeeAvailable(Ref ref, String empId) {
  final state = ref.watch(getEmployeeStateProvider(empId));
  return state?.isAvailable ?? false;
}

/// Legacy aliases for backwards compatibility
@riverpod
EmployeeState? getTechnicianState(Ref ref, String techId) {
  return ref.watch(getEmployeeStateProvider(techId));
}

@riverpod
Technician? getTechnician(Ref ref, String techId) {
  return ref.watch(getEmployeeProvider(techId));
}

@riverpod
bool isTechnicianAvailable(Ref ref, String techId) {
  return ref.watch(isEmployeeAvailableProvider(techId));
}

// ========== STATE MODELS ==========

@freezed
class EmployeeStatusState with _$EmployeeStatusState {
  const factory EmployeeStatusState({
    @Default({}) Map<String, EmployeeState> employeeStates,
    @Default({}) Map<String, String?> currentTickets,
    String? errorMessage,
    DateTime? lastUpdated,
  }) = _EmployeeStatusState;
}

@freezed
class EmployeeState with _$EmployeeState {
  const EmployeeState._();
  
  const factory EmployeeState({
    required Technician employee, // Using Technician model for dashboard representation
    required String status, // 'available', 'assigned', 'busy', 'off'
    String? currentTicketId,
    @Default(false) bool isOff,
    @Default([]) List<String> specializations,
    required DateTime lastUpdated,
  }) = _EmployeeState;
  
  /// Primary availability check: available status + clocked in
  bool get isAvailable => status == 'available' && !isOff;
  
  /// Actively working on in-service ticket
  bool get isBusy => status == 'busy';
  
  /// Has assigned ticket but not yet in service
  bool get isAssigned => status == 'assigned';
  
  /// Not clocked in or marked offline
  bool get isOffline => status == 'off' || isOff;
}

@freezed
class EmployeeStatusCalculation with _$EmployeeStatusCalculation {
  const factory EmployeeStatusCalculation({
    required String status,
    String? ticketId,
    required String reason,
  }) = _EmployeeStatusCalculation;
}
