// lib/features/employees/providers/employees_provider.dart
// Master Riverpod provider for employee management with auto-refresh, role filtering, and capability-based access control.
// Usage: ACTIVE - Primary employee state management for staff screens and technician assignments
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models/employee_model.dart';
import '../../shared/data/repositories/drift_employee_repository.dart';
import '../../../utils/error_logger.dart';
import '../../shared/data/repositories/drift_time_entry_repository.dart';
import '../../employees/data/models/clock_in_order_entry.dart';

part 'employees_provider.g.dart';

/// Repository provider - single source of truth for repository access
@riverpod
DriftEmployeeRepository employeeRepository(Ref ref) {
  return DriftEmployeeRepository.instance;
}

/// Master employees provider - single source of truth for ALL employees
/// This is the ONLY provider that fetches employees from the database
@riverpod
class EmployeesMaster extends _$EmployeesMaster {
  Timer? _refreshTimer;

  @override
  Future<List<Employee>> build() async {
    // Set up auto-refresh every 5 minutes (employee data is relatively static)
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      ref.invalidateSelf();
    });

    // Clean up timer on dispose
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    return _loadAllEmployees();
  }

  Future<List<Employee>> _loadAllEmployees() async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.initialize();

      // Load ALL employees from database (including inactive)
      final employees = await repo.getAllEmployees();

      ErrorLogger.logInfo(
          'EmployeesMaster: Loaded ${employees.length} total employees');
      return employees;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load master employees', e, stack);
      throw Exception('Failed to load employees: $e');
    }
  }

  /// Add a new employee
  Future<void> addEmployee(Employee employee) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.insertEmployee(employee);

      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to add employee', e, stack);
      rethrow;
    }
  }

  /// Update an existing employee
  Future<void> updateEmployee(Employee employee) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.updateEmployee(employee);

      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update employee', e, stack);
      rethrow;
    }
  }

  /// Update employee status
  Future<void> updateEmployeeStatus(int employeeId, String status) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.updateEmployeeStatus(employeeId, status);

      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update employee status', e, stack);
      rethrow;
    }
  }

  /// Delete an employee (soft delete - sets inactive)
  Future<void> deleteEmployee(int employeeId) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.deleteEmployee(employeeId);

      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete employee', e, stack);
      rethrow;
    }
  }

  /// Force refresh employees from database
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// ========== FILTER CLASSES ==========

/// Filter for employees
class EmployeeFilter {
  final String? role; // technician, manager, receptionist, etc.
  final String? status; // active, inactive, on-break
  final bool? includeInactive;
  final String? search;

  const EmployeeFilter({
    this.role,
    this.status,
    this.includeInactive,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeFilter &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          status == other.status &&
          includeInactive == other.includeInactive &&
          search == other.search;

  @override
  int get hashCode =>
      role.hashCode ^
      status.hashCode ^
      includeInactive.hashCode ^
      search.hashCode;
}

// ========== FAMILY PROVIDERS FOR FILTERING ==========

/// Provider for employees filtered by criteria
/// Uses family to enable caching per filter combination
@riverpod
List<Employee> employeesByFilter(Ref ref, EmployeeFilter filter) {
  // Watch the master list
  final allEmployeesAsync = ref.watch(employeesMasterProvider);

  return allEmployeesAsync.when(
    data: (employees) {
      var filtered = employees;

      // Apply inactive filter (default: hide inactive)
      if (filter.includeInactive != true) {
        filtered = filtered.where((e) => e.status == 'active').toList();
      }

      // Apply role filter
      if (filter.role != null && filter.role != 'All') {
        filtered = filtered
            .where((e) => e.role.toLowerCase() == filter.role!.toLowerCase())
            .toList();
      }

      // Apply status filter
      if (filter.status != null) {
        filtered = filtered.where((e) => e.status == filter.status).toList();
      }

      // Apply search filter
      if (filter.search != null && filter.search!.isNotEmpty) {
        final query = filter.search!.toLowerCase();
        filtered = filtered
            .where((e) =>
                e.fullName.toLowerCase().contains(query) ||
                e.email.toLowerCase().contains(query) ||
                e.phone.contains(query))
            .toList();
      }

      // Sort by name
      filtered.sort((a, b) => a.fullName.compareTo(b.fullName));

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// ========== COMPOSED PROVIDERS FOR COMMON VIEWS ==========

/// Provider for active employees only
@riverpod
List<Employee> activeEmployees(Ref ref) {
  return ref.watch(employeesByFilterProvider(
    const EmployeeFilter(status: 'active'),
  ));
}

/// Provider for technicians only
@riverpod
List<Employee> technicians(Ref ref) {
  return ref.watch(employeesByFilterProvider(
    const EmployeeFilter(role: 'technician', status: 'active'),
  ));
}

/// Provider for managers only
@riverpod
List<Employee> managers(Ref ref) {
  return ref.watch(employeesByFilterProvider(
    const EmployeeFilter(role: 'manager', status: 'active'),
  ));
}

/// Provider for employee by ID
@riverpod
Employee? employeeById(Ref ref, int employeeId) {
  final allEmployeesAsync = ref.watch(employeesMasterProvider);

  return allEmployeesAsync.when(
    data: (employees) => employees
                .firstWhere(
                  (e) => e.id == employeeId,
                  orElse: () => Employee(
                    id: -1,
                    firstName: '',
                    lastName: '',
                    email: '',
                    phone: '',
                    role: '',
                    hireDate: DateTime.now(),
                  ),
                )
                .id ==
            -1
        ? null
        : employees.firstWhere((e) => e.id == employeeId),
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for employee statistics
@riverpod
EmployeeStatistics employeeStatistics(Ref ref) {
  final allEmployeesAsync = ref.watch(employeesMasterProvider);

  return allEmployeesAsync.when(
    data: (employees) {
      final activeCount = employees.where((e) => e.status == 'active').length;
      final inactiveCount = employees.where((e) => e.status != 'active').length;
      final technicianCount = employees
          .where((e) => e.role == 'technician' && e.status == 'active')
          .length;
      final managerCount = employees
          .where((e) => e.role == 'manager' && e.status == 'active')
          .length;

      return EmployeeStatistics(
        totalCount: employees.length,
        activeCount: activeCount,
        inactiveCount: inactiveCount,
        technicianCount: technicianCount,
        managerCount: managerCount,
      );
    },
    loading: () => const EmployeeStatistics(),
    error: (_, __) => const EmployeeStatistics(),
  );
}

/// Employee statistics model
class EmployeeStatistics {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final int technicianCount;
  final int managerCount;

  const EmployeeStatistics({
    this.totalCount = 0,
    this.activeCount = 0,
    this.inactiveCount = 0,
    this.technicianCount = 0,
    this.managerCount = 0,
  });
}

// ========== UI STATE PROVIDERS ==========

/// Search query for employees screen
@riverpod
class EmployeeSearchQuery extends _$EmployeeSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

/// Selected role filter
@riverpod
class EmployeeRoleFilter extends _$EmployeeRoleFilter {
  @override
  String build() => 'All';

  void setRole(String role) {
    state = role;
  }
}

/// Show inactive employees toggle
@riverpod
class ShowInactiveEmployees extends _$ShowInactiveEmployees {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

// ========== CLOCK IN/OUT PROVIDERS ==========

/// Provider for employee clock-in status (accurate via Drift)
@riverpod
Future<bool> employeeClockedIn(Ref ref, int employeeId) async {
  final repo = DriftTimeEntryRepository.instance();
  final entry = await repo.getActiveTimeEntry(employeeId);
  return entry != null;
}

// ========== CLOCK-IN ORDER PROVIDER ==========

/// Provider for today's clock-in order entries
@riverpod
class ClockInOrder extends _$ClockInOrder {
  @override
  Future<List<ClockInOrderEntry>> build() async {
    final timeRepo = ref.read(timeEntryRepositoryProvider);
    final repo = ref.read(employeeRepositoryProvider);

    // Load base data
    await repo.initialize();
    final employees = await ref.read(employeesMasterProvider.future);

    // Fetch today's time entries to determine clock-in order
    final today = DateTime.now();
    final entries = await timeRepo.getTimeEntries(date: today, limit: 100);

    // Map to view entries using employee models
    final byId = {for (final e in employees) e.id: e};
    final result = <ClockInOrderEntry>[];
    for (final entry in entries) {
      final employee = byId[entry.employeeId];
      if (employee == null) continue;

      // Format time as HH:MM AM/PM
      final dt = entry.clockInTime;
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      result.add(
        ClockInOrderEntry(
          employee: employee,
          clockInTime: dt,
          formattedTime: '$displayHour:$minute $period',
        ),
      );
    }

    return result;
  }
}
