// lib/features/shared/data/repositories/payment_repository.dart
// Payment processing repository handling ticket payments, quick sales, refunds, and payment statistics.
// Manages payment transactions with Drift database, updates ticket statuses, and provides comprehensive payment analytics.
// Usage: ACTIVE - Primary repository for all payment processing and transaction management

import '../../../../core/database/database.dart';
import '../../../../core/utils/logger.dart';
import '../models/ticket_model.dart' as models;
import '../../../checkout/data/models/payment_result.dart';
import '../../../checkout/presentation/widgets/checkout_dialog.dart';
import 'package:drift/drift.dart';
import '../../../../core/services/auth/employee_context.dart';

/// Repository for payment processing and management
class PaymentRepository {
  final PosDatabase _database = PosDatabase.instance;
  
  // Singleton pattern
  static final PaymentRepository _instance = PaymentRepository._internal();
  static PaymentRepository get instance => _instance;
  PaymentRepository._internal();

  /// Process payment for tickets and create payment record
  Future<PaymentResult> processPayment({
    required List<models.Ticket> tickets,
    required String paymentMethod,
    required double amount,
    double? tipAmount,
    double? taxAmount,
    double? discountAmount,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? customerId,
    String? notes,
  }) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final now = DateTime.now();
      final paymentId = 'payment_${DateTime.now().millisecondsSinceEpoch}';
      
      // Calculate totals
      final totalAmount = amount + (tipAmount ?? 0.0);
      
      // Create payment record
      int _cents(double v) => (v * 100).round();
      final payment = PaymentsCompanion.insert(
        id: paymentId,
        ticketId: tickets.isNotEmpty ? tickets.first.id : 'quick_sale',
        paymentMethod: paymentMethod,
        amountCents: Value(_cents(amount)),
        tipAmountCents: tipAmount != null ? Value(_cents(tipAmount)) : const Value.absent(),
        taxAmountCents: taxAmount != null ? Value(_cents(taxAmount)) : const Value.absent(),
        discountAmountCents: discountAmount != null ? Value(_cents(discountAmount)) : const Value.absent(),
        totalAmountCents: Value(_cents(totalAmount)),
        discountType: discountType != null ? Value(discountType) : const Value.absent(),
        discountCode: discountCode != null ? Value(discountCode) : const Value.absent(),
        discountReason: discountReason != null ? Value(discountReason) : const Value.absent(),
        cardType: cardType != null ? Value(cardType) : const Value.absent(),
        lastFourDigits: lastFourDigits != null ? Value(lastFourDigits) : const Value.absent(),
        transactionId: Value('txn_${DateTime.now().millisecondsSinceEpoch}'),
        processedAt: Value(now),
        processedBy: EmployeeContext.currentEmployeeId != null
            ? Value(EmployeeContext.currentEmployeeId!)
            : const Value.absent(),
        // processedBy references Employees.id (int); omit if not available
        notes: notes != null ? Value(notes) : const Value.absent(),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      
      await _database.into(_database.payments).insert(payment);
      
      // Update ticket payment status
      for (final ticket in tickets) {
        await _updateTicketPaymentStatus(ticket.id, 'paid', _cents(totalAmount));
      }
      
      Logger.info('Payment processed successfully: $paymentId for ${tickets.length} tickets');
      
      return PaymentResult(
        paymentId: paymentId,
        ticketIds: tickets.map((t) => t.id).toList(),
        method: PaymentMethod.values.firstWhere((m) => m.name == paymentMethod, orElse: () => PaymentMethod.cash),
        subtotal: amount,
        tipAmount: tipAmount ?? 0.0,
        taxAmount: taxAmount ?? 0.0,
        totalAmount: totalAmount,
        discountAmount: discountAmount ?? 0.0,
        processedAt: DateTime.now(),
        discountReason: discountReason,
        customerId: customerId,
        isQuickSale: tickets.isEmpty,
      );
      
    } catch (e, stack) {
      Logger.error('Error processing payment', e, stack);
      
      return PaymentResult(
        paymentId: 'error_${DateTime.now().millisecondsSinceEpoch}',
        ticketIds: tickets.map((t) => t.id).toList(),
        method: PaymentMethod.values.firstWhere((m) => m.name == paymentMethod, orElse: () => PaymentMethod.cash),
        subtotal: amount,
        tipAmount: tipAmount ?? 0.0,
        taxAmount: taxAmount ?? 0.0,
        totalAmount: amount + (tipAmount ?? 0.0),
        discountAmount: discountAmount ?? 0.0,
        processedAt: DateTime.now(),
        discountReason: discountReason,
        customerId: customerId,
        isQuickSale: tickets.isEmpty,
      );
    }
  }
  
  /// Process quick sale payment (no tickets involved)
  Future<PaymentResult> processQuickSale({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required double amount,
    double? tipAmount,
    double? taxAmount,
    double? discountAmount,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? customerId,
    String? notes,
  }) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final now = DateTime.now();
      final paymentId = 'quick_sale_${DateTime.now().millisecondsSinceEpoch}';
      
      // Calculate totals
      final totalAmount = amount + (tipAmount ?? 0.0);
      
      // Create payment record for quick sale
      final payment = PaymentsCompanion.insert(
        id: paymentId,
        ticketId: 'quick_sale', // Special identifier for quick sales
        paymentMethod: paymentMethod,
        amountCents: (amount * 100).round(), // Convert dollars to cents
        tipAmountCents: tipAmount != null ? Value((tipAmount * 100).round()) : const Value.absent(),
        taxAmountCents: taxAmount != null ? Value((taxAmount * 100).round()) : const Value.absent(),
        discountAmountCents: discountAmount != null ? Value((discountAmount * 100).round()) : const Value.absent(),
        totalAmountCents: Value((totalAmount * 100).round()),
        discountType: discountType != null ? Value(discountType) : const Value.absent(),
        discountCode: discountCode != null ? Value(discountCode) : const Value.absent(),
        discountReason: discountReason != null ? Value(discountReason) : const Value.absent(),
        cardType: cardType != null ? Value(cardType) : const Value.absent(),
        lastFourDigits: lastFourDigits != null ? Value(lastFourDigits) : const Value.absent(),
        transactionId: Value('quick_txn_${DateTime.now().millisecondsSinceEpoch}'),
        processedAt: Value(now),
        processedBy: EmployeeContext.currentEmployeeId != null
            ? Value(EmployeeContext.currentEmployeeId!)
            : const Value.absent(),
        notes: notes != null ? Value('Quick Sale: ${items.map((i) => i['name']).join(', ')}${' | $notes'}') : Value('Quick Sale: ${items.map((i) => i['name']).join(', ')}'),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      
      await _database.into(_database.payments).insert(payment);
      
      Logger.info('Quick sale processed successfully: $paymentId');
      
      return PaymentResult(
        paymentId: paymentId,
        method: PaymentMethod.values.firstWhere((m) => m.name == paymentMethod, orElse: () => PaymentMethod.cash),
        subtotal: amount,
        tipAmount: tipAmount ?? 0.0,
        taxAmount: taxAmount ?? 0.0,
        totalAmount: totalAmount,
        discountAmount: discountAmount ?? 0.0,
        processedAt: DateTime.now(),
        discountReason: discountReason,
        customerId: customerId,
        isQuickSale: true,
      );
      
    } catch (e, stack) {
      Logger.error('Error processing quick sale', e, stack);
      
      return PaymentResult(
        paymentId: 'error_${DateTime.now().millisecondsSinceEpoch}',
        method: PaymentMethod.values.firstWhere((m) => m.name == paymentMethod, orElse: () => PaymentMethod.cash),
        subtotal: amount,
        tipAmount: tipAmount ?? 0.0,
        taxAmount: taxAmount ?? 0.0,
        totalAmount: amount + (tipAmount ?? 0.0),
        discountAmount: discountAmount ?? 0.0,
        processedAt: DateTime.now(),
        discountReason: discountReason,
        customerId: customerId,
        isQuickSale: true,
      );
    }
  }
  
  /// Update ticket payment status in the database
  Future<void> _updateTicketPaymentStatus(String ticketId, String paymentStatus, int totalAmountCents) async {
    try {
      await (_database.update(_database.tickets)
            ..where((t) => t.id.equals(ticketId)))
          .write(TicketsCompanion(
            paymentStatus: Value(paymentStatus),
            totalAmountCents: Value(totalAmountCents),
            status: Value('paid'), // Also update the general status
            updatedAt: Value(DateTime.now()),
          ),);
      
      Logger.info('Updated ticket $ticketId payment status to $paymentStatus');
    } catch (e, stack) {
      Logger.error('Error updating ticket payment status', e, stack);
      rethrow;
    }
  }
  
  /// Get payment history for a ticket
  Future<List<Payment>> getPaymentsByTicketId(String ticketId) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final payments = await (_database.select(_database.payments)
            ..where((p) => p.ticketId.equals(ticketId))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();
      
      return payments;
    } catch (e, stack) {
      Logger.error('Error fetching payments for ticket $ticketId', e, stack);
      return [];
    }
  }
  
  /// Get all payments for a date range
  Future<List<Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final startStr = startDate.toIso8601String();
      final endStr = endDate.toIso8601String();
      
      final payments = await (_database.select(_database.payments)
            ..where((p) => p.createdAt.isBiggerOrEqual(Variable(startStr)) & p.createdAt.isSmallerOrEqual(Variable(endStr)))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();
      
      return payments;
    } catch (e, stack) {
      Logger.error('Error fetching payments for date range', e, stack);
      return [];
    }
  }
  
  /// Get payment statistics for a date range
  Future<Map<String, dynamic>> getPaymentStats(DateTime startDate, DateTime endDate) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final startStr = startDate.toIso8601String();
      final endStr = endDate.toIso8601String();
      
      final payments = await getPaymentsByDateRange(startDate, endDate);
      
      if (payments.isEmpty) {
        return {
          'totalAmount': 0.0,
          'totalTips': 0.0,
          'totalTax': 0.0,
          'totalDiscount': 0.0,
          'transactionCount': 0,
          'quickSalesCount': 0,
          'averageTransaction': 0.0,
          'paymentMethodBreakdown': <String, double>{},
        };
      }
      
      double totalAmount = 0.0;
      double totalTips = 0.0;
      double totalTax = 0.0;
      double totalDiscount = 0.0;
      int quickSalesCount = 0;
      final Map<String, double> paymentMethodBreakdown = {};
      
      for (final payment in payments) {
        totalAmount += payment.totalAmount ?? payment.amount;
        totalTips += payment.tipAmount ?? 0.0;
        totalTax += payment.taxAmount ?? 0.0;
        totalDiscount += payment.discountAmount ?? 0.0;
        
        if (payment.ticketId == 'quick_sale') {
          quickSalesCount++;
        }
        
        paymentMethodBreakdown[payment.paymentMethod] = 
            (paymentMethodBreakdown[payment.paymentMethod] ?? 0.0) + (payment.totalAmount ?? payment.amount);
      }
      
      return {
        'totalAmount': totalAmount,
        'totalTips': totalTips,
        'totalTax': totalTax,
        'totalDiscount': totalDiscount,
        'transactionCount': payments.length,
        'quickSalesCount': quickSalesCount,
        'averageTransaction': totalAmount / payments.length,
        'paymentMethodBreakdown': paymentMethodBreakdown,
      };
      
    } catch (e, stack) {
      Logger.error('Error calculating payment stats', e, stack);
      return {};
    }
  }
  
  /// Process refund for a payment
  Future<PaymentResult> processRefund({
    required String originalPaymentId,
    required double refundAmount,
    required String reason,
    required int authorizedBy,
    String? notes,
  }) async {
    try {
      await PosDatabase.ensureInitialized();
      
      // Get the original payment
      final originalPayment = await (_database.select(_database.payments)
            ..where((p) => p.id.equals(originalPaymentId)))
          .getSingleOrNull();
      
      if (originalPayment == null) {
        throw Exception('Original payment not found');
      }
      
      // Validate refund amount
      if (refundAmount > (originalPayment.totalAmount ?? originalPayment.amount)) {
        throw Exception('Refund amount cannot exceed original payment amount');
      }
      
      // Create refund payment record
      final refundId = 'refund_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now().toIso8601String();
      
      int _cents(double v) => (v * 100).round();
      final refundPayment = PaymentsCompanion.insert(
        id: refundId,
        ticketId: originalPayment.ticketId,
        paymentMethod: 'refund',
        amountCents: Value(-_cents(refundAmount)), // Negative amount for refund
        totalAmountCents: Value(-_cents(refundAmount)),
        discountReason: Value(reason),
        authorizedBy: Value(authorizedBy),
        processedBy: EmployeeContext.currentEmployeeId != null
            ? Value(EmployeeContext.currentEmployeeId!)
            : const Value.absent(),
        notes: Value(notes ?? 'Refund for payment $originalPaymentId'),
        createdAt: Value(now),
        updatedAt: Value(now),
        processedAt: Value(now),
      );
      
      // Insert refund payment record
      await _database.into(_database.payments).insert(refundPayment);
      
      // Update original ticket status if fully refunded
      final originalAmount = (originalPayment.totalAmountCents ?? originalPayment.amountCents) / 100.0;
      if (refundAmount >= originalAmount) {
        await (_database.update(_database.tickets)
              ..where((t) => t.id.equals(originalPayment.ticketId)))
            .write(TicketsCompanion(
              status: const Value('refunded'),
              paymentStatus: const Value('refunded'),
              updatedAt: Value(now),
            ),);
      }
      
      Logger.info('Refund processed successfully: $refundId for original payment $originalPaymentId');
      
      return PaymentResult(
        paymentId: refundId,
        method: PaymentMethod.values.firstWhere((m) => m.name == 'cash', orElse: () => PaymentMethod.cash), // Default to cash for refunds
        subtotal: -refundAmount,
        tipAmount: 0.0,
        taxAmount: 0.0,
        totalAmount: -refundAmount,
        discountAmount: 0.0,
        processedAt: DateTime.now(),
        discountReason: reason,
        isQuickSale: false,
      );
      
    } catch (e, stack) {
      Logger.error('Error processing refund', e, stack);
      rethrow;
    }
  }
  
  /// Process void for a ticket (before payment completion)
  Future<bool> voidTicket({
    required String ticketId,
    required String reason,
    required int authorizedBy,
    String? notes,
  }) async {
    try {
      await PosDatabase.ensureInitialized();
      
      final now = DateTime.now();
      
      // Update ticket status to voided
      await (_database.update(_database.tickets)
            ..where((t) => t.id.equals(ticketId)))
          .write(TicketsCompanion(
            status: const Value('voided'),
            paymentStatus: const Value('voided'),
            notes: Value(notes ?? reason),
            updatedAt: Value(now),
          ),);
      
      Logger.info('Ticket voided successfully: $ticketId by employee $authorizedBy');
      return true;
      
    } catch (e, stack) {
      Logger.error('Error voiding ticket $ticketId', e, stack);
      return false;
    }
  }
}
