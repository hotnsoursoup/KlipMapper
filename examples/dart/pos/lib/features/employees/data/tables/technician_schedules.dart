// lib/core/database/tables/technician_schedules.dart
// Technician schedule table definition with proper foreign key constraints and time tracking in minutes since midnight. Supports weekly schedule management with effective date tracking.
// Usage: ACTIVE - Schedule management table for technician availability tracking

import 'package:drift/drift.dart';
import 'employees.dart';

@DataClassName('TechnicianSchedule')
class TechnicianSchedules extends Table {
  TextColumn get id => text()();
  
  // Foreign key to employees table
  IntColumn get employeeId => integer().named('employee_id')
      .references(Employees, #id, onDelete: KeyAction.cascade)();
  
  TextColumn get dayOfWeek => text().named('day_of_week')();
  BoolColumn get isScheduledOff => boolean().named('is_scheduled_off').withDefault(const Constant(false))();
  
  // Times as minutes since midnight (e.g., 540 = 9:00 AM, 1080 = 6:00 PM)
  IntColumn get startTime => integer().named('start_time').nullable()();
  IntColumn get endTime => integer().named('end_time').nullable()();
  
  DateTimeColumn get effectiveDate => dateTime().named('effective_date').nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (day_of_week IN (\'monday\', \'tuesday\', \'wednesday\', \'thursday\', \'friday\', \'saturday\', \'sunday\'))',
    'CHECK (start_time >= 0 AND start_time <= 1440 OR start_time IS NULL)', // 0 to 24 hours in minutes
    'CHECK (end_time >= 0 AND end_time <= 1440 OR end_time IS NULL)',
    'CHECK (start_time < end_time OR (start_time IS NULL AND end_time IS NULL))', // Valid time range
    'CHECK (NOT is_scheduled_off OR (start_time IS NULL AND end_time IS NULL))', // No times when scheduled off
    'UNIQUE(employee_id, day_of_week, effective_date)', // One schedule per employee per day per effective date
  ];
}
