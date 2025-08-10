// lib/features/shared/data/repositories/drift_payment_repository.dart
// Drift repository implementation for payment management with transaction tracking and payment method handling.
// Usage: ACTIVE - Primary payment data access layer for processing transactions and payment history
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../models/payment_model.dart';
import '../../../../utils/error_logger.dart';
import '../../../../core/services/auth/employee_context.dart';

/// Drift-based Payment Repository
/// Handles all payment-related database operations
class DriftPaymentRepository {
  static DriftPaymentRepository? _instance;
  static DriftPaymentRepository get instance => _instance ??= DriftPaymentRepository._();
  
  DriftPaymentRepository._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      // Ensure database is fully initialized
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftPaymentRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftPaymentRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Convert Drift Payment to Model Payment
  Payment _convertToModel(db.Payment driftPayment) {
    // Map to simple Payment model used by UI
    return Payment(
      id: driftPayment.id,
      ticketId: driftPayment.ticketId,
      paymentMethod: driftPayment.paymentMethod,
      amount: (driftPayment.amountCents / 100.0),
      tipAmount: (driftPayment.tipAmountCents ?? 0) / 100.0,
      cardLastFour: driftPayment.lastFourDigits,
      cardType: driftPayment.cardType,
      transactionId: driftPayment.transactionId,
      status: 'completed',
      createdAt: driftPayment.createdAt,
    );
  }

  /// Get all payments for a specific ticket
  Future<List<Payment>> getPaymentsByTicket(String ticketId) async {
    await initialize();
    
    try {
      final query = _database!.select(_database!.payments)
        ..where((p) => p.ticketId.equals(ticketId));
      
      final driftPayments = await query.get();
      return driftPayments.map((p) => _convertToModel(p)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get payments for ticket $ticketId', e, stack);
      return [];
    }
  }

  /// Get all payments for a specific customer
  Future<List<Payment>> getCustomerPayments(String customerId) async {
    await initialize();
    
    try {
      // Join payments with tickets to filter by customer
      final query = _database!.select(_database!.payments).join([
        innerJoin(
          _database!.tickets,
          _database!.tickets.id.equalsExp(_database!.payments.ticketId),
        ),
      ])..where(_database!.tickets.customerId.equals(customerId));
      
      final results = await query.get();
      return results.map((row) => _convertToModel(row.readTable(_database!.payments))).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get payments for customer $customerId', e, stack);
      return [];
    }
  }

  /// Get total spent by a customer
  Future<double> getCustomerTotalSpent(String customerId) async {
    await initialize();
    
    try {
      final query = _database!.selectOnly(_database!.payments, distinct: false)
        ..addColumns([_database!.payments.totalAmountCents.sum()])
        ..join([
          innerJoin(
            _database!.tickets,
            _database!.tickets.id.equalsExp(_database!.payments.ticketId),
          ),
        ])
        ..where(_database!.tickets.customerId.equals(customerId));
      
      final result = await query.getSingle();
      final sumCents = result.read(_database!.payments.totalAmountCents.sum());
      return (sumCents ?? 0) / 100.0;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get total spent for customer $customerId', e, stack);
      return 0.0;
    }
  }

  /// Create a new payment
  Future<String> createPayment(Payment payment) async {
    await initialize();
    
    try {
      final id = payment.id.isEmpty 
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : payment.id;
      
      int _cents(double v) => (v * 100).round();
      final companion = db.PaymentsCompanion(
        id: Value(id),
        ticketId: Value(payment.ticketId),
        paymentMethod: Value(payment.paymentMethod),
        amountCents: Value(_cents(payment.amount)),
        tipAmountCents: Value(_cents(payment.tipAmount)),
        cardType: Value(payment.cardType),
        lastFourDigits: Value(payment.cardLastFour),
        transactionId: Value(payment.transactionId),
        processedAt: Value(payment.createdAt),
        processedBy: EmployeeContext.currentEmployeeId != null
            ? Value(EmployeeContext.currentEmployeeId!)
            : const Value.absent(),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );
      
      await _database!.into(_database!.payments).insert(companion);
      
      ErrorLogger.logInfo('Created payment $id for ticket ${payment.ticketId}');
      return id;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create payment', e, stack);
      rethrow;
    }
  }

  /// Update payment status
  Future<bool> updatePaymentStatus(String paymentId, String transactionId, String authCode) async {
    await initialize();
    
    try {
      final query = _database!.update(_database!.payments)
        ..where((p) => p.id.equals(paymentId));
      
      await query.write(db.PaymentsCompanion(
        transactionId: Value(transactionId),
        authorizationCode: Value(authCode),
        updatedAt: Value(DateTime.now()),
      ));
      
      return true;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update payment status for $paymentId', e, stack);
      return false;
    }
  }

  /// Get payments by date range
  Future<List<Payment>> getPaymentsByDateRange(DateTime start, DateTime end) async {
    await initialize();
    
    try {
      final query = _database!.select(_database!.payments)
        ..where((p) => p.processedAt.isBetweenValues(start, end));
      
      final driftPayments = await query.get();
      return driftPayments.map((p) => _convertToModel(p)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get payments by date range', e, stack);
      return [];
    }
  }

  /// Get payment statistics for a date range
  Future<Map<String, dynamic>> getPaymentStatistics(DateTime start, DateTime end) async {
    await initialize();
    
    try {
      final query = _database!.select(_database!.payments)
        ..where((p) => p.processedAt.isBetweenValues(start, end));
      
      final payments = await query.get();
      
      double totalRevenue = 0;
      double totalTips = 0;
      double totalTax = 0;
      double totalDiscounts = 0;
      final Map<String, int> paymentMethodCounts = {};
      
      for (final payment in payments) {
        totalRevenue += (payment.totalAmountCents ?? payment.amountCents) / 100.0;
        totalTips += (payment.tipAmountCents ?? 0) / 100.0;
        totalTax += (payment.taxAmountCents ?? 0) / 100.0;
        totalDiscounts += (payment.discountAmountCents ?? 0) / 100.0;
        
        paymentMethodCounts[payment.paymentMethod] = 
            (paymentMethodCounts[payment.paymentMethod] ?? 0) + 1;
      }
      
      return {
        'totalRevenue': totalRevenue,
        'totalTips': totalTips,
        'totalTax': totalTax,
        'totalDiscounts': totalDiscounts,
        'transactionCount': payments.length,
        'averageTransaction': payments.isEmpty ? 0 : totalRevenue / payments.length,
        'paymentMethods': paymentMethodCounts,
      };
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get payment statistics', e, stack);
      return {
        'totalRevenue': 0.0,
        'totalTips': 0.0,
        'totalTax': 0.0,
        'totalDiscounts': 0.0,
        'transactionCount': 0,
        'averageTransaction': 0.0,
        'paymentMethods': {},
      };
    }
  }
}
