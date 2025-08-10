// lib/features/shared/data/repositories/drift_time_entry_repository.dart
// Time tracking repository managing employee clock in/out operations, break tracking, and payroll calculations.
// Handles time entry CRUD operations, active session management, and generates comprehensive payroll reports.
// Usage: ACTIVE - Primary repository for employee time tracking and payroll data

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as database;
import '../../../../utils/error_logger.dart';
import '../models/time_entry_model.dart';

/// Drift-based repository for time entry data management
class DriftTimeEntryRepository {
  final database.PosDatabase _database;
  
  DriftTimeEntryRepository(this._database);
  
  /// Factory constructor to get instance with default database
  factory DriftTimeEntryRepository.instance() {
    return DriftTimeEntryRepository(database.PosDatabase.instance);
  }
  
  /// Get time entries for a specific employee and optional date
  Future<List<TimeEntry>> getTimeEntries({
    int? employeeId, 
    DateTime? date,
    int limit = 50,
  }) async {
    try {
      var query = _database.select(_database.timeEntries);
      
      if (employeeId != null) {
        query = query..where((t) => t.employeeId.equals(employeeId));
      }
      
      if (date != null) {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        query = query..where((t) => 
          t.clockIn.isBiggerOrEqualValue(startOfDay.toIso8601String()) &
          t.clockIn.isSmallerThanValue(endOfDay.toIso8601String()),
        );
      }
      
      query = query
        ..orderBy([(t) => OrderingTerm.desc(t.clockIn)])
        ..limit(limit);
      
      final dbEntries = await query.get();
      return dbEntries.map(_mapToTimeEntry).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error getting time entries', e, stack);
      return [];
    }
  }
  
  /// Watch time entries for real-time updates (for stream-based providers)
  Stream<List<TimeEntry>> watchTimeEntries({
    int? employeeId,
    DateTime? date,
    int limit = 50,
  }) {
    try {
      var query = _database.select(_database.timeEntries);
      
      if (employeeId != null) {
        query = query..where((t) => t.employeeId.equals(employeeId));
      }
      
      if (date != null) {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        query = query..where((t) => 
          t.clockIn.isBiggerOrEqualValue(startOfDay.toIso8601String()) &
          t.clockIn.isSmallerThanValue(endOfDay.toIso8601String()),
        );
      }
      
      query = query
        ..orderBy([(t) => OrderingTerm.desc(t.clockIn)])
        ..limit(limit);
      
      return query.watch().map((dbEntries) => 
        dbEntries.map(_mapToTimeEntry).toList()
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error watching time entries', e, stack);
      return Stream.value([]);
    }
  }
  
  /// Get the current active time entry for an employee (clocked in but not out)
  Future<TimeEntry?> getActiveTimeEntry(int employeeId) async {
    try {
      final query = _database.select(_database.timeEntries)
        ..where((t) => t.employeeId.equals(employeeId) & 
                      t.status.equals('active') &
                      t.clockOut.isNull(),);
      
      final dbEntry = await query.getSingleOrNull();
      return dbEntry != null ? _mapToTimeEntry(dbEntry) : null;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting active time entry', e, stack);
      return null;
    }
  }
  
  /// Clock in an employee
  Future<TimeEntry> clockIn(int employeeId, {String? notes}) async {
    try {
      // Check if employee is already clocked in
      final activeEntry = await getActiveTimeEntry(employeeId);
      if (activeEntry != null) {
        throw Exception('Employee is already clocked in');
      }
      
      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();
      
      final timeEntry = database.TimeEntriesCompanion(
        id: Value(id),
        employeeId: Value(employeeId),
        clockIn: Value(now.toIso8601String()),
        breakMinutes: const Value(0),
        status: const Value('active'),
        createdAt: Value(now.toIso8601String()),
        updatedAt: Value(now.toIso8601String()),
      );
      
      await _database.into(_database.timeEntries).insert(timeEntry);
      
      final dbEntry = await (_database.select(_database.timeEntries)
        ..where((t) => t.id.equals(id))).getSingle();
      
      ErrorLogger.logInfo('Employee $employeeId clocked in at ${now.toIso8601String()}');
      return _mapToTimeEntry(dbEntry);
    } catch (e, stack) {
      ErrorLogger.logError('Error clocking in employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// Clock out an employee
  Future<TimeEntry> clockOut(int employeeId, {String? notes}) async {
    try {
      // Get the active time entry
      final activeEntry = await getActiveTimeEntry(employeeId);
      if (activeEntry == null) {
        throw Exception('Employee is not currently clocked in');
      }
      
      final now = DateTime.now();
      final clockInTime = DateTime.parse(activeEntry.clockIn.toIso8601String());
      final duration = now.difference(clockInTime);
      final totalMinutes = duration.inMinutes - activeEntry.breakMinutes;
      final totalHours = totalMinutes / 60.0;
      
      final update = database.TimeEntriesCompanion(
        clockOut: Value(now.toIso8601String()),
        totalHours: Value(totalHours),
        status: const Value('completed'),
        updatedAt: Value(now.toIso8601String()),
      );
      
      await (_database.update(_database.timeEntries)
        ..where((t) => t.id.equals(activeEntry.id.toString()))).write(update);
      
      final dbEntry = await (_database.select(_database.timeEntries)
        ..where((t) => t.id.equals(activeEntry.id.toString()))).getSingle();
      
      ErrorLogger.logInfo('Employee $employeeId clocked out at ${now.toIso8601String()}. Total hours: ${totalHours.toStringAsFixed(2)}');
      return _mapToTimeEntry(dbEntry);
    } catch (e, stack) {
      ErrorLogger.logError('Error clocking out employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// Start a break for an active time entry
  Future<void> startBreak(int employeeId, String breakType) async {
    try {
      final activeEntry = await getActiveTimeEntry(employeeId);
      if (activeEntry == null) {
        throw Exception('Employee is not currently clocked in');
      }
      
      // Note: This is a simplified implementation
      // In a full system, you might track individual break periods
      ErrorLogger.logInfo('Employee $employeeId started $breakType break');
    } catch (e, stack) {
      ErrorLogger.logError('Error starting break for employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// End a break and add minutes to break time
  Future<void> endBreak(int employeeId, int breakMinutes) async {
    try {
      final activeEntry = await getActiveTimeEntry(employeeId);
      if (activeEntry == null) {
        throw Exception('Employee is not currently clocked in');
      }
      
      final newBreakMinutes = activeEntry.breakMinutes + breakMinutes;
      final update = database.TimeEntriesCompanion(
        breakMinutes: Value(newBreakMinutes),
        updatedAt: Value(DateTime.now().toIso8601String()),
      );
      
      await (_database.update(_database.timeEntries)
        ..where((t) => t.id.equals(activeEntry.id.toString()))).write(update);
      
      ErrorLogger.logInfo('Employee $employeeId ended break. Total break minutes: $newBreakMinutes');
    } catch (e, stack) {
      ErrorLogger.logError('Error ending break for employee $employeeId', e, stack);
      rethrow;
    }
  }
  
  /// Edit a time entry (for managers)
  Future<void> editTimeEntry(
    String timeEntryId, 
    Map<String, dynamic> updates,
    int editedByEmployeeId,
    String editReason,
  ) async {
    try {
      final now = DateTime.now();
      
      final companion = database.TimeEntriesCompanion(
        status: const Value('edited'),
        editedBy: Value(editedByEmployeeId.toString()),
        editReason: Value(editReason),
        updatedAt: Value(now.toIso8601String()),
      );
      
      // Apply specific updates
      if (updates.containsKey('clockIn')) {
        companion.copyWith(clockIn: Value(updates['clockIn'] as String));
      }
      if (updates.containsKey('clockOut')) {
        companion.copyWith(clockOut: Value(updates['clockOut'] as String));
      }
      if (updates.containsKey('breakMinutes')) {
        companion.copyWith(breakMinutes: Value(updates['breakMinutes'] as int));
      }
      
      await (_database.update(_database.timeEntries)
        ..where((t) => t.id.equals(timeEntryId))).write(companion);
      
      ErrorLogger.logInfo('Time entry $timeEntryId edited by employee $editedByEmployeeId. Reason: $editReason');
    } catch (e, stack) {
      ErrorLogger.logError('Error editing time entry $timeEntryId', e, stack);
      rethrow;
    }
  }
  
  /// Get employee hours summary for a date range
  Future<Map<String, dynamic>> getEmployeeHoursSummary(
    int employeeId, 
    DateTime startDate, 
    DateTime endDate,
  ) async {
    try {
      final entries = await getTimeEntries(
        employeeId: employeeId,
      );
      
      // Filter entries within date range
      final filteredEntries = entries.where((entry) {
        final clockInDate = DateTime.parse(entry.clockIn.toIso8601String());
        return clockInDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
               clockInDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
      
      double totalHours = 0;
      int totalBreakMinutes = 0;
      int daysWorked = 0;
      
      for (final entry in filteredEntries) {
        if (entry.status == 'completed') {
          totalHours += entry.calculatedHours;
          totalBreakMinutes += entry.breakMinutes;
          daysWorked++;
        }
      }
      
      return {
        'employeeId': employeeId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'totalHours': totalHours,
        'totalBreakMinutes': totalBreakMinutes,
        'daysWorked': daysWorked,
        'averageHoursPerDay': daysWorked > 0 ? totalHours / daysWorked : 0,
        'entries': filteredEntries.length,
      };
    } catch (e, stack) {
      ErrorLogger.logError('Error getting employee hours summary', e, stack);
      return {};
    }
  }
  
  /// Get payroll report for all employees in date range
  Future<List<Map<String, dynamic>>> getPayrollReport(
    DateTime startDate, 
    DateTime endDate,
  ) async {
    try {
      // Get all employees
      final employees = await _database.select(_database.employees).get();
      final payrollData = <Map<String, dynamic>>[];
      
      for (final employee in employees) {
        final summary = await getEmployeeHoursSummary(
          employee.id, 
          startDate, 
          endDate,
        );
        
        final hourlyRate = employee.hourlyRate ?? 0.0;
        final totalHours = summary['totalHours'] as double? ?? 0.0;
        final grossPay = totalHours * hourlyRate;
        
        payrollData.add({
          'employeeId': employee.id,
          'firstName': employee.firstName,
          'lastName': employee.lastName,
          'hourlyRate': hourlyRate,
          'totalHours': totalHours,
          'grossPay': grossPay,
          'daysWorked': summary['daysWorked'],
          'averageHoursPerDay': summary['averageHoursPerDay'],
        });
      }
      
      return payrollData;
    } catch (e, stack) {
      ErrorLogger.logError('Error generating payroll report', e, stack);
      return [];
    }
  }
  
  /// Helper method to map database TimeEntry to model TimeEntry
  TimeEntry _mapToTimeEntry(
    database.TimeEntry dbEntry,
  ) {
    return TimeEntry(
      id: int.tryParse(dbEntry.id) ?? 0, // Handle string ID parsing safely
      employeeId: dbEntry.employeeId,
      clockIn: dbEntry.clockIn,
      clockOut: dbEntry.clockOut,
      breakMinutes: dbEntry.breakMinutes,
      totalHours: dbEntry.totalHours,
      status: dbEntry.status,
      editedBy: dbEntry.editedBy?.toString(),
      editReason: dbEntry.editReason,
      createdAt: dbEntry.createdAt,
      updatedAt: dbEntry.updatedAt,
    );
  }
}
