// lib/features/appointments/domain/providers/appointment_providers.dart
// Modern Riverpod providers for appointment management with auto-refreshing today's appointments and date range queries.
// Features real-time updates with 1-minute timer, CRUD operations, and intelligent caching for optimal performance.
// Usage: ACTIVE - Core appointment state management used throughout appointment screens and dashboard

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/repositories/drift_appointment_repository.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/database/daos/appointment_dao.dart' as dao;
import '../../../core/database/database.dart' as coredb;
import '../../data/models/calendar_view_mode.dart';

part 'appointment_providers.g.dart';

// ========== REPOSITORY PROVIDER ==========

@riverpod
DriftAppointmentRepository appointmentRepository(Ref ref) {
  return DriftAppointmentRepository.instance;
}

// ========== TODAY PROVIDERS ==========
// We split "today" into two use-cases:
// 1) Dashboard upcoming: only statuses scheduled|confirmed (time-aware)
// 2) Calendar day: all except cancelled/noShow/voided

List<String> _cancelledLikeStatuses = const ['cancelled', 'voided', 'noShow', 'no-show'];

@riverpod
class TodaysAppointments extends _$TodaysAppointments {
  Timer? _refreshTimer;

  @override
  Future<List<Appointment>> build() async {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.invalidateSelf();
    });
    ref.onDispose(() => _refreshTimer?.cancel());

    final repo = ref.read(appointmentRepositoryProvider);
    await repo.initialize();

    // Use optimized repo method for today, then filter for dashboard
    final allToday = await repo.getTodaysAppointments();

    final validStatuses = {'scheduled', 'confirmed'};
    final filtered = allToday
        .where((a) => validStatuses.contains(a.status))
        .toList()
      ..sort((a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));

    AppLogger.logInfo('TodaysDashboardAppointments: ${filtered.length}');
    return filtered;
  }

  Future<void> create(Appointment appointment) async {
    final repo = ref.read(appointmentRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.createAppointment(appointment);
      return await ref.refresh(todaysAppointmentsProvider.future);
    });
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final repo = ref.read(appointmentRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.updateAppointment(appointment);
      return await ref.refresh(todaysAppointmentsProvider.future);
    });
  }

  Future<void> cancel(String appointmentId, {String? reason}) async {
    final repo = ref.read(appointmentRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.updateAppointmentStatus(appointmentId, 'cancelled');
      if (reason != null && reason.isNotEmpty) {
        // optional: append cancellation note
        final current = await repo.getAppointmentById(appointmentId);
        if (current != null) {
          final newNotes = '${current.notes ?? ''}\nCancellation: $reason'.trim();
          await repo.updateAppointmentNotes(appointmentId, newNotes);
        }
      }
      return await ref.refresh(todaysAppointmentsProvider.future);
    });
  }
}

// ========== COMPAT ALIASES ==========
// Some screens still expect `appointmentsMasterProvider` as the primary async source.
// Alias it to the selected-date aware list to preserve behavior.
@riverpod
Future<List<Appointment>> appointmentsMaster(Ref ref) async {
  return await ref.watch(selectedDateAppointmentsProvider.future);
}

// ========== DETAIL PROVIDERS (with normalized join) ==========

@riverpod
Future<dao.AppointmentWithServices?> appointmentWithServices(
  Ref ref,
  String appointmentId,
) async {
  // Use typed DAO against the normalized join
  final db = coredb.PosDatabase.instance;
  final d = dao.AppointmentDao(db);
  return d.getAppointmentDetails(appointmentId);
}

// Lightweight helper for dashboard: upcoming appointments with services (today only)
@riverpod
Future<List<Appointment>> upcomingAppointmentsForDashboard(Ref ref) async {
  final list = await ref.watch(todaysAppointmentsProvider.future);
  final valid = {'scheduled', 'confirmed'};
  final upcoming = list
      .where((a) => valid.contains(a.status))
      .toList()
    ..sort((a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));
  return upcoming;
}

@riverpod
class TodaysCalendarAppointments extends _$TodaysCalendarAppointments {
  @override
  Future<List<Appointment>> build() async {
    final repo = ref.read(appointmentRepositoryProvider);
    await repo.initialize();
    // Prefer stream for live updates; fall back to one-shot fetch
    // Note: Keeping Future<T> signature to avoid broad refactors.
    final stream = repo.watchTodaysAppointmentsForCalendar();
    return await stream.first;
  }
}

// Lightweight action: mark appointment as checked-in (arrived)
// Kept as a top-level provider method to match dashboard usage
extension TodaysAppointmentsActions on TodaysAppointments {
  Future<void> checkInAppointment(String appointmentId) async {
    final repo = ref.read(appointmentRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.updateAppointmentStatus(appointmentId, 'arrived');
      // Refresh today datasets and derived selections
      ref.invalidate(todaysAppointmentsProvider);
      ref.invalidate(todaysCalendarAppointmentsProvider);
      ref.invalidate(selectedDateAppointmentsProvider);
      return await ref.refresh(todaysAppointmentsProvider.future);
    });
  }
}

// ========== DATE RANGE APPOINTMENTS PROVIDER ==========
// For calendar views showing non-today dates
// Uses family provider for automatic caching per date range

@riverpod
Future<List<Appointment>> appointmentsByDateRange(
  Ref ref,
  DateTimeRange dateRange,
) async {
  final repo = ref.read(appointmentRepositoryProvider);
  try {
    await repo.initialize();
    final list = await repo.getAppointments(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
    list.sort((a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));
    AppLogger.logInfo('AppointmentsByDateRange: ${list.length}');
    return list;
  } catch (e, stack) {
    AppLogger.logError('appointmentsByDateRange', e, stack);
    return [];
  }
}

@riverpod
Future<List<Appointment>> appointmentsByDateRangeForCalendar(
  Ref ref,
  DateTimeRange dateRange,
) async {
  final repo = ref.read(appointmentRepositoryProvider);
  await repo.initialize();
  // Stream for live updates; one-shot for current usage
  final stream = repo.watchAppointmentsByDateRange(
    dateRange.start,
    dateRange.end,
    excludeCancelledLike: true,
  );
  final list = await stream.first;
  return list
    ..sort((a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));
}

// ========== CUSTOMER APPOINTMENTS PROVIDER ==========

@riverpod
Future<List<Appointment>> customerAppointments(
  Ref ref,
  String customerId,
) async {
  final repository = ref.read(appointmentRepositoryProvider);
  
  try {
    await repository.initialize();
    final appointments = await repository.getCustomerAppointments(customerId);
    
    // Sort by start time (most recent first)
    appointments.sort((a, b) => b.scheduledStartTime.compareTo(a.scheduledStartTime));
    
    return appointments;
  } catch (e, stack) {
    AppLogger.logError('customerAppointments', e, stack);
    return [];
  }
}

// ========== TECHNICIAN APPOINTMENTS PROVIDER ==========

@riverpod
Future<List<Appointment>> technicianAppointments(
  Ref ref,
  String technicianId,
  {DateTime? date}
) async {
  // If date is today, use today's appointments for real-time updates
  final now = DateTime.now();
  if (date != null && 
      date.year == now.year && 
      date.month == now.month && 
      date.day == now.day) {
    final todaysAppointments = await ref.watch(todaysCalendarAppointmentsProvider.future);
    return todaysAppointments
        .where((apt) => (apt.assignedTechnicianId ?? apt.requestedTechnicianId) == technicianId)
        .toList();
  }
  
  // Otherwise fetch from database
  final repository = ref.read(appointmentRepositoryProvider);
  
  try {
    await repository.initialize();
    
    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final appointments = await repository.getAppointments(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      
      return appointments
          .where((apt) => (apt.assignedTechnicianId ?? apt.requestedTechnicianId) == technicianId)
          .toList()
        ..sort((a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));
    } else {
      // Get all appointments for this technician
      final appointments = await repository.getAppointments(employeeId: technicianId);
      
      appointments.sort((a, b) => b.scheduledStartTime.compareTo(a.scheduledStartTime));
      return appointments;
    }
  } catch (e, stack) {
    AppLogger.logError('technicianAppointments', e, stack);
    return [];
  }
}

// ========== UI STATE PROVIDERS ==========

/// Selected date for calendar views
@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();
  
  void setDate(DateTime date) {
    state = date;
  }
  
  void goToToday() {
    state = DateTime.now();
  }
  
  void previousDay() {
    state = state.subtract(const Duration(days: 1));
  }
  
  void nextDay() {
    state = state.add(const Duration(days: 1));
  }
}

// ========== COMPATIBILITY PROVIDERS ==========
// Add compatibility providers for old API

/// Appointment filters (compatibility with old API)
@riverpod
class AppointmentFilters extends _$AppointmentFilters {
  @override
  AppointmentFilterState build() => const AppointmentFilterState();
  
  void setTechnicianFilter(String? technicianId) {
    state = state.copyWith(selectedTechnicianId: technicianId);
  }
  
  void setTechnicianId(String? technicianId) {
    state = state.copyWith(selectedTechnicianId: technicianId);
  }
  
  void toggleServiceCategory(String category) {
    final categories = Set<String>.from(state.selectedServiceCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedServiceCategories: categories);
  }
  
  void setStatusFilter(String? status) {
    state = state.copyWith(selectedStatus: status);
  }
  
  void setStatus(String? status) {
    state = state.copyWith(selectedStatus: status);
  }
  
  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query ?? '');
  }
  
  void setCustomerFilter(String? query) {
    state = state.copyWith(searchQuery: query ?? '');
  }
  
  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  void setDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  void clearFilters() {
    state = const AppointmentFilterState();
  }
  
  void clearAllFilters() {
    state = const AppointmentFilterState();
  }
}

/// Calendar view mode (compatibility alias)
@riverpod
class AppointmentViewMode extends _$AppointmentViewMode {
  @override
  CalendarViewMode build() => CalendarViewMode.day;
  
  void setMode(CalendarViewMode mode) {
    state = mode;
  }
  
  void setViewMode(CalendarViewMode mode) {
    state = mode;
  }
}

/// Filtered appointments based on current filters (compatibility)
@riverpod
Future<List<Appointment>> filteredAppointments(Ref ref) async {
  final appointments = await ref.watch(selectedDateAppointmentsProvider.future);
  final filters = ref.watch(appointmentFiltersProvider);
  
  var filtered = appointments;
  
  // Apply technician filter
  if (filters.selectedTechnicianId != null) {
    filtered = filtered.where((apt) {
      final techId = apt.assignedTechnicianId ?? apt.requestedTechnicianId;
      return techId == filters.selectedTechnicianId;
    }).toList();
  }
  
  // Apply status filter
  if (filters.selectedStatus != null) {
    filtered = filtered.where((apt) => 
      apt.status == filters.selectedStatus
    ).toList();
  }
  
  // Apply search query
  if (filters.searchQuery.isNotEmpty) {
    final query = filters.searchQuery.toLowerCase();
    filtered = filtered.where((apt) {
      final notes = apt.notes?.toLowerCase() ?? '';
      return notes.contains(query);
    }).toList();
  }
  
  return filtered;
}

// ========== COMPATIBILITY DATA MODELS ==========

class AppointmentFilterState {
  final String? selectedTechnicianId;
  final Set<String> selectedServiceCategories;
  final String? selectedStatus;
  final String searchQuery;
  final bool showCancelled;
  final bool showCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  
  const AppointmentFilterState({
    this.selectedTechnicianId,
    this.selectedServiceCategories = const {},
    this.selectedStatus,
    this.searchQuery = '',
    this.showCancelled = false,
    this.showCompleted = false,
    this.startDate,
    this.endDate,
  });
  
  AppointmentFilterState copyWith({
    String? selectedTechnicianId,
    Set<String>? selectedServiceCategories,
    String? selectedStatus,
    String? searchQuery,
    bool? showCancelled,
    bool? showCompleted,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AppointmentFilterState(
      selectedTechnicianId: selectedTechnicianId ?? this.selectedTechnicianId,
      selectedServiceCategories: selectedServiceCategories ?? this.selectedServiceCategories,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      showCancelled: showCancelled ?? this.showCancelled,
      showCompleted: showCompleted ?? this.showCompleted,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Remove duplicate enum definitions. Consumers should import
// lib/features/appointments/data/models/calendar_view_mode.dart

// ========== ADDITIONAL COMPATIBILITY PROVIDERS ==========
// For appointments_screen.dart which expects these providers

/// Additional filter model for compatibility
class AppointmentFilter {
  final String? status;
  final String? technicianId;
  final DateTime? date;
  final String? search;
  
  const AppointmentFilter({
    this.status,
    this.technicianId,
    this.date,
    this.search,
  });
}

/// Provider for appointments filtered by AppointmentFilter (compatibility)
@riverpod
Future<List<Appointment>> appointmentsByFilter(Ref ref, AppointmentFilter filter) async {
  // Get base appointments
  List<Appointment> appointments;
  
  if (filter.date != null) {
    final startOfDay = DateTime(filter.date!.year, filter.date!.month, filter.date!.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final dateRange = DateTimeRange(start: startOfDay, end: endOfDay);
    appointments = await ref.watch(appointmentsByDateRangeProvider(dateRange).future);
  } else {
    appointments = await ref.watch(todaysAppointmentsProvider.future);
  }
  
  // Apply filters
  var filtered = appointments;
  
  if (filter.status != null && filter.status!.isNotEmpty && filter.status != 'All') {
    filtered = filtered.where((apt) => apt.status.toLowerCase() == filter.status!.toLowerCase()).toList();
  }
  
  if (filter.technicianId != null && filter.technicianId!.isNotEmpty) {
    filtered = filtered.where((apt) {
      final techId = apt.assignedTechnicianId ?? apt.requestedTechnicianId;
      return techId == filter.technicianId;
    }).toList();
  }
  
  if (filter.search != null && filter.search!.isNotEmpty) {
    final searchLower = filter.search!.toLowerCase();
    filtered = filtered.where((apt) =>
      (apt.customerName.toLowerCase().contains(searchLower) ?? false) ||
      (apt.notes?.toLowerCase().contains(searchLower) ?? false) ||
      (apt.services?.any((s) => s.name.toLowerCase().contains(searchLower)) ?? false)
    ).toList();
  }
  
  return filtered;
}

// ========== DERIVED PROVIDERS ==========

/// Get appointments for the selected date
/// Automatically uses today's provider or date range provider
@riverpod
Future<List<Appointment>> selectedDateAppointments(Ref ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final today = DateTime.now();
  
  // Check if selected date is today
  if (selectedDate.year == today.year &&
      selectedDate.month == today.month &&
      selectedDate.day == today.day) {
    // For calendar view, include all except cancelled/noShow
    return await ref.watch(todaysCalendarAppointmentsProvider.future);
  } else {
    // Use date range provider for other dates  
    final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final dateRange = DateTimeRange(
      start: startOfDay,
      end: endOfDay,
    );
    
    // Use the calendar-filtered date range provider
    return await ref.watch(appointmentsByDateRangeForCalendarProvider(dateRange).future);
  }
}

// Stream versions for live calendar updates
@riverpod
class SelectedDateAppointmentsStream extends _$SelectedDateAppointmentsStream {
  @override
  Stream<List<Appointment>> build() {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();
    final repo = ref.read(appointmentRepositoryProvider);

    if (selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day) {
      return repo.watchTodaysAppointmentsForCalendar();
    }

    final start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final end = start.add(const Duration(days: 1));
    return repo.watchAppointmentsByDateRange(start, end, excludeCancelledLike: true);
  }
}

@riverpod
class WeekAppointmentsForCalendarStream extends _$WeekAppointmentsForCalendarStream {
  @override
  Stream<List<Appointment>> build(DateTime anchorDay) {
    final start = DateTime(anchorDay.year, anchorDay.month, anchorDay.day);
    final end = start.add(const Duration(days: 7));
    final repo = ref.read(appointmentRepositoryProvider);
    return repo.watchAppointmentsByDateRange(start, end, excludeCancelledLike: true);
  }
}

/// Upcoming appointments count for dashboard
@riverpod
int upcomingAppointmentsCount(Ref ref) {
  final appointmentsAsync = ref.watch(todaysAppointmentsProvider);
  
  return appointmentsAsync.when(
    data: (appointments) {
      final now = DateTime.now();
      return appointments.where((apt) => apt.scheduledStartTime.isAfter(now)).length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Next appointment for dashboard
@riverpod
Appointment? nextAppointment(Ref ref) {
  final appointmentsAsync = ref.watch(todaysAppointmentsProvider);
  
  return appointmentsAsync.when(
    data: (appointments) {
      final now = DateTime.now();
      final upcoming = appointments.where((apt) => apt.scheduledStartTime.isAfter(now));
      return upcoming.isEmpty ? null : upcoming.first;
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Appointment statistics
@riverpod
AppointmentStatistics appointmentStatistics(Ref ref) {
  final appointmentsAsync = ref.watch(todaysAppointmentsProvider);
  
  return appointmentsAsync.when(
    data: (appointments) {
      final now = DateTime.now();
      final upcoming = appointments.where((apt) => apt.scheduledStartTime.isAfter(now));
      final past = appointments.where((apt) => apt.scheduledStartTime.isBefore(now));
      final confirmed = appointments.where((apt) => apt.status == 'confirmed');
      
      return AppointmentStatistics(
        total: appointments.length,
        upcoming: upcoming.length,
        completed: past.length,
        confirmed: confirmed.length,
      );
    },
    loading: () => const AppointmentStatistics(),
    error: (_, __) => const AppointmentStatistics(),
  );
}

// ========== WEEK VIEW ==========
// 7-day window anchored to provided day (inclusive start, exclusive end)

@riverpod
Future<List<Appointment>> weekAppointmentsForCalendar(
  Ref ref,
  DateTime anchorDay,
) async {
  final start = DateTime(anchorDay.year, anchorDay.month, anchorDay.day);
  final end = start.add(const Duration(days: 7));
  final range = DateTimeRange(start: start, end: end);
  return ref.watch(appointmentsByDateRangeForCalendarProvider(range).future);
}

class AppointmentStatistics {
  final int total;
  final int upcoming;
  final int completed;
  final int confirmed;
  
  const AppointmentStatistics({
    this.total = 0,
    this.upcoming = 0,
    this.completed = 0,
    this.confirmed = 0,
  });
}
