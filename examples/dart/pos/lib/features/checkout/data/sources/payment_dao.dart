// lib/core/database/daos/payment_dao.dart
// Data Access Object for payment operations with financial reporting, transaction tracking, and proper invoice linking. Provides business logic for payment processing with audit trails.
// Usage: ACTIVE - Primary data access layer for payment operations with financial integrity

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../tables/payments.dart';
import '../../../tickets/data/tables/tickets.dart';
import '../tables/invoices.dart';
import '../../../employees/data/tables/employees.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [Payments, Tickets, Invoices, Employees])
class PaymentDao extends DatabaseAccessor<PosDatabase> with _$PaymentDaoMixin {
  PaymentDao(super.db);

  /// Create payment for a ticket
  Future<String> createPayment({
    required String ticketId,
    String? invoiceId,
    required String paymentMethod,
    required int amountCents,
    int? tipAmountCents,
    int? taxAmountCents,
    int? discountAmountCents,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? transactionId,
    String? authorizationCode,
    int? processedBy,
    String? notes,
  }) async {
    final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final totalAmountCents = amountCents + (tipAmountCents ?? 0);

    await into(payments).insert(PaymentsCompanion.insert(
      id: paymentId,
      ticketId: ticketId,
      invoiceId: Value(invoiceId),
      paymentMethod: paymentMethod,
      amountCents: amountCents,
      tipAmountCents: Value(tipAmountCents),
      taxAmountCents: Value(taxAmountCents),
      discountAmountCents: Value(discountAmountCents),
      totalAmountCents: Value(totalAmountCents),
      discountType: Value(discountType),
      discountCode: Value(discountCode),
      discountReason: Value(discountReason),
      cardType: Value(cardType),
      lastFourDigits: Value(lastFourDigits),
      transactionId: Value(transactionId),
      authorizationCode: Value(authorizationCode),
      processedAt: Value(now),
      processedBy: Value(processedBy),
      notes: Value(notes),
      createdAt: now,
      updatedAt: now,
    ));

    return paymentId;
  }

  /// Get payments for a specific ticket
  Future<List<PaymentWithDetails>> getPaymentsForTicket(String ticketId) {
    return (select(payments)
      .join([
        innerJoin(tickets, tickets.id.equalsExp(payments.ticketId)),
        leftOuterJoin(employees, employees.id.equalsExp(payments.processedBy)),
        leftOuterJoin(invoices, invoices.id.equalsExp(payments.invoiceId)),
      ])
      ..where(payments.ticketId.equals(ticketId))
      ..orderBy([OrderingTerm.desc(payments.processedAt)]))
    .map((row) => PaymentWithDetails(
      payment: row.readTable(payments),
      ticket: row.readTable(tickets),
      processedBy: row.readTableOrNull(employees),
      invoice: row.readTableOrNull(invoices),
    )).get();
  }

  /// Get payments by date range for financial reporting
  Future<List<PaymentWithDetails>> getPaymentsByDateRange(
    DateTime startDate, 
    DateTime endDate
  ) {
    return (select(payments)
      .join([
        innerJoin(tickets, tickets.id.equalsExp(payments.ticketId)),
        leftOuterJoin(employees, employees.id.equalsExp(payments.processedBy)),
        leftOuterJoin(invoices, invoices.id.equalsExp(payments.invoiceId)),
      ])
      ..where(payments.processedAt.isBiggerOrEqualValue(startDate) &
              payments.processedAt.isSmallerOrEqualValue(endDate))
      ..orderBy([OrderingTerm.desc(payments.processedAt)]))
    .map((row) => PaymentWithDetails(
      payment: row.readTable(payments),
      ticket: row.readTable(tickets),
      processedBy: row.readTableOrNull(employees),
      invoice: row.readTableOrNull(invoices),
    )).get();
  }

  /// Get payment method summary for date range
  Future<Map<String, PaymentMethodSummary>> getPaymentMethodSummary(
    DateTime startDate, 
    DateTime endDate
  ) async {
    final payments = await getPaymentsByDateRange(startDate, endDate);
    final summary = <String, PaymentMethodSummary>{};

    for (final payment in payments) {
      final method = payment.payment.paymentMethod;
      final existing = summary[method];
      
      if (existing == null) {
        summary[method] = PaymentMethodSummary(
          paymentMethod: method,
          transactionCount: 1,
          totalAmountCents: payment.payment.totalAmountCents ?? 0,
          totalTipsCents: payment.payment.tipAmountCents ?? 0,
        );
      } else {
        summary[method] = PaymentMethodSummary(
          paymentMethod: method,
          transactionCount: existing.transactionCount + 1,
          totalAmountCents: existing.totalAmountCents + (payment.payment.totalAmountCents ?? 0),
          totalTipsCents: existing.totalTipsCents + (payment.payment.tipAmountCents ?? 0),
        );
      }
    }

    return summary;
  }

  /// Get daily payment totals
  Future<DailyPaymentTotals> getDailyPaymentTotals(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final paymentsOfDay = await getPaymentsByDateRange(startOfDay, endOfDay);

    int totalAmountCents = 0;
    int totalTipsCents = 0;
    int totalTaxCents = 0;
    int totalDiscountsCents = 0;
    int transactionCount = 0;

    for (final paymentDetail in paymentsOfDay) {
      final payment = paymentDetail.payment;
      totalAmountCents += payment.totalAmountCents ?? 0;
      totalTipsCents += payment.tipAmountCents ?? 0;
      totalTaxCents += payment.taxAmountCents ?? 0;
      totalDiscountsCents += payment.discountAmountCents ?? 0;
      transactionCount++;
    }

    return DailyPaymentTotals(
      date: date,
      transactionCount: transactionCount,
      totalAmountCents: totalAmountCents,
      totalTipsCents: totalTipsCents,
      totalTaxCents: totalTaxCents,
      totalDiscountsCents: totalDiscountsCents,
    );
  }

  /// Get refund/void payments
  Future<List<PaymentWithDetails>> getRefundedPayments(DateTime startDate, DateTime endDate) {
    return (select(payments)
      .join([
        innerJoin(tickets, tickets.id.equalsExp(payments.ticketId)),
        leftOuterJoin(employees, employees.id.equalsExp(payments.processedBy)),
        leftOuterJoin(invoices, invoices.id.equalsExp(payments.invoiceId)),
      ])
      ..where(payments.processedAt.isBiggerOrEqualValue(startDate) &
              payments.processedAt.isSmallerOrEqualValue(endDate) &
              payments.amountCents.isSmallerThanValue(0)) // Negative amounts indicate refunds
      ..orderBy([OrderingTerm.desc(payments.processedAt)]))
    .map((row) => PaymentWithDetails(
      payment: row.readTable(payments),
      ticket: row.readTable(tickets),
      processedBy: row.readTableOrNull(employees),
      invoice: row.readTableOrNull(invoices),
    )).get();
  }

  /// Create refund payment
  Future<String> createRefund({
    required String originalPaymentId,
    required int refundAmountCents,
    required String reason,
    int? processedBy,
    String? notes,
  }) async {
    return await transaction(() async {
      // Get original payment
      final originalPayment = await (select(payments)
        ..where((p) => p.id.equals(originalPaymentId))
      ).getSingle();

      // Create refund payment (negative amount)
      final refundId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      await into(payments).insert(PaymentsCompanion.insert(
        id: refundId,
        ticketId: originalPayment.ticketId,
        invoiceId: Value(originalPayment.invoiceId),
        paymentMethod: 'refund',
        amountCents: -refundAmountCents, // Negative amount
        processedAt: Value(now),
        processedBy: Value(processedBy),
        notes: Value('REFUND: $reason${notes != null ? ' - $notes' : ''}'),
        createdAt: now,
        updatedAt: now,
      ));

      return refundId;
    });
  }

  /// Search payments by transaction ID, authorization code, or last four digits
  Future<List<PaymentWithDetails>> searchPayments(String query) {
    if (query.isEmpty) return Future.value([]);
    
    final searchPattern = '%${query.toLowerCase()}%';
    
    return (select(payments)
      .join([
        innerJoin(tickets, tickets.id.equalsExp(payments.ticketId)),
        leftOuterJoin(employees, employees.id.equalsExp(payments.processedBy)),
        leftOuterJoin(invoices, invoices.id.equalsExp(payments.invoiceId)),
      ])
      ..where(payments.transactionId.lower().like(searchPattern) |
              payments.authorizationCode.lower().like(searchPattern) |
              payments.lastFourDigits.like(query))
      ..orderBy([OrderingTerm.desc(payments.processedAt)]))
    .map((row) => PaymentWithDetails(
      payment: row.readTable(payments),
      ticket: row.readTable(tickets),
      processedBy: row.readTableOrNull(employees),
      invoice: row.readTableOrNull(invoices),
    )).get();
  }
}

// Helper classes
class PaymentWithDetails {
  final Payment payment;
  final Ticket ticket;
  final Employee? processedBy;
  final Invoice? invoice;

  PaymentWithDetails({
    required this.payment,
    required this.ticket,
    this.processedBy,
    this.invoice,
  });
}

class PaymentMethodSummary {
  final String paymentMethod;
  final int transactionCount;
  final int totalAmountCents;
  final int totalTipsCents;

  PaymentMethodSummary({
    required this.paymentMethod,
    required this.transactionCount,
    required this.totalAmountCents,
    required this.totalTipsCents,
  });
}

class DailyPaymentTotals {
  final DateTime date;
  final int transactionCount;
  final int totalAmountCents;
  final int totalTipsCents;
  final int totalTaxCents;
  final int totalDiscountsCents;

  DailyPaymentTotals({
    required this.date,
    required this.transactionCount,
    required this.totalAmountCents,
    required this.totalTipsCents,
    required this.totalTaxCents,
    required this.totalDiscountsCents,
  });
}