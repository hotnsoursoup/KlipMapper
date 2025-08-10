// lib/features/shared/providers/tickets_master_provider.dart
// Master tickets provider serving as single source of truth for ALL ticket data with 30-second auto-refresh and comprehensive filtering.
// Provides CRUD operations, complex filtering by status/technician/customer/type/search, and derived providers for queue management and statistics.
// Usage: ACTIVE - Core ticket data management used by dashboard queue system, ticket management, and analytics screens

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/ticket_model.dart';
import '../data/repositories/drift_ticket_repository.dart';
import '../../../utils/error_logger.dart';

part 'tickets_master_provider.g.dart';

/// Repository provider - single source of truth for repository access
@riverpod
DriftTicketRepository ticketRepository(Ref ref) {
  return DriftTicketRepository.instance;
}

/// Master tickets provider - single source of truth for ALL tickets
/// This is the ONLY provider that fetches tickets from the database
/// All other ticket providers should derive from this one
@riverpod
class TicketsMaster extends _$TicketsMaster {
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
    
    return _loadAllTickets();
  }
  
  Future<List<Ticket>> _loadAllTickets() async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.initialize();
      
      // Load ALL tickets from database (no filtering here)
      final tickets = await repo.getAllTickets();
      
      ErrorLogger.logInfo('TicketsMaster: Loaded ${tickets.length} total tickets');
      return tickets;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load master tickets', e, stack);
      throw Exception('Failed to load tickets: $e');
    }
  }
  
  /// Add a new ticket
  Future<void> addTicket(Ticket ticket) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.insertTicket(ticket);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to add ticket', e, stack);
      rethrow;
    }
  }
  
  /// Update an existing ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.updateTicket(ticket);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update ticket', e, stack);
      rethrow;
    }
  }
  
  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.updateTicketStatus(ticketId, newStatus);
      
      // Refresh the master list
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
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to assign technician', e, stack);
      rethrow;
    }
  }
  
  /// Delete a ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      final repo = ref.read(ticketRepositoryProvider);
      await repo.deleteTicket(ticketId);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete ticket', e, stack);
      rethrow;
    }
  }
  
  /// Force refresh tickets from database
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// ========== FILTER CLASSES ==========

/// Filter for tickets by date range
class TicketDateRangeFilter {
  final DateTime start;
  final DateTime end;
  
  const TicketDateRangeFilter({
    required this.start,
    required this.end,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketDateRangeFilter &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;
  
  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Complex filter for tickets
class TicketFilter {
  final String? status;
  final String? technicianId;
  final String? customerId;
  final String? type; // walk-in, appointment
  final TicketDateRangeFilter? dateRange;
  final String? search;
  
  const TicketFilter({
    this.status,
    this.technicianId,
    this.customerId,
    this.type,
    this.dateRange,
    this.search,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketFilter &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          technicianId == other.technicianId &&
          customerId == other.customerId &&
          type == other.type &&
          dateRange == other.dateRange &&
          search == other.search;
  
  @override
  int get hashCode =>
      status.hashCode ^
      technicianId.hashCode ^
      customerId.hashCode ^
      type.hashCode ^
      dateRange.hashCode ^
      search.hashCode;
}

// ========== FAMILY PROVIDERS FOR FILTERING ==========

/// Provider for tickets filtered by date range
/// Uses family to enable caching per date range
@riverpod
List<Ticket> ticketsByDateRange(Ref ref, TicketDateRangeFilter dateRange) {
  // Watch the master list
  final allTicketsAsync = ref.watch(ticketsMasterProvider);
  
  return allTicketsAsync.when(
    data: (tickets) {
      return tickets.where((ticket) {
        final checkIn = ticket.checkInTime;
        return checkIn.isAfter(dateRange.start) && 
               checkIn.isBefore(dateRange.end);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for tickets filtered by complex criteria
/// Uses family to enable caching per filter combination
@riverpod
List<Ticket> ticketsByFilter(Ref ref, TicketFilter filter) {
  // Watch the master list
  final allTicketsAsync = ref.watch(ticketsMasterProvider);
  
  return allTicketsAsync.when(
    data: (tickets) {
      var filtered = tickets;
      
      // Apply status filter
      if (filter.status != null) {
        filtered = filtered.where((t) => t.status == filter.status).toList();
      }
      
      // Apply technician filter
      if (filter.technicianId != null) {
        filtered = filtered.where((t) => 
          t.assignedTechnicianId == filter.technicianId
        ).toList();
      }
      
      // Apply customer filter
      if (filter.customerId != null) {
        filtered = filtered.where((t) => 
          t.customerId == filter.customerId
        ).toList();
      }
      
      // Apply type filter
      if (filter.type != null) {
        filtered = filtered.where((t) => t.type == filter.type).toList();
      }
      
      // Apply date range filter
      if (filter.dateRange != null) {
        filtered = filtered.where((t) {
          final checkIn = t.checkInTime;
          return checkIn.isAfter(filter.dateRange!.start) && 
                 checkIn.isBefore(filter.dateRange!.end);
        }).toList();
      }
      
      // Apply search filter
      if (filter.search != null && filter.search!.isNotEmpty) {
        final query = filter.search!.toLowerCase();
        filtered = filtered.where((t) =>
          t.ticketNumber.toLowerCase().contains(query) ||
          t.customer.name.toLowerCase().contains(query) ||
          t.services.any((s) => s.name.toLowerCase().contains(query))
        ).toList();
      }
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// ========== COMPOSED PROVIDERS FOR COMMON VIEWS ==========

/// Provider for today's date range
@riverpod
TicketDateRangeFilter todaysDateRange(Ref ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return TicketDateRangeFilter(start: start, end: end);
}

/// Provider for TODAY's tickets (used by dashboard)
@riverpod
List<Ticket> todaysTickets(Ref ref) {
  final today = ref.watch(todaysDateRangeProvider);
  return ref.watch(ticketsByDateRangeProvider(today));
}

/// Provider for queued tickets only (used by dashboard queue section)
@riverpod
List<Ticket> queuedTickets(Ref ref) {
  return ref.watch(ticketsByFilterProvider(
    const TicketFilter(status: 'queued'),
  ));
}

/// Provider for in-service tickets (used by dashboard)
@riverpod
List<Ticket> inServiceTickets(Ref ref) {
  return ref.watch(ticketsByFilterProvider(
    const TicketFilter(status: 'in-service'),
  ));
}

/// Provider for tickets assigned to a specific technician
@riverpod
List<Ticket> technicianTickets(Ref ref, String technicianId) {
  return ref.watch(ticketsByFilterProvider(
    TicketFilter(technicianId: technicianId),
  ));
}

/// Provider for ticket statistics
@riverpod
TicketStatistics ticketStatistics(Ref ref) {
  final allTicketsAsync = ref.watch(ticketsMasterProvider);
  
  return allTicketsAsync.when(
    data: (tickets) {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      
      final todayCount = tickets.where((t) =>
        t.checkInTime.isAfter(todayStart) && 
        t.checkInTime.isBefore(todayEnd)
      ).length;
      
      final queuedCount = tickets.where((t) => t.status == 'queued').length;
      final inServiceCount = tickets.where((t) => t.status == 'in-service').length;
      final completedCount = tickets.where((t) => 
        t.status == 'completed' || t.status == 'paid'
      ).length;
      
      return TicketStatistics(
        todayCount: todayCount,
        queuedCount: queuedCount,
        inServiceCount: inServiceCount,
        completedCount: completedCount,
      );
    },
    loading: () => const TicketStatistics(),
    error: (_, __) => const TicketStatistics(),
  );
}

/// Ticket statistics model
class TicketStatistics {
  final int todayCount;
  final int queuedCount;
  final int inServiceCount;
  final int completedCount;
  
  const TicketStatistics({
    this.todayCount = 0,
    this.queuedCount = 0,
    this.inServiceCount = 0,
    this.completedCount = 0,
  });
}