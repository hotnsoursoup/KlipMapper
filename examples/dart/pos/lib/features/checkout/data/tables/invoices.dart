// lib/core/database/tables/invoices.dart
// Invoice table definition with proper foreign key constraints and integer cents for all monetary values. Normalized structure removes JSON ticket_ids field in favor of join table.
// Usage: ACTIVE - Core table for invoice management with improved financial data integrity

import 'package:drift/drift.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('Invoice')
class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text().named('invoice_number')();
  
  // Remove JSON ticket_ids field - use InvoiceTickets join table instead
  // TextColumn get ticketIds => text()... // REMOVED
  
  TextColumn get customerName => text().named('customer_name').nullable()();
  
  // All monetary values as integer cents to avoid floating point issues
  IntColumn get subtotalCents => integer().named('subtotal_cents')();
  IntColumn get taxAmountCents => integer().named('tax_amount_cents')();
  IntColumn get tipAmountCents => integer().named('tip_amount_cents')();
  IntColumn get discountAmountCents => integer().named('discount_amount_cents')();
  IntColumn get totalAmountCents => integer().named('total_amount_cents')();
  
  TextColumn get paymentMethod => text().named('payment_method')();
  TextColumn get discountType => text().named('discount_type').nullable()();
  TextColumn get discountCode => text().named('discount_code').nullable()();
  TextColumn get discountReason => text().named('discount_reason').nullable()();
  
  // Payment processing details
  TextColumn get cardType => text().named('card_type').nullable()();
  TextColumn get lastFourDigits => text().named('last_four_digits').nullable()();
  TextColumn get transactionId => text().named('transaction_id').nullable()();
  TextColumn get authorizationCode => text().named('authorization_code').nullable()();
  
  DateTimeColumn get processedAt => dateTime().named('processed_at')();
  
  // Foreign key to employees table for who processed the invoice
  IntColumn get processedBy => integer().named('processed_by')
      .references(Employees, #id)();
  
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (payment_method IN (\'cash\', \'credit_card\', \'debit_card\', \'gift_card\', \'check\', \'other\'))',
    'CHECK (discount_type IN (\'percentage\', \'fixed_amount\', \'loyalty\') OR discount_type IS NULL)',
    'CHECK (subtotal_cents >= 0)',
    'CHECK (tax_amount_cents >= 0)',
    'CHECK (tip_amount_cents >= 0)',
    'CHECK (discount_amount_cents >= 0)',
    'CHECK (total_amount_cents >= 0)',
    'CHECK (last_four_digits IS NULL OR length(last_four_digits) = 4)',
    'UNIQUE(invoice_number)', // Invoice numbers must be unique
  ];
}
