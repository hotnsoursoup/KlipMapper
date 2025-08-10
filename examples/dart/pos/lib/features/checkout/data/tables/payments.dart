// lib/core/database/tables/payments.dart
// Payment table definition with proper foreign key constraints to tickets and invoices, integer cents for all monetary values, and comprehensive payment tracking.
// Usage: ACTIVE - Core table for payment processing with improved financial data integrity

import 'package:drift/drift.dart';
import '../../../tickets/data/tables/tickets.dart';
import 'invoices.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('Payment')
class Payments extends Table {
  TextColumn get id => text()();
  
  // Foreign key to tickets table
  TextColumn get ticketId => text().named('ticket_id')
      .references(Tickets, #id, onDelete: KeyAction.cascade)();
  
  // Foreign key to invoices table for multi-ticket payments
  TextColumn get invoiceId => text().named('invoice_id').nullable()
      .references(Invoices, #id, onDelete: KeyAction.setNull)();
  
  TextColumn get paymentMethod => text().named('payment_method')();
  
  // All monetary values as integer cents
  IntColumn get amountCents => integer().named('amount_cents')();
  IntColumn get tipAmountCents => integer().named('tip_amount_cents').nullable()();
  IntColumn get taxAmountCents => integer().named('tax_amount_cents').nullable()();
  IntColumn get discountAmountCents => integer().named('discount_amount_cents').nullable()();
  IntColumn get totalAmountCents => integer().named('total_amount_cents').nullable()();
  
  TextColumn get discountType => text().named('discount_type').nullable()();
  TextColumn get discountCode => text().named('discount_code').nullable()();
  TextColumn get discountReason => text().named('discount_reason').nullable()();
  
  // Payment processing details
  TextColumn get cardType => text().named('card_type').nullable()();
  TextColumn get lastFourDigits => text().named('last_four_digits').nullable()();
  TextColumn get transactionId => text().named('transaction_id').nullable()();
  TextColumn get authorizationCode => text().named('authorization_code').nullable()();
  
  DateTimeColumn get processedAt => dateTime().named('processed_at').nullable()();
  
  // Foreign key to employees table for who processed the payment
  @ReferenceName('processedPayments')
  IntColumn get processedBy => integer().named('processed_by').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
  // Manager/admin who authorized refunds/voids, when applicable
  @ReferenceName('authorizedPayments')
  IntColumn get authorizedBy => integer().named('authorized_by').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
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
    'CHECK (amount_cents > 0)', // Payment amount must be positive
    'CHECK (tip_amount_cents >= 0 OR tip_amount_cents IS NULL)',
    'CHECK (tax_amount_cents >= 0 OR tax_amount_cents IS NULL)',
    'CHECK (discount_amount_cents >= 0 OR discount_amount_cents IS NULL)',
    'CHECK (total_amount_cents >= 0 OR total_amount_cents IS NULL)',
    'CHECK (last_four_digits IS NULL OR length(last_four_digits) = 4)',
    'CHECK (card_type IS NOT NULL OR payment_method NOT IN (\'credit_card\', \'debit_card\'))', // Card type required for card payments
  ];
}
