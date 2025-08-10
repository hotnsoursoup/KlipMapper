// lib/features/shared/data/repositories/drift_invoice_repository.dart
// Drift-based invoice repository managing invoice creation, retrieval, and payment processing operations.
// Handles complex invoice queries, statistics generation, and payment tracking with JSON ticket ID storage.
// Usage: ACTIVE - Primary repository for invoice and payment record management

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../models/invoice_model.dart';
import '../../../../utils/error_logger.dart';
import '../../../../core/services/auth/employee_context.dart';

/// Drift-based Invoice Repository
class DriftInvoiceRepository {
  static DriftInvoiceRepository? _instance;
  static DriftInvoiceRepository get instance => _instance ??= DriftInvoiceRepository._();
  
  DriftInvoiceRepository._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftInvoiceRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftInvoiceRepository initialization', e, stack);
      rethrow;
    }
  }

  int _cents(double v) => (v * 100).round();

  Future<List<String>> _getInvoiceTicketIds(String invoiceId) async {
    final rows = await (_database!.select(_database!.invoiceTickets)
          ..where((it) => it.invoiceId.equals(invoiceId)))
        .get();
    return rows.map((it) => it.ticketId).toList();
  }

  Invoice _mapFromDrift(db.Invoice row, List<String> ticketIds) {
    return Invoice(
      id: row.id,
      invoiceNumber: row.invoiceNumber,
      ticketIds: ticketIds,
      customerName: row.customerName,
      subtotal: row.subtotalCents / 100.0,
      taxAmount: row.taxAmountCents / 100.0,
      tipAmount: row.tipAmountCents / 100.0,
      discountAmount: row.discountAmountCents / 100.0,
      totalAmount: row.totalAmountCents / 100.0,
      paymentMethod: row.paymentMethod,
      discountType: row.discountType,
      discountCode: row.discountCode,
      discountReason: row.discountReason,
      cardType: row.cardType,
      lastFourDigits: row.lastFourDigits,
      transactionId: row.transactionId,
      authorizationCode: row.authorizationCode,
      processedAt: row.processedAt,
      processedBy: row.processedBy,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// Create a new invoice (normalized invoice + invoice_tickets)
  Future<String> createInvoice(Invoice invoice) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      await _database!.into(_database!.invoices).insert(
        db.InvoicesCompanion(
          id: Value(invoice.id),
          invoiceNumber: Value(invoice.invoiceNumber),
          customerName: Value(invoice.customerName),
          subtotalCents: Value(_cents(invoice.subtotal)),
          taxAmountCents: Value(_cents(invoice.taxAmount)),
          tipAmountCents: Value(_cents(invoice.tipAmount)),
          discountAmountCents: Value(_cents(invoice.discountAmount)),
          totalAmountCents: Value(_cents(invoice.totalAmount)),
          paymentMethod: Value(invoice.paymentMethod),
          discountType: Value(invoice.discountType),
          discountCode: Value(invoice.discountCode),
          discountReason: Value(invoice.discountReason),
          cardType: Value(invoice.cardType),
          lastFourDigits: Value(invoice.lastFourDigits),
          transactionId: Value(invoice.transactionId),
          authorizationCode: Value(invoice.authorizationCode),
          processedAt: Value(invoice.processedAt),
          processedBy: Value(EmployeeContext.currentEmployeeId ?? 0),
          notes: Value(invoice.notes),
          createdAt: Value(invoice.createdAt),
          updatedAt: Value(invoice.updatedAt),
        ),
      );
      for (final tid in invoice.ticketIds) {
        await _database!.into(_database!.invoiceTickets).insert(
          db.InvoiceTicketsCompanion(
            invoiceId: Value(invoice.id),
            ticketId: Value(tid),
            allocatedAmountCents: const Value.absent(),
            addedAt: Value(DateTime.now()),
          ),
        );
      }
      
      ErrorLogger.logInfo('Invoice created successfully: ${invoice.invoiceNumber}');
      return invoice.id;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create invoice', e, stack);
      rethrow;
    }
  }

  /// Get invoice by ID
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final inv = await (_database!.select(_database!.invoices)
            ..where((i) => i.id.equals(id)))
          .getSingleOrNull();
      if (inv == null) return null;
      final tids = await _getInvoiceTicketIds(inv.id);
      return _mapFromDrift(inv, tids);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get invoice by ID: $id', e, stack);
      return null;
    }
  }

  /// Get invoice by invoice number
  Future<Invoice?> getInvoiceByNumber(String invoiceNumber) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final inv = await (_database!.select(_database!.invoices)
            ..where((i) => i.invoiceNumber.equals(invoiceNumber)))
          .getSingleOrNull();
      if (inv == null) return null;
      final tids = await _getInvoiceTicketIds(inv.id);
      return _mapFromDrift(inv, tids);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get invoice by number: $invoiceNumber', e, stack);
      return null;
    }
  }

  /// Get invoices by date range
  Future<List<Invoice>> getInvoicesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final rows = await (_database!.select(_database!.invoices)
            ..where((i) => i.createdAt.isBetweenValues(startDate, endDate))
            ..orderBy([
              (i) => OrderingTerm(expression: i.createdAt, mode: OrderingMode.desc),
            ]))
          .get();
      final result = <Invoice>[];
      for (final row in rows) {
        final tids = await _getInvoiceTicketIds(row.id);
        result.add(_mapFromDrift(row, tids));
      }
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get invoices by date range', e, stack);
      return [];
    }
  }

  /// Get recent invoices
  Future<List<Invoice>> getRecentInvoices({int limit = 50}) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final rows = await (_database!.select(_database!.invoices)
            ..orderBy([
              (i) => OrderingTerm(expression: i.createdAt, mode: OrderingMode.desc),
            ])
            ..limit(limit))
          .get();
      final result = <Invoice>[];
      for (final row in rows) {
        final tids = await _getInvoiceTicketIds(row.id);
        result.add(_mapFromDrift(row, tids));
      }
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get recent invoices', e, stack);
      return [];
    }
  }

  /// Search invoices by customer name or invoice number
  Future<List<Invoice>> searchInvoices(String searchTerm) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final term = '%$searchTerm%';
      final rows = await (_database!.select(_database!.invoices)
            ..where((i) => 
                i.customerName.like(term) | 
                i.invoiceNumber.like(term) |
                i.notes.like(term),)
            ..orderBy([
              (i) => OrderingTerm(expression: i.createdAt, mode: OrderingMode.desc),
            ]))
          .get();
      final result = <Invoice>[];
      for (final row in rows) {
        final tids = await _getInvoiceTicketIds(row.id);
        result.add(_mapFromDrift(row, tids));
      }
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to search invoices', e, stack);
      return [];
    }
  }

  /// Get invoices containing a specific ticket
  Future<List<Invoice>> getInvoicesForTicket(String ticketId) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final links = await (_database!.select(_database!.invoiceTickets)
            ..where((it) => it.ticketId.equals(ticketId)))
          .get();
      if (links.isEmpty) return [];
      final invIds = links.map((l) => l.invoiceId).toSet().toList();
      final rows = await (_database!.select(_database!.invoices)
            ..where((i) => i.id.isIn(invIds)))
          .get();
      final result = <Invoice>[];
      for (final row in rows) {
        final tids = await _getInvoiceTicketIds(row.id);
        result.add(_mapFromDrift(row, tids));
      }
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get invoices for ticket: $ticketId', e, stack);
      return [];
    }
  }

  /// Update invoice
  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      await (_database!.update(_database!.invoices)
            ..where((i) => i.id.equals(invoice.id)))
          .write(db.InvoicesCompanion(
            invoiceNumber: Value(invoice.invoiceNumber),
            customerName: Value(invoice.customerName),
            subtotalCents: Value(_cents(invoice.subtotal)),
            taxAmountCents: Value(_cents(invoice.taxAmount)),
            tipAmountCents: Value(_cents(invoice.tipAmount)),
            discountAmountCents: Value(_cents(invoice.discountAmount)),
            totalAmountCents: Value(_cents(invoice.totalAmount)),
            paymentMethod: Value(invoice.paymentMethod),
            discountType: Value(invoice.discountType),
            discountCode: Value(invoice.discountCode),
            discountReason: Value(invoice.discountReason),
            cardType: Value(invoice.cardType),
            lastFourDigits: Value(invoice.lastFourDigits),
            transactionId: Value(invoice.transactionId),
            authorizationCode: Value(invoice.authorizationCode),
            processedAt: Value(invoice.processedAt),
            // processedBy stays as originally recorded
            notes: Value(invoice.notes),
            updatedAt: Value(DateTime.now()),
          ),);

      // Sync invoice_tickets join rows
      await (_database!.delete(_database!.invoiceTickets)
            ..where((it) => it.invoiceId.equals(invoice.id)))
          .go();
      for (final tid in invoice.ticketIds) {
        await _database!.into(_database!.invoiceTickets).insert(
          db.InvoiceTicketsCompanion(
            invoiceId: Value(invoice.id),
            ticketId: Value(tid),
            allocatedAmountCents: const Value.absent(),
            addedAt: Value(DateTime.now()),
          ),
        );
      }
      
      ErrorLogger.logInfo('Invoice updated successfully: ${invoice.invoiceNumber}');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update invoice', e, stack);
      rethrow;
    }
  }

  /// Delete invoice (soft delete by adding deleted note)
  Future<void> deleteInvoice(String id, String reason) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final existingInvoice = await getInvoiceById(id);
      if (existingInvoice == null) {
        throw Exception('Invoice not found');
      }

      final deletedNote = 'DELETED: $reason';
      final updatedNotes = existingInvoice.notes != null 
          ? '${existingInvoice.notes}\n$deletedNote'
          : deletedNote;

      await (_database!.update(_database!.invoices)
            ..where((i) => i.id.equals(id)))
          .write(db.InvoicesCompanion(
            notes: Value(updatedNotes),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),);
      
      ErrorLogger.logInfo('Invoice marked as deleted: ${existingInvoice.invoiceNumber}');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete invoice', e, stack);
      rethrow;
    }
  }

  /// Get invoice statistics for a date range
  Future<Map<String, dynamic>> getInvoiceStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await initialize();
      if (_database == null) {
        throw Exception('Database not initialized');
      }

      final startDateStr = startDate.toIso8601String();
      final endDateStr = endDate.toIso8601String();

      final invoices = await getInvoicesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      if (invoices.isEmpty) {
        return {
          'totalInvoices': 0,
          'totalRevenue': 0.0,
          'totalTips': 0.0,
          'totalTax': 0.0,
          'totalDiscounts': 0.0,
          'averageInvoiceAmount': 0.0,
          'ticketsProcessed': 0,
        };
      }

      final totalRevenue = invoices.fold<double>(0.0, (sum, inv) => sum + inv.totalAmount);
      final totalTips = invoices.fold<double>(0.0, (sum, inv) => sum + inv.tipAmount);
      final totalTax = invoices.fold<double>(0.0, (sum, inv) => sum + inv.taxAmount);
      final totalDiscounts = invoices.fold<double>(0.0, (sum, inv) => sum + inv.discountAmount);
      final ticketsProcessed = invoices.fold<int>(0, (sum, inv) => sum + inv.ticketIds.length);

      return {
        'totalInvoices': invoices.length,
        'totalRevenue': totalRevenue,
        'totalTips': totalTips,
        'totalTax': totalTax,
        'totalDiscounts': totalDiscounts,
        'averageInvoiceAmount': totalRevenue / invoices.length,
        'ticketsProcessed': ticketsProcessed,
      };
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get invoice statistics', e, stack);
      return {};
    }
  }

  /// Stream of recent invoices (for reactive UI)
  Stream<List<Invoice>> watchRecentInvoices({int limit = 50}) {
    initialize();
    return (_database!.select(_database!.invoices)
          ..orderBy([
            (i) => OrderingTerm(expression: i.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch()
        .asyncMap((rows) async {
          final result = <Invoice>[];
          for (final row in rows) {
            final tids = await _getInvoiceTicketIds(row.id);
            result.add(_mapFromDrift(row, tids));
          }
          return result;
        });
  }

  /// Close database connection
  Future<void> close() async {
    // Don't close the shared database instance
  }
}
