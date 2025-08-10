// lib/core/database/tables/time_entries.dart
// Time entry table definition for employee clock in/out tracking with proper foreign key constraints, break tracking, and audit trail support.
// Usage: ACTIVE - Time tracking table for employee hours and payroll integration

import 'package:drift/drift.dart';
import 'employees.dart';

@DataClassName('TimeEntry')
class TimeEntries extends Table {
  TextColumn get id => text()();
  
  // Foreign key to employees table
  @ReferenceName('employeeTimeEntries')
  IntColumn get employeeId => integer().named('employee_id')
      .references(Employees, #id, onDelete: KeyAction.cascade)();
  
  DateTimeColumn get clockIn => dateTime().named('clock_in')();
  DateTimeColumn get clockOut => dateTime().named('clock_out').nullable()();
  
  IntColumn get breakMinutes => integer().named('break_minutes').withDefault(const Constant(0))();
  RealColumn get totalHours => real().named('total_hours').nullable()(); // Calculated field
  
  TextColumn get status => text().withDefault(const Constant('active'))();
  
  // Audit trail for edits
  @ReferenceName('editedTimeEntries')
  IntColumn get editedBy => integer().named('edited_by').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  TextColumn get editReason => text().named('edit_reason').nullable()();
  
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (status IN (\'active\', \'completed\', \'edited\'))',
    'CHECK (break_minutes >= 0)',
    'CHECK (total_hours >= 0 OR total_hours IS NULL)',
    'CHECK (clock_in < clock_out OR clock_out IS NULL)', // Clock out must be after clock in
    'CHECK (status != \'completed\' OR clock_out IS NOT NULL)', // Completed entries must have clock out
    'CHECK (edited_by IS NULL OR edit_reason IS NOT NULL)', // Edit reason required when edited
  ];
}
