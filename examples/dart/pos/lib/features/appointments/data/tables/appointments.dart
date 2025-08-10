// lib/core/database/tables/appointments.dart
// Appointment table definition with proper foreign key constraints, DateTimeColumn for scheduling, and comprehensive appointment tracking with confirmation support.
// Usage: ACTIVE - Core table for appointment scheduling system with proper relationships

import 'package:drift/drift.dart';
import '../../../../core/database/type_converters/services_json.dart';
import '../../../customers/data/tables/customers.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('Appointment')
class Appointments extends Table {
  TextColumn get id => text()();
  
  // Foreign key to customers table
  TextColumn get customerId => text().named('customer_id')
      .references(Customers, #id, onDelete: KeyAction.cascade)();
  
  // Foreign key to employees table
  @ReferenceName('assignedAppointments')
  IntColumn get employeeId => integer().named('employee_id')
      .references(Employees, #id)();

  // Use DateTimeColumn for proper datetime handling
  DateTimeColumn get startDateTime => dateTime().named('start_datetime')();
  DateTimeColumn get endDateTime => dateTime().named('end_datetime')();

  // Keep JSON services for backward compatibility during migration
  // TODO: Migrate to AppointmentServices join table in future
  TextColumn get services => text().map(const ServicesJsonConverter())();
  
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get notes => text().nullable()();
  
  BoolColumn get isGroupBooking => boolean().named('is_group_booking').withDefault(const Constant(false))();
  IntColumn get groupSize => integer().named('group_size').nullable()();
  
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  
  // Foreign key to employees table for who last modified
  @ReferenceName('modifiedAppointments')
  IntColumn get lastModifiedBy => integer().named('last_modified_by').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
  TextColumn get lastModifiedDevice => text().named('last_modified_device').nullable()();
  
  // Confirmation tracking fields
  DateTimeColumn get confirmedAt => dateTime().named('confirmed_at').nullable()();
  TextColumn get confirmationType => text().named('confirmation_type').nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (status IN (\'scheduled\', \'confirmed\', \'in-progress\', \'completed\', \'cancelled\', \'no-show\'))',
    'CHECK (confirmation_type IN (\'phone\', \'email\', \'sms\', \'in-person\') OR confirmation_type IS NULL)',
    'CHECK (start_datetime < end_datetime)', // End must be after start
    'CHECK (group_size > 1 OR group_size IS NULL)', // Group size only when > 1
    'CHECK (NOT is_group_booking OR group_size > 1)', // Group booking requires group size
  ];
}
