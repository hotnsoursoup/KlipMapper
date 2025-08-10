// lib/core/database/tables/ticket_services.dart
// Normalized join table replacing JSON services field in tickets table. Links tickets to services with quantity, pricing, and status tracking for each service item.
// Usage: ACTIVE - New join table for proper ticket-service relationship with individual service tracking

import 'package:drift/drift.dart';
import 'tickets.dart';
import '../../../services/data/tables/services.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('TicketService')
class TicketServices extends Table {
  TextColumn get id => text()(); // UUID for this specific service instance
  
  // Foreign keys to create normalized relationship
  TextColumn get ticketId => text().named('ticket_id')
      .references(Tickets, #id, onDelete: KeyAction.cascade)();
  
  IntColumn get serviceId => integer().named('service_id')
      .references(Services, #id, onDelete: KeyAction.cascade)();
  
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  
  // Store pricing as integer cents for each service instance
  IntColumn get unitPriceCents => integer().named('unit_price_cents')(); // Price at time of booking
  IntColumn get totalPriceCents => integer().named('total_price_cents')(); // quantity * unit_price
  
  // Individual service status tracking
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  // Optional: assigned technician for this specific service
  IntColumn get assignedTechnicianId => integer().named('assigned_technician_id').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
  DateTimeColumn get startedAt => dateTime().named('started_at').nullable()();
  DateTimeColumn get completedAt => dateTime().named('completed_at').nullable()();
  
  TextColumn get notes => text().nullable()(); // Service-specific notes
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (status IN (\'pending\', \'in-progress\', \'completed\', \'skipped\'))',
    'CHECK (quantity > 0)',
    'CHECK (unit_price_cents >= 0)',
    'CHECK (total_price_cents >= 0)',
    'CHECK (total_price_cents = quantity * unit_price_cents)', // Consistency check
    'UNIQUE(ticket_id, service_id)', // One entry per service per ticket
  ];
}
