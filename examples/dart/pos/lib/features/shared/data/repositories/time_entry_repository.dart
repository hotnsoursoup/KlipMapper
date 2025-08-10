// lib/features/shared/data/repositories/time_entry_repository.dart
// Legacy time entry repository that requires complete Drift migration to replace deprecated DatabaseService dependency.
// All methods throw UnimplementedError until DriftTimeEntryRepository integration is completed for time tracking operations.
// Usage: ORPHANED - Completely non-functional, requires full migration to Drift

import '../models/time_entry_model.dart';

/// Repository for time entry data management
/// CRITICAL: This repository needs full Drift migration - DatabaseService is deprecated
class TimeEntryRepository {
  // Singleton pattern
  static final TimeEntryRepository instance = TimeEntryRepository._internal();
  TimeEntryRepository._internal();

  /// All methods throw UnimplementedError until DriftTimeEntryRepository is created
  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<List<TimeEntry>> getTimeEntries({int? employeeId, DateTime? date}) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<TimeEntry?> getActiveTimeEntry(int employeeId) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<TimeEntry> clockIn(int employeeId, {String? notes}) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> clockOut(String timeEntryId, {String? notes}) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> startBreak(String timeEntryId, String breakType) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> endBreak(String timeEntryId) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> editTimeEntry(String timeEntryId, Map<String, dynamic> updates) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<Map<String, dynamic>> getEmployeeHoursSummary(int employeeId, DateTime startDate, DateTime endDate) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<List<Map<String, dynamic>>> getPayrollReport(DateTime startDate, DateTime endDate) async {
    throw UnimplementedError(
      'TimeEntryRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftTimeEntryRepository to replace this functionality.'
    );
  }
}