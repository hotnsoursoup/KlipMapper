// lib/core/database/daos/invoice_dao.dart
// Data Access Object for invoice operations with multi-ticket billing support, financial calculations, and normalized ticket relationships. Provides business logic for invoice management with proper monetary handling.
// Usage: ACTIVE - Primary data access layer for invoice operations with normalized join tables

import 'package:drift/drift.dart';
import '../database.dart';
import '../../../features/checkout/data/tables/invoices.dart';
import '../../../features/checkout/data/tables/invoice_tickets.dart';
import '../../../features/tickets/data/tables/tickets.dart';
import '../../../features/employees/data/tables/employees.dart';

part 'invoice_dao.g.dart';

@DriftAccessor(tables: [Invoices, InvoiceTickets, Tickets, Employees])
class InvoiceDao extends DatabaseAccessor<PosDatabase> with _$InvoiceDaoMixin {
  InvoiceDao(super.db);

  /// Create invoice for single ticket
  Future<String> createSingleTicketInvoice({
    required String ticketId,
    required int subtotalCents,
    required int taxAmountCents,
    required int tipAmountCents,
    required int discountAmountCents,
    required String paymentMethod,
    required int processedBy,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? transactionId,
    String? authorizationCode,
    String? notes,
  }) async {
    return await transaction(() async {
      // Get ticket information
      final ticket = await (select(tickets)..where((t) => t.id.equals(ticketId))).getSingle();
      
      final totalAmountCents = subtotalCents + taxAmountCents + tipAmountCents - discountAmountCents;
      final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      // Generate next invoice number
      final maxInvoiceResult = await (selectOnly(invoices)
        ..addColumns([invoices.invoiceNumber.max()]))
      .getSingle();
      
      final lastInvoiceNumber = maxInvoiceResult.read(invoices.invoiceNumber.max()) ?? 'INV-0000';
      final nextNumber = int.parse(lastInvoiceNumber.split('-')[1]) + 1;
      final invoiceNumber = 'INV-${nextNumber.toString().padLeft(4, '0')}';

      // Create invoice
      await into(invoices).insert(InvoicesCompanion.insert(
        id: invoiceId,
        invoiceNumber: invoiceNumber,
        customerName: Value(ticket.customerName),
        subtotalCents: subtotalCents,
        taxAmountCents: taxAmountCents,
        tipAmountCents: tipAmountCents,
        discountAmountCents: discountAmountCents,
        totalAmountCents: totalAmountCents,
        paymentMethod: paymentMethod,
        discountType: Value(discountType),
        discountCode: Value(discountCode),
        discountReason: Value(discountReason),
        cardType: Value(cardType),
        lastFourDigits: Value(lastFourDigits),
        transactionId: Value(transactionId),
        authorizationCode: Value(authorizationCode),
        processedAt: now,
        processedBy: processedBy,
        notes: Value(notes),
        createdAt: now,
        updatedAt: now,
      ));

      // Link ticket to invoice
      await into(invoiceTickets).insert(InvoiceTicketsCompanion.insert(
        invoiceId: invoiceId,
        ticketId: ticketId,
        allocatedAmountCents: Value(totalAmountCents),
        addedAt: now,
      ));

      // Update ticket status
      await (update(tickets)..where((t) => t.id.equals(ticketId)))
          .write(TicketsCompanion(
            paymentStatus: const Value('paid'),
            status: const Value('paid'),
            updatedAt: Value(now),
          ));

      return invoiceId;
    });
  }

  /// Create invoice for multiple tickets
  Future<String> createMultiTicketInvoice({
    required List<String> ticketIds,
    required int subtotalCents,
    required int taxAmountCents,
    required int tipAmountCents,
    required int discountAmountCents,
    required String paymentMethod,
    required int processedBy,
    String? customerName,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? transactionId,
    String? authorizationCode,
    String? notes,
  }) async {
    return await transaction(() async {
      final totalAmountCents = subtotalCents + taxAmountCents + tipAmountCents - discountAmountCents;
      final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      // Generate next invoice number
      final maxInvoiceResult = await (selectOnly(invoices)
        ..addColumns([invoices.invoiceNumber.max()]))
      .getSingle();
      
      final lastInvoiceNumber = maxInvoiceResult.read(invoices.invoiceNumber.max()) ?? 'INV-0000';
      final nextNumber = int.parse(lastInvoiceNumber.split('-')[1]) + 1;
      final invoiceNumber = 'INV-${nextNumber.toString().padLeft(4, '0')}';

      // Create invoice
      await into(invoices).insert(InvoicesCompanion.insert(
        id: invoiceId,
        invoiceNumber: invoiceNumber,
        customerName: Value(customerName),
        subtotalCents: subtotalCents,
        taxAmountCents: taxAmountCents,
        tipAmountCents: tipAmountCents,
        discountAmountCents: discountAmountCents,
        totalAmountCents: totalAmountCents,
        paymentMethod: paymentMethod,
        discountType: Value(discountType),
        discountCode: Value(discountCode),
        discountReason: Value(discountReason),
        cardType: Value(cardType),
        lastFourDigits: Value(lastFourDigits),
        transactionId: Value(transactionId),
        authorizationCode: Value(authorizationCode),
        processedAt: now,
        processedBy: processedBy,
        notes: Value(notes),
        createdAt: now,
        updatedAt: now,
      ));

      // Link all tickets to invoice with proportional allocation
      final allocationPerTicket = (totalAmountCents / ticketIds.length).round();
      
      for (int i = 0; i < ticketIds.length; i++) {
        final ticketId = ticketIds[i];
        final isLastTicket = i == ticketIds.length - 1;
        
        // For last ticket, adjust allocation to ensure total matches exactly
        final allocation = isLastTicket 
            ? totalAmountCents - (allocationPerTicket * (ticketIds.length - 1))
            : allocationPerTicket;

        await into(invoiceTickets).insert(InvoiceTicketsCompanion.insert(
          invoiceId: invoiceId,
          ticketId: ticketId,
          allocatedAmountCents: Value(allocation),
          addedAt: now,
        ));

        // Update ticket status
        await (update(tickets)..where((t) => t.id.equals(ticketId)))
            .write(TicketsCompanion(
              paymentStatus: const Value('paid'),
              status: const Value('paid'),
              updatedAt: Value(now),
            ));
      }

      return invoiceId;
    });
  }

  /// Get invoice with all related tickets
  Future<InvoiceWithTickets?> getInvoiceWithTickets(String invoiceId) async {
    final invoiceQuery = select(invoices)
      .join([
        leftOuterJoin(employees, employees.id.equalsExp(invoices.processedBy))
      ])
      ..where(invoices.id.equals(invoiceId));
    
    final invoiceResult = await invoiceQuery.getSingleOrNull();
    if (invoiceResult == null) return null;

    // Get linked tickets
    final ticketsQuery = select(invoiceTickets)
      .join([
        innerJoin(tickets, tickets.id.equalsExp(invoiceTickets.ticketId))
      ])
      ..where(invoiceTickets.invoiceId.equals(invoiceId));
    
    final ticketsList = await ticketsQuery.map((row) => 
      InvoiceTicketWithDetails(
        invoiceTicket: row.readTable(invoiceTickets),
        ticket: row.readTable(tickets),
      )
    ).get();

    return InvoiceWithTickets(
      invoice: invoiceResult.readTable(invoices),
      processedBy: invoiceResult.readTableOrNull(employees),
      tickets: ticketsList,
    );
  }

  /// Get invoices by date range
  Future<List<Invoice>> getInvoicesByDateRange(DateTime startDate, DateTime endDate) {
    return (select(invoices)
      ..where((i) => i.processedAt.isBiggerOrEqualValue(startDate) &
                    i.processedAt.isSmallerOrEqualValue(endDate))
      ..orderBy([(i) => OrderingTerm.desc(i.processedAt)]))
    .get();
  }

  /// Get daily sales summary
  Future<DailySalesSummary> getDailySalesSummary(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final invoicesOfDay = await getInvoicesByDateRange(startOfDay, endOfDay);
    
    int totalSalesCents = 0;
    int totalTaxCents = 0;
    int totalTipsCents = 0;
    int totalDiscountsCents = 0;
    final paymentMethodBreakdown = <String, int>{};

    for (final invoice in invoicesOfDay) {
      totalSalesCents += invoice.totalAmountCents;
      totalTaxCents += invoice.taxAmountCents;
      totalTipsCents += invoice.tipAmountCents;
      totalDiscountsCents += invoice.discountAmountCents;
      
      paymentMethodBreakdown[invoice.paymentMethod] = 
          (paymentMethodBreakdown[invoice.paymentMethod] ?? 0) + invoice.totalAmountCents;
    }

    return DailySalesSummary(
      date: date,
      invoiceCount: invoicesOfDay.length,
      totalSalesCents: totalSalesCents,
      totalTaxCents: totalTaxCents,
      totalTipsCents: totalTipsCents,
      totalDiscountsCents: totalDiscountsCents,
      paymentMethodBreakdown: paymentMethodBreakdown,
    );
  }

  /// Search invoices by invoice number or customer name
  Future<List<Invoice>> searchInvoices(String query) {
    if (query.isEmpty) return Future.value([]);
    
    final searchPattern = '%${query.toLowerCase()}%';
    
    return (select(invoices)
      ..where((i) => 
        i.invoiceNumber.lower().like(searchPattern) |
        i.customerName.lower().like(searchPattern))
      ..orderBy([(i) => OrderingTerm.desc(i.processedAt)]))
    .get();
  }
}

// Helper classes
class InvoiceWithTickets {
  final Invoice invoice;
  final Employee? processedBy;
  final List<InvoiceTicketWithDetails> tickets;

  InvoiceWithTickets({
    required this.invoice,
    this.processedBy,
    required this.tickets,
  });
}

class InvoiceTicketWithDetails {
  final InvoiceTicket invoiceTicket;
  final Ticket ticket;

  InvoiceTicketWithDetails({
    required this.invoiceTicket,
    required this.ticket,
  });
}

class DailySalesSummary {
  final DateTime date;
  final int invoiceCount;
  final int totalSalesCents;
  final int totalTaxCents;
  final int totalTipsCents;
  final int totalDiscountsCents;
  final Map<String, int> paymentMethodBreakdown;

  DailySalesSummary({
    required this.date,
    required this.invoiceCount,
    required this.totalSalesCents,
    required this.totalTaxCents,
    required this.totalTipsCents,
    required this.totalDiscountsCents,
    required this.paymentMethodBreakdown,
  });
}
