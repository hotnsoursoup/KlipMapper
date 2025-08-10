// lib/features/tickets/providers/live_tickets_provider.dart
// Live tickets: master stream + derived per-technician lists with clock-in gating.
// Master stream watches today+active statuses; per-tech lists derive in memory
// and only surface tickets when the technician is clocked in.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../shared/data/repositories/drift_time_entry_repository.dart';

part 'live_tickets_provider.g.dart';

// Repository providers
@riverpod
DriftTicketRepository liveTicketRepository(Ref ref) =>
    DriftTicketRepository.instance;

@riverpod
DriftTimeEntryRepository timeEntryRepository(Ref ref) =>
    DriftTimeEntryRepository.instance();

// Master live tickets for today with active statuses
@riverpod
Stream<List<Ticket>> liveTicketsToday(Ref ref) {
  final repo = ref.watch(liveTicketRepositoryProvider);
  return repo.watchTicketsForTodayActive();
}

// Set of clocked-in technician IDs (as strings) for today - now a stream for instant updates
@riverpod
Stream<Set<String>> clockedInTechnicianIds(Ref ref) {
  final timeRepo = ref.watch(timeEntryRepositoryProvider);
  final today = DateTime.now();
  
  // Watch time entries for today - updates instantly when clock status changes
  return timeRepo.watchTimeEntries(date: today, limit: 1000).map((entries) {
    final set = <String>{};
    for (final e in entries) {
      final isActive = e.status == 'active' && e.clockOut == null;
      if (isActive) set.add(e.employeeId);
    }
    return set;
  });
}

// Derived: tickets for a technician; only surface when tech is clocked in
@riverpod
List<Ticket> ticketsByTechnician(Ref ref, String technicianId) {
  final all = ref.watch(liveTicketsTodayProvider).value ?? const <Ticket>[];
  final clocked = ref
      .watch(clockedInTechnicianIdsProvider)
      .value ?? const <String>{};

  // If not clocked in, don't move tickets to this tech's status yet
  if (!clocked.contains(technicianId)) return const <Ticket>[];

  return all.where((t) => t.assignedTechnicianId == technicianId).toList();
}
