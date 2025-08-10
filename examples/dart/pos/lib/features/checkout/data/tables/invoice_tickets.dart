// lib/core/database/tables/invoice_tickets.dart
// Normalized join table replacing JSON ticket_ids field in invoices table. Links invoices to tickets for multi-ticket billing scenarios.
// Usage: ACTIVE - New join table for proper invoice-ticket relationship enabling combined billing

import 'package:drift/drift.dart';
import 'invoices.dart';
import '../../../tickets/data/tables/tickets.dart';

@DataClassName('InvoiceTicket')
class InvoiceTickets extends Table {
  // Foreign keys to create normalized relationship
  TextColumn get invoiceId => text().named('invoice_id')
      .references(Invoices, #id, onDelete: KeyAction.cascade)();
  
  TextColumn get ticketId => text().named('ticket_id')
      .references(Tickets, #id, onDelete: KeyAction.cascade)();
  
  // Optional: portion of invoice amount allocated to this ticket
  IntColumn get allocatedAmountCents => integer().named('allocated_amount_cents').nullable()();
  
  DateTimeColumn get addedAt => dateTime().named('added_at')();

  // Use composite primary key for natural relationship
  @override
  Set<Column> get primaryKey => {invoiceId, ticketId};
  
  // Add constraints for data integrity
  @override
  List<String> get customConstraints => [
    'CHECK (allocated_amount_cents >= 0 OR allocated_amount_cents IS NULL)',
    'UNIQUE(invoice_id, ticket_id)', // Prevent duplicate invoice-ticket relationships
  ];
}
