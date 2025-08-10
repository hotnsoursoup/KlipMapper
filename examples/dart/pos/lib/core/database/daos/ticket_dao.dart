// lib/core/database/daos/ticket_dao.dart
// Data Access Object for ticket operations with business logic methods, join queries, and proper transaction handling. Provides abstracted database operations for ticket management.
// Usage: ACTIVE - Primary data access layer for ticket operations with normalized service relationships

import 'package:drift/drift.dart';
import '../database.dart';
import '../../../features/tickets/data/tables/tickets.dart';
import '../../../features/customers/data/tables/customers.dart';
import '../../../features/employees/data/tables/employees.dart';
import '../../../features/tickets/data/tables/ticket_services.dart';
import '../../../features/services/data/tables/services.dart';

part 'ticket_dao.g.dart';

@DriftAccessor(tables: [Tickets, Customers, Employees, TicketServices, Services])
class TicketDao extends DatabaseAccessor<PosDatabase> with _$TicketDaoMixin {
  TicketDao(super.db);

  /// Get tickets by business date with customer and technician information
  Future<List<TicketWithRelations>> byBusinessDate(DateTime businessDate) {
    return (select(tickets)
      .join([
        leftOuterJoin(customers, customers.id.equalsExp(tickets.customerId)),
        leftOuterJoin(employees, employees.id.equalsExp(tickets.assignedTechnicianId)),
      ])
      ..where(tickets.businessDate.year.equals(businessDate.year) &
              tickets.businessDate.month.equals(businessDate.month) &
              tickets.businessDate.day.equals(businessDate.day))
      ..orderBy([OrderingTerm.desc(tickets.updatedAt)]))
    .map((row) => TicketWithRelations(
      ticket: row.readTable(tickets),
      customer: row.readTableOrNull(customers),
      assignedTechnician: row.readTableOrNull(employees),
    )).get();
  }

  /// Get tickets by status with related information
  Future<List<TicketWithRelations>> byStatus(String status) {
    return (select(tickets)
      .join([
        leftOuterJoin(customers, customers.id.equalsExp(tickets.customerId)),
        leftOuterJoin(employees, employees.id.equalsExp(tickets.assignedTechnicianId)),
      ])
      ..where(tickets.status.equals(status))
      ..orderBy([OrderingTerm.desc(tickets.updatedAt)]))
    .map((row) => TicketWithRelations(
      ticket: row.readTable(tickets),
      customer: row.readTableOrNull(customers),
      assignedTechnician: row.readTableOrNull(employees),
    )).get();
  }

  /// Get full ticket details including services
  Future<TicketWithFullDetails?> getFullTicketDetails(String ticketId) async {
    final ticketQuery = select(tickets)
      .join([
        leftOuterJoin(customers, customers.id.equalsExp(tickets.customerId)),
        leftOuterJoin(employees, employees.id.equalsExp(tickets.assignedTechnicianId)),
      ])
      ..where(tickets.id.equals(ticketId));
    
    final ticketResult = await ticketQuery.getSingleOrNull();
    if (ticketResult == null) return null;

    // Get ticket services
    final ticketServicesQuery = select(ticketServices)
      .join([
        innerJoin(services, services.id.equalsExp(ticketServices.serviceId)),
      ])
      ..where(ticketServices.ticketId.equals(ticketId));
    
    final ticketServicesList = await ticketServicesQuery.map((row) => 
      TicketServiceWithService(
        ticketService: row.readTable(ticketServices),
        service: row.readTable(services),
      )
    ).get();

    return TicketWithFullDetails(
      ticket: ticketResult.readTable(tickets),
      customer: ticketResult.readTableOrNull(customers),
      assignedTechnician: ticketResult.readTableOrNull(employees),
      services: ticketServicesList,
    );
  }

  /// Update ticket status with timestamp
  Future<void> setStatus(String ticketId, String status) {
    return (update(tickets)..where((t) => t.id.equals(ticketId)))
        .write(TicketsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Assign technician to ticket
  Future<void> assignTechnician(String ticketId, int technicianId) {
    return (update(tickets)..where((t) => t.id.equals(ticketId)))
        .write(TicketsCompanion(
          assignedTechnicianId: Value(technicianId),
          status: Value('assigned'),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Add service to existing ticket
  Future<void> addServiceToTicket(String ticketId, int serviceId, 
      {int quantity = 1, required int unitPriceCents}) async {
    
    await into(ticketServices).insert(TicketServicesCompanion.insert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ticketId: ticketId,
      serviceId: serviceId,
      quantity: Value(quantity),
      unitPriceCents: unitPriceCents,
      totalPriceCents: quantity * unitPriceCents,
      createdAt: DateTime.now(),
    ));

    // Update ticket total
    await _recalculateTicketTotal(ticketId);
  }

  /// Remove service from ticket
  Future<void> removeServiceFromTicket(String ticketId, int serviceId) async {
    await (delete(ticketServices)
      ..where((ts) => ts.ticketId.equals(ticketId) & ts.serviceId.equals(serviceId))
    ).go();

    // Update ticket total
    await _recalculateTicketTotal(ticketId);
  }

  /// Recalculate ticket total from services
  Future<void> _recalculateTicketTotal(String ticketId) async {
    final totalResult = await (selectOnly(ticketServices)
      ..addColumns([ticketServices.totalPriceCents.sum()])
      ..where(ticketServices.ticketId.equals(ticketId))
    ).getSingle();

    final totalCents = totalResult.read(ticketServices.totalPriceCents.sum()) ?? 0;

    await (update(tickets)..where((t) => t.id.equals(ticketId)))
        .write(TicketsCompanion(
          totalAmountCents: Value(totalCents),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Create new ticket with services transaction
  Future<String> createTicketWithServices({
    required String customerId,
    required int employeeId,
    required String customerName,
    required List<TicketServiceInput> services,
    String? notes,
    int priority = 1,
  }) async {
    return await transaction(() async {
      final ticketId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      // Generate next ticket number
      final maxTicketNumber = await (selectOnly(tickets)
        ..addColumns([tickets.ticketNumber.max()])
      ).getSingle();
      
      final nextTicketNumber = (maxTicketNumber.read(tickets.ticketNumber.max()) ?? 0) + 1;

      // Insert ticket
      await into(tickets).insert(TicketsCompanion.insert(
        id: ticketId,
        customerId: Value(customerId),
        employeeId: employeeId,
        ticketNumber: nextTicketNumber,
        customerName: customerName,
        priority: Value(priority),
        notes: Value(notes),
        businessDate: now,
        createdAt: now,
        updatedAt: now,
      ));

      // Insert services
      int totalCents = 0;
      for (final serviceInput in services) {
        final serviceTotalCents = serviceInput.quantity * serviceInput.unitPriceCents;
        totalCents += serviceTotalCents;

        await into(ticketServices).insert(TicketServicesCompanion.insert(
          id: '${ticketId}_${serviceInput.serviceId}',
          ticketId: ticketId,
          serviceId: serviceInput.serviceId,
          quantity: Value(serviceInput.quantity),
          unitPriceCents: serviceInput.unitPriceCents,
          totalPriceCents: serviceTotalCents,
          createdAt: now,
        ));
      }

      // Update ticket total
      await (update(tickets)..where((t) => t.id.equals(ticketId)))
          .write(TicketsCompanion(totalAmountCents: Value(totalCents)));

      return ticketId;
    });
  }
}

// Helper classes for complex queries
class TicketWithRelations {
  final Ticket ticket;
  final Customer? customer;
  final Employee? assignedTechnician;

  TicketWithRelations({
    required this.ticket,
    this.customer,
    this.assignedTechnician,
  });
}

class TicketServiceWithService {
  final TicketService ticketService;
  final Service service;

  TicketServiceWithService({
    required this.ticketService,
    required this.service,
  });
}

class TicketWithFullDetails {
  final Ticket ticket;
  final Customer? customer;
  final Employee? assignedTechnician;
  final List<TicketServiceWithService> services;

  TicketWithFullDetails({
    required this.ticket,
    this.customer,
    this.assignedTechnician,
    required this.services,
  });
}

class TicketServiceInput {
  final int serviceId;
  final int quantity;
  final int unitPriceCents;

  TicketServiceInput({
    required this.serviceId,
    required this.quantity,
    required this.unitPriceCents,
  });
}
