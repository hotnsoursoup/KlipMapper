// lib/core/database/daos/customer_dao.dart
// Data Access Object for customer operations with search functionality, loyalty point management, and comprehensive customer relationship tracking. Provides business logic for customer management.
// Usage: ACTIVE - Primary data access layer for customer operations with search and loyalty features

import 'package:drift/drift.dart';
import '../database.dart';
import '../../../features/customers/data/tables/customers.dart';
import '../../../features/employees/data/tables/employees.dart';
import '../../../features/tickets/data/tables/tickets.dart';
import '../../../features/appointments/data/tables/appointments.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers, Employees, Tickets, Appointments])
class CustomerDao extends DatabaseAccessor<PosDatabase> with _$CustomerDaoMixin {
  CustomerDao(super.db);

  /// Search customers by name, phone, or email
  Future<List<Customer>> searchCustomers(String query) {
    if (query.isEmpty) return Future.value([]);
    
    final searchPattern = '%${query.toLowerCase()}%';
    
    return (select(customers)
      ..where((c) => 
        c.firstName.lower().like(searchPattern) |
        c.lastName.lower().like(searchPattern) |
        c.phone.like(searchPattern) |
        c.email.lower().like(searchPattern))
      ..where((c) => c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm.asc(c.lastName), (c) => OrderingTerm.asc(c.firstName)]))
    .get();
  }

  /// Get customer by phone number (exact match)
  Future<Customer?> getByPhone(String phone) {
    return (select(customers)..where((c) => c.phone.equals(phone))).getSingleOrNull();
  }

  /// Get customer by email (exact match)
  Future<Customer?> getByEmail(String email) {
    return (select(customers)..where((c) => c.email.equals(email.toLowerCase()))).getSingleOrNull();
  }

  /// Get customer with preferred technician information
  Future<CustomerWithTechnician?> getCustomerWithTechnician(String customerId) async {
    final customerQuery = select(customers)
      .join([
        leftOuterJoin(employees, employees.id.equalsExp(customers.preferredTechnicianId))
      ])
      ..where(customers.id.equals(customerId));
    
    final result = await customerQuery.getSingleOrNull();
    if (result == null) return null;

    return CustomerWithTechnician(
      customer: result.readTable(customers),
      preferredTechnician: result.readTableOrNull(employees),
    );
  }

  /// Get customer visit history with basic statistics
  Future<CustomerVisitHistory> getCustomerHistory(String customerId) async {
    final customer = await (select(customers)..where((c) => c.id.equals(customerId))).getSingleOrNull();
    if (customer == null) {
      throw Exception('Customer not found');
    }

    // Get recent tickets
    final recentTickets = await (select(tickets)
      ..where((t) => t.customerId.equals(customerId))
      ..orderBy([(t) => OrderingTerm.desc(t.businessDate)])
      ..limit(10))
    .get();

    // Get recent appointments  
    final recentAppointments = await (select(appointments)
      ..where((a) => a.customerId.equals(customerId))
      ..orderBy([(a) => OrderingTerm.desc(a.startDateTime)])
      ..limit(10))
    .get();

    // Calculate total spent (from completed/paid tickets)
    final totalSpentResult = await (selectOnly(tickets)
      ..addColumns([tickets.totalAmountCents.sum()])
      ..where(tickets.customerId.equals(customerId) & 
              tickets.status.isIn(['completed', 'paid'])))
    .getSingle();

    final totalSpentCents = totalSpentResult.read(tickets.totalAmountCents.sum()) ?? 0;

    // Count total visits
    final totalVisits = await (selectOnly(tickets)
      ..addColumns([tickets.id.count()])
      ..where(tickets.customerId.equals(customerId)))
    .getSingle();

    final visitCount = totalVisits.read(tickets.id.count()) ?? 0;

    return CustomerVisitHistory(
      customer: customer,
      recentTickets: recentTickets,
      recentAppointments: recentAppointments,
      totalSpentCents: totalSpentCents,
      totalVisits: visitCount,
    );
  }

  /// Add loyalty points to customer
  Future<void> addLoyaltyPoints(String customerId, int points) async {
    if (points <= 0) return;

    final current = await (select(customers)..where((c) => c.id.equals(customerId))).getSingle();
    final newTotal = current.loyaltyPoints + points;

    await (update(customers)..where((c) => c.id.equals(customerId)))
        .write(CustomersCompanion(
          loyaltyPoints: Value(newTotal),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Redeem loyalty points (subtract points)
  Future<bool> redeemLoyaltyPoints(String customerId, int points) async {
    if (points <= 0) return false;

    final current = await (select(customers)..where((c) => c.id.equals(customerId))).getSingle();
    final currentPoints = current.loyaltyPoints;
    
    if (currentPoints < points) {
      return false; // Insufficient points
    }

    final newTotal = currentPoints - points;

    await (update(customers)..where((c) => c.id.equals(customerId)))
        .write(CustomersCompanion(
          loyaltyPoints: Value(newTotal),
          updatedAt: Value(DateTime.now()),
        ));

    return true;
  }

  /// Update last visit timestamp
  Future<void> updateLastVisit(String customerId) async {
    await (update(customers)..where((c) => c.id.equals(customerId)))
        .write(CustomersCompanion(
          lastVisit: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Set preferred technician
  Future<void> setPreferredTechnician(String customerId, int? technicianId) async {
    await (update(customers)..where((c) => c.id.equals(customerId)))
        .write(CustomersCompanion(
          preferredTechnicianId: Value(technicianId),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Get customers with birthdays in date range (for birthday promotions)
  Future<List<Customer>> getCustomersBirthdayRange(DateTime startDate, DateTime endDate) {
    return (select(customers)
      ..where((c) => c.dateOfBirth.isNotNull() & 
                    c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm.asc(c.dateOfBirth)]))
    .get();
    // Note: Birthday range filtering by month/day would need custom SQL for proper date part comparison
  }

  /// Get customers who haven't visited in X days
  Future<List<Customer>> getInactiveCustomers(int daysSinceLastVisit) {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysSinceLastVisit));
    
    return (select(customers)
      ..where((c) => c.lastVisit.isSmallerThanValue(cutoffDate) |
                    c.lastVisit.isNull())
      ..where((c) => c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm.desc(c.lastVisit)]))
    .get();
  }

  /// Create new customer with validation
  Future<String> createCustomer({
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? allergies,
    String? notes,
    bool emailOptIn = false,
    bool smsOptIn = false,
  }) async {
    // Validate unique email if provided
    if (email != null && email.isNotEmpty) {
      final existing = await getByEmail(email);
      if (existing != null) {
        throw Exception('Customer with this email already exists');
      }
    }

    final customerId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    await into(customers).insert(CustomersCompanion.insert(
      id: customerId,
      firstName: firstName,
      lastName: lastName,
      email: Value(email?.toLowerCase()),
      phone: Value(phone),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      address: Value(address),
      city: Value(city),
      state: Value(state),
      zipCode: Value(zipCode),
      allergies: Value(allergies),
      notes: Value(notes),
      emailOptIn: Value(emailOptIn),
      smsOptIn: Value(smsOptIn),
      createdAt: now,
      updatedAt: now,
    ));

    return customerId;
  }
}

// Helper classes
class CustomerWithTechnician {
  final Customer customer;
  final Employee? preferredTechnician;

  CustomerWithTechnician({
    required this.customer,
    this.preferredTechnician,
  });
}

class CustomerVisitHistory {
  final Customer customer;
  final List<Ticket> recentTickets;
  final List<Appointment> recentAppointments;
  final int totalSpentCents;
  final int totalVisits;

  CustomerVisitHistory({
    required this.customer,
    required this.recentTickets,
    required this.recentAppointments,
    required this.totalSpentCents,
    required this.totalVisits,
  });
}
