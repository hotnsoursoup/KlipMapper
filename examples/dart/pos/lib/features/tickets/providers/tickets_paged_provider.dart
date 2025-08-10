// lib/features/tickets/providers/tickets_paged_provider.dart
// Paged Riverpod provider for ticket management with auto-refreshing active tickets and paginated history views.
// Features 30-second auto-refresh for real-time queue updates, CRUD operations, and filtered views with statistics calculation.
// Usage: ACTIVE - Core ticket state management used by dashboard queue system and ticket management screens

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../../utils/error_logger.dart';

part 'tickets_paged_provider.g.dart';

/// Repository provider - single source of truth for repository access
@riverpod
DriftTicketRepository ticketRepository(Ref ref) {
  return DriftTicketRepository.instance;
}

/// Active tickets provider - only loads today's active tickets
/// Auto-refreshes every 30 seconds for real-time updates
/// Used by Dashboard for queue management
@riverpod
class ActiveTickets extends _$ActiveTickets {
  Timer? _refreshTimer;
  
  @override
  Future<List<Ticket>> build() async {
    // Set up auto-refresh every 30 seconds for real-time updates
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidateSelf();
    });
    
    // Clean up timer on dispose
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });
    
    return _loadActiveTickets();
  }
  
  Future<List<Ticket>> _loadActiveTickets() async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.initialize();
      
      // Only fetch ACTIVE tickets (queued, assigned, in-service)
      final tickets = await repo.getActiveTickets();
      
      // Sort by check-in time (FIFO)
      tickets.sort((a, b) => a.checkInTime.compareTo(b.checkInTime));
      
      ErrorLogger.logInfo('ActiveTickets: Loaded ${tickets.length} active tickets');
      return tickets;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load active tickets', e, stack);
      throw Exception('Failed to load tickets: $e');
    }
  }
  
  /// Add a new ticket to queue
  Future<void> addTicket(Ticket ticket) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.insertTicket(ticket);
      
      // Refresh active tickets
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to add ticket', e, stack);
      rethrow;
    }
  }
  
  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.updateTicketStatus(ticketId, newStatus);
      
      // Refresh active tickets
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update ticket status', e, stack);
      rethrow;
    }
  }
  
  /// Assign technician to ticket
  Future<void> assignTechnician(String ticketId, String technicianId) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.assignTechnician(ticketId, technicianId);
      
      // Refresh active tickets
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to assign technician', e, stack);
      rethrow;
    }
  }
  
  /// Force refresh
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Queued tickets only - subset of active tickets
@riverpod
List<Ticket> queuedTickets(Ref ref) {
  final activeTicketsAsync = ref.watch(activeTicketsProvider);
  
  return activeTicketsAsync.when(
    data: (tickets) => tickets.where((t) => t.status == 'queued').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// In-service tickets only - subset of active tickets
@riverpod
List<Ticket> inServiceTickets(Ref ref) {
  final activeTicketsAsync = ref.watch(activeTicketsProvider);
  
  return activeTicketsAsync.when(
    data: (tickets) => tickets.where((t) => t.status == 'in-service').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Assigned tickets only - subset of active tickets
@riverpod
List<Ticket> assignedTickets(Ref ref) {
  final activeTicketsAsync = ref.watch(activeTicketsProvider);
  
  return activeTicketsAsync.when(
    data: (tickets) => tickets.where((t) => t.status == 'assigned').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Tickets for a specific technician - filtered from active tickets
@riverpod
List<Ticket> technicianTickets(Ref ref, String technicianId) {
  final activeTicketsAsync = ref.watch(activeTicketsProvider);
  
  return activeTicketsAsync.when(
    data: (tickets) => tickets
        .where((t) => t.assignedTechnicianId == technicianId)
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Historical tickets with pagination - for Tickets Management Screen
/// This does NOT auto-refresh as it's for viewing history
@riverpod
class TicketHistory extends _$TicketHistory {
  static const int _pageSize = 20;
  
  @override
  Future<TicketHistoryState> build() async {
    return _loadTickets();
  }
  
  Future<TicketHistoryState> _loadTickets({
    int page = 1,
    String? search,
    String? status,
    DateTimeRange? dateRange,
  }) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      
      // Get total count for pagination
      final totalCount = await repo.getTicketsCount(
        status: status,
        date: dateRange?.start?.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      );
      
      // Load tickets for current page
      final tickets = await repo.getTickets(
        limit: _pageSize,
        offset: (page - 1) * _pageSize,
        status: status,
        date: dateRange?.start?.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      );
      
      return TicketHistoryState(
        tickets: tickets,
        currentPage: page,
        totalPages: (totalCount / _pageSize).ceil(),
        totalCount: totalCount,
        search: search,
        status: status,
        dateRange: dateRange,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load ticket history', e, stack);
      return TicketHistoryState(
        errorMessage: 'Failed to load tickets: $e',
      );
    }
  }
  
  /// Change page
  Future<void> goToPage(int page) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadTickets(
      page: page,
      search: currentState.search,
      status: currentState.status,
      dateRange: currentState.dateRange,
    ));
  }
  
  /// Apply filters
  Future<void> applyFilters({
    String? search,
    String? status,
    DateTimeRange? dateRange,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadTickets(
      search: search,
      status: status,
      dateRange: dateRange,
    ));
  }
  
  /// Refresh current page
  Future<void> refresh() async {
    final currentState = state.value;
    if (currentState == null) {
      state = await AsyncValue.guard(() => _loadTickets());
    } else {
      state = await AsyncValue.guard(() => _loadTickets(
        page: currentState.currentPage,
        search: currentState.search,
        status: currentState.status,
        dateRange: currentState.dateRange,
      ));
    }
  }
}

/// State model for ticket history with pagination
class TicketHistoryState {
  final List<Ticket> tickets;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final String? search;
  final String? status;
  final DateTimeRange? dateRange;
  final bool isLoading;
  final String? errorMessage;
  
  const TicketHistoryState({
    this.tickets = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.search,
    this.status,
    this.dateRange,
    this.isLoading = false,
    this.errorMessage,
  });
}

/// Today's completed tickets - for reporting
@riverpod
Future<List<Ticket>> todaysCompletedTickets(Ref ref) async {
  try {
    final repo = ref.read(ticketRepositoryProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final tickets = await repo.getTicketsByDateRange(
      startOfDay,
      endOfDay,
      status: 'completed',
    );
    
    return tickets;
  } catch (e, stack) {
    ErrorLogger.logError('Failed to load today\'s completed tickets', e, stack);
    return [];
  }
}

/// Ticket statistics for dashboard
@riverpod
TicketStatistics ticketStatistics(Ref ref) {
  final activeTicketsAsync = ref.watch(activeTicketsProvider);
  
  return activeTicketsAsync.when(
    data: (tickets) {
      final queuedCount = tickets.where((t) => t.status == 'queued').length;
      final assignedCount = tickets.where((t) => t.status == 'assigned').length;
      final inServiceCount = tickets.where((t) => t.status == 'in-service').length;
      
      // Calculate average wait time for queued tickets
      final queuedTickets = tickets.where((t) => t.status == 'queued');
      double avgWaitMinutes = 0;
      if (queuedTickets.isNotEmpty) {
        final now = DateTime.now();
        final totalWaitMinutes = queuedTickets.fold<int>(
          0,
          (sum, ticket) => sum + now.difference(ticket.checkInTime).inMinutes,
        );
        avgWaitMinutes = totalWaitMinutes / queuedTickets.length;
      }
      
      return TicketStatistics(
        totalActive: tickets.length,
        queuedCount: queuedCount,
        assignedCount: assignedCount,
        inServiceCount: inServiceCount,
        averageWaitMinutes: avgWaitMinutes.round(),
      );
    },
    loading: () => const TicketStatistics(),
    error: (_, __) => const TicketStatistics(),
  );
}

/// Ticket statistics model
class TicketStatistics {
  final int totalActive;
  final int queuedCount;
  final int assignedCount;
  final int inServiceCount;
  final int averageWaitMinutes;
  
  const TicketStatistics({
    this.totalActive = 0,
    this.queuedCount = 0,
    this.assignedCount = 0,
    this.inServiceCount = 0,
    this.averageWaitMinutes = 0,
  });
}