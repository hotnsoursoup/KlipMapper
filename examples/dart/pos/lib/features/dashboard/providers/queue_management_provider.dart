// lib/features/dashboard/providers/queue_management_provider.dart
// Riverpod provider for managing ticket queue operations with filtering, FIFO ordering, and real-time queue state management.
// Handles queue ticket loading, filtering by type, priority sorting, and provides computed providers for queue analytics.
// Usage: ACTIVE - Core queue management system used by dashboard screens and ticket assignment system

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../tickets/providers/live_tickets_provider.dart';
import '../../../utils/error_logger.dart';

part 'queue_management_provider.g.dart';
part 'queue_management_provider.freezed.dart';

/// Queue management provider for managing queue tickets and filtering
/// Converted from queue_management_store.dart
@riverpod
class QueueManagement extends _$QueueManagement {
  @override
  Future<QueueManagementState> build() async {
    // Drive queue from live tickets master stream
    final live = ref.watch(liveTicketsTodayProvider);
    return live.when(
      data: (allTickets) {
        final todaysQueuedTickets = allTickets
            .where((t) => t.status == 'queued')
            .toList();
        ErrorLogger.logInfo('QueueManagementProvider: Loaded ${todaysQueuedTickets.length} queued tickets');
        return QueueManagementState(
          queueTickets: todaysQueuedTickets,
          lastUpdated: DateTime.now(),
        );
      },
      loading: () => QueueManagementState(
        lastUpdated: DateTime.now(),
      ),
      error: (e, stack) {
        ErrorLogger.logError('QueueManagementProvider.build', e, stack);
        return QueueManagementState(
          errorMessage: 'Failed to load queue tickets: $e',
          lastUpdated: DateTime.now(),
        );
      },
    );
  }
  
  /// Set filter for queue display
  void setFilter(QueueFilter filter) {
    state = AsyncValue.data(
      state.value!.copyWith(currentFilter: filter),
    );
    ErrorLogger.logInfo('QueueManagementProvider: Filter changed to ${filter.runtimeType}');
  }
  
  /// Remove ticket from queue
  void removeTicketFromQueue(String ticketId) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final updatedTickets = currentState.queueTickets
        .where((ticket) => ticket.id != ticketId)
        .toList();
    
    state = AsyncValue.data(
      currentState.copyWith(queueTickets: updatedTickets),
    );
    ErrorLogger.logInfo('QueueManagementProvider: Removed ticket $ticketId from queue');
  }
  
  /// Remove multiple assigned tickets
  void removeAssignedTickets(Iterable<String> ticketIds) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final updatedTickets = currentState.queueTickets
        .where((ticket) => !ticketIds.contains(ticket.id))
        .toList();
    
    state = AsyncValue.data(
      currentState.copyWith(queueTickets: updatedTickets),
    );
    ErrorLogger.logInfo('QueueManagementProvider: Removed ${ticketIds.length} assigned tickets');
  }
  
  /// Add ticket to queue
  void addTicketToQueue(Ticket ticket) {
    if (ticket.status != 'queued') return;
    
    final currentState = state.value;
    if (currentState == null) return;
    
    final updatedTickets = [...currentState.queueTickets, ticket];
    
    state = AsyncValue.data(
      currentState.copyWith(queueTickets: updatedTickets),
    );
    ErrorLogger.logInfo('QueueManagementProvider: Added ticket ${ticket.id} to queue');
  }
  
  /// Refresh queue data
  Future<void> refreshQueue() async {
    // Invalidate live tickets; the stream will push updates
    ref.invalidate(liveTicketsTodayProvider);
  }
}

// ========== REPOSITORY PROVIDER ==========

@riverpod
DriftTicketRepository ticketRepository(TicketRepositoryRef ref) {
  return DriftTicketRepository.instance;
}

// ========== COMPUTED PROVIDERS ==========

/// Filtered tickets based on current filter
@riverpod
List<Ticket> filteredQueueTickets(FilteredQueueTicketsRef ref) {
  final state = ref.watch(queueManagementProvider).value;
  if (state == null) return [];
  
  // Sort tickets by check-in time (FIFO)
  final tickets = List<Ticket>.from(state.queueTickets)
    ..sort((a, b) => a.checkInTime.compareTo(b.checkInTime));
  
  // Apply current filter
  return tickets.where((ticket) {
    // Primary requirement: Only show "queued" status tickets
    if (ticket.status != 'queued') return false;
    
    // Apply user filter
    return state.currentFilter.when(
      all: () => true,
      walkIn: () => ticket.type == 'walk-in',
      appointment: () => ticket.type == 'appointment',
      completed: () => ticket.status == 'completed' || ticket.status == 'paid',
    );
  }).toList();
}

/// Queue length
@riverpod
int queueLength(QueueLengthRef ref) {
  return ref.watch(filteredQueueTicketsProvider).length;
}

/// Waiting customers count (queued tickets only)
@riverpod
int waitingCustomersCount(WaitingCustomersCountRef ref) {
  final state = ref.watch(queueManagementProvider).value;
  if (state == null) return 0;
  
  return state.queueTickets.where((ticket) => ticket.status == 'queued').length;
}

/// Next ticket in FIFO order
@riverpod
Ticket? nextTicket(NextTicketRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  return filtered.isNotEmpty ? filtered.first : null;
}

/// Priority tickets
@riverpod
List<Ticket> priorityTickets(PriorityTicketsRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  return filtered.where((t) => t.priority != null && t.priority! > 0).toList();
}

/// Walk-in tickets only
@riverpod
List<Ticket> walkInTickets(WalkInTicketsRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  return filtered.where((t) => t.type == 'walk-in').toList();
}

/// Appointment tickets only
@riverpod
List<Ticket> appointmentTickets(AppointmentTicketsRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  return filtered.where((t) => t.type == 'appointment').toList();
}

/// Group tickets by service category
@riverpod
Map<String, List<Ticket>> ticketsByServiceCategory(TicketsByServiceCategoryRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  final Map<String, List<Ticket>> grouped = {};
  
  for (final ticket in filtered) {
    for (final service in ticket.services) {
      final categoryId = service.categoryId.toString();
      grouped[categoryId] = (grouped[categoryId] ?? [])..add(ticket);
    }
  }
  
  return grouped;
}

/// Check if queue has unassigned tickets
@riverpod
bool hasUnassignedTickets(HasUnassignedTicketsRef ref) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  return filtered.any((t) => 
    t.assignedTechnicianId == null || t.assignedTechnicianId!.isEmpty);
}

/// Estimated wait time for next ticket
@riverpod
Duration estimatedWaitTime(EstimatedWaitTimeRef ref) {
  final queueLen = ref.watch(queueLengthProvider);
  if (queueLen == 0) return Duration.zero;
  
  // Simple estimation: assume 30 minutes per ticket
  const avgServiceTime = Duration(minutes: 30);
  return avgServiceTime * queueLen;
}

// ========== HELPER PROVIDERS ==========

/// Get ticket by ID
@riverpod
Ticket? getTicketById(GetTicketByIdRef ref, String ticketId) {
  final state = ref.watch(queueManagementProvider).value;
  if (state == null) return null;
  
  try {
    return state.queueTickets.firstWhere((ticket) => ticket.id == ticketId);
  } catch (e) {
    return null;
  }
}

/// Get queue position for ticket
@riverpod
int getQueuePosition(GetQueuePositionRef ref, String ticketId) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  final index = filtered.indexWhere((t) => t.id == ticketId);
  return index >= 0 ? index + 1 : -1; // 1-based position
}

/// Get tickets for technician categories
@riverpod
List<Ticket> getTicketsForTechnicianCategories(
  GetTicketsForTechnicianCategoriesRef ref,
  List<String> technicianCategories,
) {
  final filtered = ref.watch(filteredQueueTicketsProvider);
  
  return filtered.where((ticket) {
    return ticket.services.any((service) =>
      technicianCategories.contains(service.categoryId?.toString()) ||
      technicianCategories.contains('general')
    );
  }).toList();
}

// ========== STATE MODELS ==========

@freezed
class QueueManagementState with _$QueueManagementState {
  const factory QueueManagementState({
    @Default([]) List<Ticket> queueTickets,
    @Default(QueueFilter.all()) QueueFilter currentFilter,
    String? errorMessage,
    DateTime? lastUpdated,
  }) = _QueueManagementState;
}

@freezed
class QueueFilter with _$QueueFilter {
  const factory QueueFilter.all() = _All;
  const factory QueueFilter.walkIn() = _WalkIn;
  const factory QueueFilter.appointment() = _Appointment;
  const factory QueueFilter.completed() = _Completed;
}
