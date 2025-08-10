// lib/core/database/tables/tickets.dart
// Ticket table definition with proper foreign key constraints, status enums, and integer cents for monetary values. Normalized structure removes JSON services field in favor of join table.
// Usage: ACTIVE - Core table for ticket queue management with improved data integrity

import 'package:drift/drift.dart';
import '../../../customers/data/tables/customers.dart';
import '../../../employees/data/tables/employees.dart';
import '../../../appointments/data/tables/appointments.dart';

@DataClassName('Ticket')
class Tickets extends Table {
  TextColumn get id => text()();
  
  // Foreign key to customers table
  TextColumn get customerId => text().named('customer_id').nullable()
      .references(Customers, #id, onDelete: KeyAction.setNull)();
  
  // Foreign key to employees table
  @ReferenceName('createdTickets')
  IntColumn get employeeId => integer().named('employee_id')
      .references(Employees, #id)();
  
  IntColumn get ticketNumber => integer().named('ticket_number')();
  TextColumn get customerName => text().named('customer_name')();
  
  // Remove JSON services field - use TicketServices join table instead
  // TextColumn get services => text()... // REMOVED
  
  IntColumn get priority => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('queued'))();
  
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get businessDate => dateTime().named('business_date')();
  DateTimeColumn get checkInTime => dateTime().named('check_in_time').nullable()();
  
  // Foreign key to employees table for assigned technician
  @ReferenceName('assignedTickets')
  IntColumn get assignedTechnicianId => integer().named('assigned_technician_id').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
  // Store monetary values as integer cents
  IntColumn get totalAmountCents => integer().named('total_amount_cents').nullable()();
  
  TextColumn get paymentStatus => text().named('payment_status').withDefault(const Constant('pending'))();
  BoolColumn get isGroupService => boolean().named('is_group_service').withDefault(const Constant(false))();
  IntColumn get groupSize => integer().named('group_size').nullable()();
  
  // Optional link to appointments
  TextColumn get appointmentId => text().named('appointment_id').nullable()
      .references(Appointments, #id, onDelete: KeyAction.setNull)();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules and enums
  @override
  List<String> get customConstraints => [
    'CHECK (status IN (\'queued\', \'assigned\', \'in-service\', \'completed\', \'paid\', \'cancelled\'))',
    'CHECK (payment_status IN (\'pending\', \'partial\', \'paid\', \'refunded\'))',
    'CHECK (priority >= 1 AND priority <= 5)', // Priority levels 1-5
    'CHECK (total_amount_cents >= 0 OR total_amount_cents IS NULL)',
    'CHECK (group_size > 1 OR group_size IS NULL)', // Group size only when > 1
    'CHECK (NOT is_group_service OR group_size > 1)', // Group service requires group size
    'UNIQUE(ticket_number)', // Ticket numbers must be unique
  ];
}
