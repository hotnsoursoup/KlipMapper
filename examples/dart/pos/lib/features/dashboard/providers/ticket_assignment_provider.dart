// lib/features/dashboard/providers/ticket_assignment_provider.dart
// Riverpod provider for intelligent ticket assignment system with auto-assignment, workload balancing, and specialization matching.
// Handles manual assignments, reassignments, priority-based auto-assignment with FIFO fallback, and reactive queue monitoring.
// Usage: ACTIVE - Core assignment system used by dashboard for managing technician-ticket relationships and workflow automation

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/models/technician_model.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../../core/services/technician_lookup_service.dart';
import '../../../utils/error_logger.dart';
import 'employee_status_provider.dart';
import 'queue_management_provider.dart';

part 'ticket_assignment_provider.g.dart';
part 'ticket_assignment_provider.freezed.dart';

/// Ticket assignment provider for managing assignments and auto-assignment
/// Converted from ticket_assignment_store.dart
@riverpod
class TicketAssignment extends _$TicketAssignment {
  @override
  TicketAssignmentState build() {
    // Set up reactive listeners for auto-assignment
    _setupAutoAssignmentListeners();
    
    return const TicketAssignmentState();
  }
  
  /// Assign a ticket to a technician
  Future<AssignmentResult> assignTicket(String ticketId, String technicianId) async {
    if (state.isProcessing) {
      return const AssignmentResult.failed(reason: 'Assignment already in progress');
    }
    
    try {
      state = state.copyWith(isProcessing: true, errorMessage: null);
      
      final ticketRepo = ref.read(ticketRepositoryProvider);
      await ticketRepo.initialize();
      
      // Validate technician availability
      final isAvailable = ref.read(isTechnicianAvailableProvider(technicianId));
      if (!isAvailable) {
        return AssignmentResult.failed(
          reason: 'Technician is not available',
          ticketId: ticketId,
          technicianId: technicianId,
        );
      }
      
      // Get the ticket from queue
      final ticket = ref.read(getTicketByIdProvider(ticketId));
      if (ticket == null) {
        return AssignmentResult.failed(
          reason: 'Ticket not found in queue',
          ticketId: ticketId,
        );
      }
      
      // Update ticket assignment in database
      final updatedTicket = ticket.copyWith(
        assignedTechnicianId: technicianId,
        status: 'assigned',
      );
      
      await ticketRepo.updateTicket(updatedTicket);
      
      // Update local state
      final newAssignments = Map<String, String>.from(state.assignments);
      newAssignments[ticketId] = technicianId;
      
      state = state.copyWith(
        assignments: newAssignments,
        lastAssignmentTime: DateTime.now(),
        isProcessing: false,
      );
      
      // Update technician status
      ref.read(employeeStatusProvider.notifier)
          .updateTechnicianStatus(technicianId, 'assigned', ticketId);
      
      // Remove from queue
      ref.read(queueManagementProvider.notifier)
          .removeTicketFromQueue(ticketId);
      
      ErrorLogger.logInfo('Successfully assigned ticket $ticketId to technician $technicianId');
      
      return AssignmentResult.success(
        ticketId: ticketId,
        technicianId: technicianId,
        assignedAt: DateTime.now(),
      );
      
    } catch (e, stack) {
      state = state.copyWith(
        errorMessage: 'Failed to assign ticket: $e',
        isProcessing: false,
      );
      ErrorLogger.logError('TicketAssignmentProvider.assignTicket', e, stack);
      
      return AssignmentResult.failed(
        reason: e.toString(),
        ticketId: ticketId,
        technicianId: technicianId,
      );
    }
  }
  
  /// Perform auto-assignment
  Future<void> performAutoAssignment() async {
    if (!canAutoAssign) {
      ErrorLogger.logInfo('Auto-assignment skipped: conditions not met');
      return;
    }
    
    try {
      state = state.copyWith(isProcessing: true, errorMessage: null);
      
      // Get unassigned tickets from queue
      final queueTickets = ref.read(filteredQueueTicketsProvider);
      final unassignedTickets = queueTickets.where((ticket) =>
        ticket.status == 'queued' &&
        (ticket.assignedTechnicianId == null ||
         ticket.assignedTechnicianId!.isEmpty ||
         TechnicianLookupService.isAnyTechnician(ticket.assignedTechnicianId))
      ).toList();
      
      if (unassignedTickets.isEmpty) {
        ErrorLogger.logInfo('Auto-assignment: No unassigned tickets in queue');
        return;
      }
      
      // Apply priority sorting
      final prioritizedTickets = _applyTicketPrioritySort(unassignedTickets);
      final nextTicket = prioritizedTickets.first;
      
      ErrorLogger.logInfo('Auto-assignment: Selected highest priority ticket ${nextTicket.ticketNumber} (${nextTicket.type})');
      
      // Find best technician for the ticket
      final bestTechnician = _findBestTechnicianForTicket(nextTicket);
      if (bestTechnician == null) {
        ErrorLogger.logInfo('Auto-assignment: No suitable technician found for ticket ${nextTicket.id}');
        return;
      }
      
      // Perform the assignment
      final result = await assignTicket(nextTicket.id, bestTechnician.id);
      
      result.when(
        success: (ticketId, technicianId, assignedAt) {
          ErrorLogger.logInfo('Auto-assigned priority ticket $ticketId (${nextTicket.type}) to ${bestTechnician.name}');
        },
        failed: (reason, ticketId, technicianId) {
          ErrorLogger.logError('Auto-assignment failed: $reason', reason, StackTrace.current);
        },
      );
      
    } catch (e, stack) {
      state = state.copyWith(
        errorMessage: 'Auto-assignment failed: $e',
        isProcessing: false,
      );
      ErrorLogger.logError('TicketAssignmentProvider.performAutoAssignment', e, stack);
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }
  
  /// Enable/disable auto-assignment
  void enableAutoAssignment(bool enabled) {
    state = state.copyWith(autoAssignmentEnabled: enabled);
    ErrorLogger.logInfo('Auto-assignment ${enabled ? 'enabled' : 'disabled'}');
    
    if (enabled && canAutoAssign) {
      // Trigger assignment check
      Future.microtask(() => performAutoAssignment());
    }
  }
  
  /// Reassign tickets from one technician to another
  Future<AssignmentResult> reassignTechnician(String fromTechId, String toTechId) async {
    try {
      state = state.copyWith(isProcessing: true, errorMessage: null);
      
      // Find tickets assigned to the source technician
      final ticketsToReassign = state.assignments.entries
          .where((entry) => entry.value == fromTechId)
          .map((entry) => entry.key)
          .toList();
      
      if (ticketsToReassign.isEmpty) {
        return AssignmentResult.failed(
          reason: 'No tickets assigned to source technician',
          technicianId: fromTechId,
        );
      }
      
      // Validate target technician availability
      final isAvailable = ref.read(isTechnicianAvailableProvider(toTechId));
      if (!isAvailable) {
        return AssignmentResult.failed(
          reason: 'Target technician is not available',
          technicianId: toTechId,
        );
      }
      
      // Reassign all tickets
      for (final ticketId in ticketsToReassign) {
        final result = await assignTicket(ticketId, toTechId);
        if (result is _Failed) {
          return result;
        }
      }
      
      ErrorLogger.logInfo('Reassigned ${ticketsToReassign.length} tickets from $fromTechId to $toTechId');
      
      return AssignmentResult.success(
        ticketId: ticketsToReassign.first,
        technicianId: toTechId,
        assignedAt: DateTime.now(),
      );
      
    } catch (e, stack) {
      state = state.copyWith(
        errorMessage: 'Reassignment failed: $e',
        isProcessing: false,
      );
      ErrorLogger.logError('TicketAssignmentProvider.reassignTechnician', e, stack);
      
      return AssignmentResult.failed(
        reason: e.toString(),
        technicianId: fromTechId,
      );
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }
  
  /// Clear an assignment
  void clearAssignment(String ticketId) {
    final techId = state.assignments[ticketId];
    if (techId != null) {
      final newAssignments = Map<String, String>.from(state.assignments);
      newAssignments.remove(ticketId);
      state = state.copyWith(assignments: newAssignments);
      
      ref.read(employeeStatusProvider.notifier).clearEmployeeTicket(techId);
      ErrorLogger.logInfo('Cleared assignment for ticket $ticketId from technician $techId');
    }
  }
  
  // ========== PRIVATE HELPER METHODS ==========
  
  void _setupAutoAssignmentListeners() {
    // React to queue length changes
    ref.listen(queueLengthProvider, (previous, current) {
      if (current > 0 && canAutoAssign) {
        Future.microtask(() => performAutoAssignment());
      }
    });
    
    // React to available technician count changes
    ref.listen(availableCountProvider, (previous, current) {
      if (current > 0 && canAutoAssign) {
        Future.microtask(() => performAutoAssignment());
      }
    });
  }
  
  bool get canAutoAssign {
    final availableCount = ref.read(availableCountProvider);
    final queueLength = ref.read(queueLengthProvider);
    
    return state.autoAssignmentEnabled &&
           availableCount > 0 &&
           queueLength > 0 &&
           !state.isProcessing;
  }
  
  /// Apply ticket priority sorting
  List<Ticket> _applyTicketPrioritySort(List<Ticket> tickets) {
    if (tickets.isEmpty) return tickets;
    
    final sortedTickets = List<Ticket>.from(tickets);
    final now = DateTime.now();
    
    sortedTickets.sort((a, b) {
      final aWaitTime = now.difference(a.checkInTime).inMinutes;
      final bWaitTime = now.difference(b.checkInTime).inMinutes;
      
      // Priority Rule 1: Walk-in waited 15+ minutes beats appointments
      if (a.type == 'walk-in' && aWaitTime >= 15 && b.type == 'appointment') {
        return -1; // a comes first
      }
      if (b.type == 'walk-in' && bWaitTime >= 15 && a.type == 'appointment') {
        return 1; // b comes first
      }
      
      // Priority Rule 2: Appointments beat walk-ins (if walk-in waited < 15 min)
      if (a.type == 'appointment' && b.type == 'walk-in' && bWaitTime < 15) {
        return -1; // a comes first
      }
      if (b.type == 'appointment' && a.type == 'walk-in' && aWaitTime < 15) {
        return 1; // b comes first
      }
      
      // Priority Rule 3: Within same type, FIFO (oldest first)
      return a.checkInTime.compareTo(b.checkInTime);
    });
    
    return sortedTickets;
  }
  
  /// Find best technician for a ticket
  Technician? _findBestTechnicianForTicket(Ticket ticket) {
    final availableTechnicians = ref.read(availableTechniciansProvider);
    
    if (availableTechnicians.isEmpty) {
      ErrorLogger.logInfo('No available technicians for ticket ${ticket.id}');
      return null;
    }
    
    // Priority 1: Service specialization match
    final specialistTechnicians = _findTechniciansWithServiceCapability(ticket, availableTechnicians);
    
    if (specialistTechnicians.isNotEmpty) {
      ErrorLogger.logInfo('Found ${specialistTechnicians.length} specialist technicians');
      
      // Among specialists, select by lowest workload
      final bestSpecialist = _selectByLowestWorkload(specialistTechnicians);
      if (bestSpecialist != null) {
        return bestSpecialist;
      }
    }
    
    // Priority 2: Workload balancing among all available
    final bestGeneralist = _selectByLowestWorkload(availableTechnicians);
    if (bestGeneralist != null) {
      return bestGeneralist;
    }
    
    // Priority 3: FIFO availability
    return availableTechnicians.first;
  }
  
  /// Find technicians with matching service capabilities
  List<Technician> _findTechniciansWithServiceCapability(Ticket ticket, List<Technician> availableTechnicians) {
    final ticketServiceCategories = <String>{};
    
    // Extract all service categories from the ticket
    for (final service in ticket.services) {
      ticketServiceCategories.add(service.categoryId.toString());
          ticketServiceCategories.add(service.name.toLowerCase());
    }
    
    // Filter technicians who have matching specializations
    return availableTechnicians.where((technician) {
      // Check if technician has 'general' specialization
      if (technician.specializations.contains('general') ||
          technician.specializations.contains('General')) {
        return true;
      }
      
      // Check for specific category matches
      return technician.specializations.any((specialization) {
        return ticketServiceCategories.any((category) =>
          category.toLowerCase().contains(specialization.toLowerCase()) ||
          specialization.toLowerCase().contains(category.toLowerCase())
        );
      });
    }).toList();
  }
  
  /// Select technician with lowest workload
  Technician? _selectByLowestWorkload(List<Technician> technicians) {
    if (technicians.isEmpty) return null;
    
    final workloadMap = technicianWorkload;
    Technician? bestTechnician;
    int lowestWorkload = 999;
    
    for (final technician in technicians) {
      final currentWorkload = workloadMap[technician.id] ?? 0;
      if (currentWorkload < lowestWorkload) {
        lowestWorkload = currentWorkload;
        bestTechnician = technician;
      }
    }
    
    return bestTechnician;
  }
  
  Map<String, int> get technicianWorkload {
    final workload = <String, int>{};
    for (final techId in state.assignments.values) {
      workload[techId] = (workload[techId] ?? 0) + 1;
    }
    return workload;
  }
}

// ========== COMPUTED PROVIDERS ==========

/// Total assignments count
@riverpod
int totalAssignments(Ref ref) {
  final state = ref.watch(ticketAssignmentProvider);
  return state.assignments.length;
}

/// Get assigned technician ID for a ticket
@riverpod
String? getAssignedTechnicianId(Ref ref, String ticketId) {
  final state = ref.watch(ticketAssignmentProvider);
  return state.assignments[ticketId];
}

/// Get tickets for a technician
@riverpod
List<String> getTicketsForTechnician(Ref ref, String technicianId) {
  final state = ref.watch(ticketAssignmentProvider);
  return state.assignments.entries
      .where((entry) => entry.value == technicianId)
      .map((entry) => entry.key)
      .toList();
}

/// Check if ticket is assigned
@riverpod
bool isTicketAssigned(Ref ref, String ticketId) {
  final state = ref.watch(ticketAssignmentProvider);
  return state.assignments.containsKey(ticketId);
}

// ========== STATE MODELS ==========

@freezed
class TicketAssignmentState with _$TicketAssignmentState {
  const factory TicketAssignmentState({
    @Default({}) Map<String, String> assignments, // ticketId -> techId
    @Default(true) bool autoAssignmentEnabled,
    DateTime? lastAssignmentTime,
    @Default(false) bool isProcessing,
    String? errorMessage,
  }) = _TicketAssignmentState;
}

@freezed
class AssignmentResult with _$AssignmentResult {
  const factory AssignmentResult.success({
    required String ticketId,
    required String technicianId,
    required DateTime assignedAt,
  }) = _Success;
  
  const factory AssignmentResult.failed({
    required String reason,
    String? ticketId,
    String? technicianId,
  }) = _Failed;
}
