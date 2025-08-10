// lib/features/shared/data/repositories/drift_schedule_repository.dart
// Repository for technician schedule management using Drift ORM for employee scheduling operations.
// Manages weekly schedules, day-off tracking, and time conversion utilities with transaction-safe operations.
// Usage: ACTIVE - Primary repository for employee scheduling and work time management

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../../../../utils/error_logger.dart';

/// Drift-based TechnicianSchedule Repository
/// Manages employee schedule operations with type-safe ORM queries
class DriftScheduleRepository {
  static DriftScheduleRepository? _instance;
  static DriftScheduleRepository get instance => _instance ??= DriftScheduleRepository._();
  
  DriftScheduleRepository._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      // Ensure database is fully initialized
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftScheduleRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftScheduleRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Get schedule for a specific employee
  Future<List<db.TechnicianSchedule>> getEmployeeSchedule(int employeeId) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }
      
      final schedules = await (_database!.select(_database!.technicianSchedules)
            ..where((s) => s.employeeId.equals(employeeId) & s.isActive.equals(true))
            ..orderBy([
              (s) => OrderingTerm(expression: s.dayOfWeek),
            ]))
          .get();
      
      return schedules;
    } catch (e, stack) {
      ErrorLogger.logError('Error fetching employee schedule for employee $employeeId', e, stack);
      rethrow;
    }
  }

  /// Get all schedules (for managers to view all employee schedules)
  Future<List<db.TechnicianSchedule>> getAllSchedules() async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }
      
      final schedules = await (_database!.select(_database!.technicianSchedules)
            ..where((s) => s.isActive.equals(true))
            ..orderBy([
              (s) => OrderingTerm(expression: s.employeeId),
              (s) => OrderingTerm(expression: s.dayOfWeek),
            ]))
          .get();
      
      return schedules;
    } catch (e, stack) {
      ErrorLogger.logError('Error fetching all schedules', e, stack);
      rethrow;
    }
  }

  /// Create or update employee schedule
  Future<void> saveEmployeeSchedule(int employeeId, List<WeeklySchedule> weeklySchedule) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      // Transaction to ensure all operations succeed or fail together
      await _database!.transaction(() async {
        // First, deactivate all existing schedules for this employee
        await (_database!.update(_database!.technicianSchedules)
              ..where((s) => s.employeeId.equals(employeeId)))
            .write(const db.TechnicianSchedulesCompanion(
              isActive: Value(false),
            ),);

        // Insert new schedule records
        for (final daySchedule in weeklySchedule) {
          if (daySchedule.isScheduledOff || (daySchedule.startTime != null && daySchedule.endTime != null)) {
            await _database!.into(_database!.technicianSchedules).insert(
              db.TechnicianSchedulesCompanion.insert(
                id: _generateScheduleId(employeeId, daySchedule.dayOfWeek),
                employeeId: employeeId,
                dayOfWeek: daySchedule.dayOfWeek,
                isScheduledOff: Value(daySchedule.isScheduledOff),
                startTime: Value(daySchedule.startTime),
                endTime: Value(daySchedule.endTime),
                effectiveDate: Value(DateTime.now()),
                notes: Value(daySchedule.notes),
                isActive: const Value(true),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
        }
      });

      ErrorLogger.logInfo('Schedule saved for employee $employeeId');
    } catch (e, stack) {
      ErrorLogger.logError('Error saving employee schedule for employee $employeeId', e, stack);
      rethrow;
    }
  }

  /// Delete schedule for an employee (sets inactive)
  Future<void> deleteEmployeeSchedule(int employeeId) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      await (_database!.update(_database!.technicianSchedules)
            ..where((s) => s.employeeId.equals(employeeId)))
          .write(const db.TechnicianSchedulesCompanion(
            isActive: Value(0),
          ),);

      ErrorLogger.logInfo('Schedule deleted for employee $employeeId');
    } catch (e, stack) {
      ErrorLogger.logError('Error deleting employee schedule for employee $employeeId', e, stack);
      rethrow;
    }
  }

  /// Generate unique ID for schedule record
  String _generateScheduleId(int employeeId, String dayOfWeek) {
    return '${employeeId}_${dayOfWeek}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get the day order for sorting
  static int getDayOrder(String dayOfWeek) {
    const dayOrder = {
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
      'sunday': 7,
    };
    return dayOrder[dayOfWeek.toLowerCase()] ?? 8;
  }

  /// Convert time in minutes to readable format (e.g., 540 -> "9:00 AM")
  static String formatTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString()}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Convert readable time to minutes (e.g., "9:00 AM" -> 540)
  static int parseTime(String timeString) {
    final parts = timeString.split(' ');
    final timePart = parts[0];
    final period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';
    
    final timeParts = timePart.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
    
    int totalMinutes = (hour % 12) * 60 + minute;
    if (period == 'PM' && hour != 12) {
      totalMinutes += 12 * 60;
    }
    
    return totalMinutes;
  }
}

/// Model for weekly schedule data
class WeeklySchedule {
  final String dayOfWeek;
  final bool isScheduledOff;
  final int? startTime; // Minutes since midnight
  final int? endTime; // Minutes since midnight
  final String? notes;

  const WeeklySchedule({
    required this.dayOfWeek,
    this.isScheduledOff = false,
    this.startTime,
    this.endTime,
    this.notes,
  });

  /// Create from TechnicianSchedule database record
  factory WeeklySchedule.fromDb(db.TechnicianSchedule schedule) {
    return WeeklySchedule(
      dayOfWeek: schedule.dayOfWeek,
      isScheduledOff: schedule.isScheduledOff == 1,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      notes: schedule.notes,
    );
  }

  /// Create a default working day schedule (9 AM - 6 PM)
  factory WeeklySchedule.defaultWorkingDay(String dayOfWeek) {
    return WeeklySchedule(
      dayOfWeek: dayOfWeek,
      startTime: 540, // 9:00 AM
      endTime: 1080, // 6:00 PM
    );
  }

  /// Create a scheduled off day
  factory WeeklySchedule.dayOff(String dayOfWeek) {
    return WeeklySchedule(
      dayOfWeek: dayOfWeek,
      isScheduledOff: true,
    );
  }

  WeeklySchedule copyWith({
    String? dayOfWeek,
    bool? isScheduledOff,
    int? startTime,
    int? endTime,
    String? notes,
  }) {
    return WeeklySchedule(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isScheduledOff: isScheduledOff ?? this.isScheduledOff,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    if (isScheduledOff) {
      return '$dayOfWeek: Off';
    }
    final start = startTime != null ? DriftScheduleRepository.formatTime(startTime!) : 'Unknown';
    final end = endTime != null ? DriftScheduleRepository.formatTime(endTime!) : 'Unknown';
    return '$dayOfWeek: $start - $end';
  }
}
