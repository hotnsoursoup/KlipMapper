// lib/features/shared/data/repositories/drift_customer_repository.dart
// Drift repository implementation for customer data management with CRUD operations, search, and pagination support.
// Usage: ACTIVE - Primary customer data access layer used by customer providers
import '../../../../core/database/database.dart' as db;
import '../../../../utils/error_logger.dart';
import '../models/customer_model.dart';
import 'package:drift/drift.dart' as drift;

class DriftCustomerRepository {
  static final DriftCustomerRepository _instance = DriftCustomerRepository._internal();
  static DriftCustomerRepository get instance => _instance;
  
  DriftCustomerRepository._internal();
  
  db.PosDatabase? _database;
  
  Future<void> initialize() async {
    try {
      _database = db.PosDatabase.instance;
      ErrorLogger.logInfo('DriftCustomerRepository initialized');
    } catch (e, stack) {
      ErrorLogger.logError('Error initializing DriftCustomerRepository', e, stack);
      rethrow;
    }
  }
  
  Future<List<Customer>> getCustomers() async {
    try {
      await initialize();
      final customers = await _database!.select(_database!.customers).get();
      
      return customers.map((driftCustomer) => Customer.fromDrift(_driftToMap(driftCustomer))).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error getting customers', e, stack);
      return [];
    }
  }
  
  Future<Customer?> getCustomerById(String customerId) async {
    try {
      await initialize();
      final customer = await (_database!.select(_database!.customers)
        ..where((c) => c.id.equals(customerId)))
        .getSingleOrNull();
      
      return customer != null ? Customer.fromDrift(_driftToMap(customer)) : null;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting customer by ID', e, stack);
      return null;
    }
  }
  
  Future<Customer> createCustomer({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? notes,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    int loyaltyPoints = 0,
  }) async {
    try {
      await initialize();
      
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      
      final customer = Customer(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        notes: notes,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        loyaltyPoints: loyaltyPoints,
        createdAt: now,
        updatedAt: now,
      );
      
      await _database!.into(_database!.customers).insert(
        db.CustomersCompanion(
          id: drift.Value(id),
          firstName: drift.Value(firstName),
          lastName: drift.Value(lastName),
          phone: drift.Value(phone),
          email: drift.Value(email),
          notes: drift.Value(notes),
          address: drift.Value(address),
          city: drift.Value(city),
          state: drift.Value(state),
          zipCode: drift.Value(zipCode),
          loyaltyPoints: drift.Value(loyaltyPoints),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(now),
        ),
      );
      
      return customer;
    } catch (e, stack) {
      ErrorLogger.logError('Error creating customer', e, stack);
      rethrow;
    }
  }
  
  /// Create customer with all available database fields
  Future<Customer> createCustomerWithAllFields({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    DateTime? dateOfBirth,
    String? gender,
    String? notes,
    String? allergies,
    bool emailOptIn = true,
    bool smsOptIn = true,
    int loyaltyPoints = 0,
    String? preferredTechnician,
    String status = 'active',
  }) async {
    try {
      await initialize();
      
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      
      final customer = Customer(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        dateOfBirth: dateOfBirth?.toIso8601String(),
        gender: gender,
        notes: notes,
        allergies: allergies,
        emailOptIn: emailOptIn,
        smsOptIn: smsOptIn,
        loyaltyPoints: loyaltyPoints,
        preferredTechnician: preferredTechnician,
        status: status,
        createdAt: now,
        updatedAt: now,
      );
      
      await _database!.into(_database!.customers).insert(
        db.CustomersCompanion(
          id: drift.Value(id),
          firstName: drift.Value(firstName),
          lastName: drift.Value(lastName),
          phone: drift.Value(phone),
          email: drift.Value(email),
          address: drift.Value(address),
          city: drift.Value(city),
          state: drift.Value(state),
          zipCode: drift.Value(zipCode),
          dateOfBirth: drift.Value(dateOfBirth),
          gender: drift.Value(gender),
          notes: drift.Value(notes),
          allergies: drift.Value(allergies),
          emailOptIn: drift.Value(emailOptIn),
          smsOptIn: drift.Value(smsOptIn),
          loyaltyPoints: drift.Value(loyaltyPoints),
          // preferredTechnicianId not set here (unknown)
          status: drift.Value(status),
          isActive: drift.Value(true),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(now),
        ),
      );
      
      return customer;
    } catch (e, stack) {
      ErrorLogger.logError('Error creating customer with all fields', e, stack);
      rethrow;
    }
  }

  // Legacy method for backward compatibility - splits name
  Future<Customer> createCustomerLegacy({
    required String name,
    required String phone,
    String? email,
    String? notes,
  }) async {
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';
    
    return createCustomer(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      notes: notes,
    );
  }
  
  Future<void> updateCustomer(Customer customer) async {
    try {
      await initialize();
      
      final driftData = customer.toDrift();
      await (_database!.update(_database!.customers)
        ..where((c) => c.id.equals(customer.id)))
        .write(
          db.CustomersCompanion(
            firstName: drift.Value(driftData['first_name'] as String?),
            lastName: drift.Value(driftData['last_name'] as String?),
            phone: drift.Value(driftData['phone'] as String?),
            email: drift.Value(driftData['email'] as String?),
            address: drift.Value(driftData['address'] as String?),
            city: drift.Value(driftData['city'] as String?),
            state: drift.Value(driftData['state'] as String?),
            zipCode: drift.Value(driftData['zip_code'] as String?),
            loyaltyPoints: drift.Value(driftData['loyalty_points'] as int?),
            notes: drift.Value(driftData['notes'] as String?),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
    } catch (e, stack) {
      ErrorLogger.logError('Error updating customer', e, stack);
      rethrow;
    }
  }
  
  Future<void> deleteCustomer(String customerId) async {
    try {
      await initialize();
      
      await (_database!.delete(_database!.customers)
        ..where((c) => c.id.equals(customerId)))
        .go();
    } catch (e, stack) {
      ErrorLogger.logError('Error deleting customer', e, stack);
      rethrow;
    }
  }
  
  /// Search customers by name, phone, or email with pagination
  Future<List<Customer>> searchCustomers(String query, {int limit = 20, int offset = 0}) async {
    try {
      await initialize();
      
      final searchTerm = '%$query%';
      final customers = await (_database!.select(_database!.customers)
        ..where((c) => 
          c.firstName.like(searchTerm) | 
          c.lastName.like(searchTerm) |
          c.phone.like(searchTerm) |
          c.email.like(searchTerm),
        )
        ..orderBy([(c) => drift.OrderingTerm(expression: c.firstName)])
        ..limit(limit, offset: offset))
        .get();
      
      return customers.map((driftCustomer) => Customer.fromDrift(_driftToMap(driftCustomer))).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error searching customers', e, stack);
      return [];
    }
  }

  /// Get total count of customers matching search query
  Future<int> getCustomerSearchCount(String query) async {
    try {
      await initialize();
      
      final searchTerm = '%$query%';
      final count = await (_database!.selectOnly(_database!.customers)
        ..addColumns([_database!.customers.id.count()])
        ..where(
          _database!.customers.firstName.like(searchTerm) | 
          _database!.customers.lastName.like(searchTerm) |
          _database!.customers.phone.like(searchTerm) |
          _database!.customers.email.like(searchTerm),
        ))
        .getSingle();
      
      return count.read(_database!.customers.id.count()) ?? 0;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting customer search count', e, stack);
      return 0;
    }
  }
  
  // Helper method to convert Drift object to Map for Customer.fromDrift()
  Map<String, dynamic> _driftToMap(db.Customer driftCustomer) {
    return {
      'id': driftCustomer.id,
      'first_name': driftCustomer.firstName,
      'last_name': driftCustomer.lastName,
      'email': driftCustomer.email,
      'phone': driftCustomer.phone,
      'date_of_birth': driftCustomer.dateOfBirth?.toIso8601String(),
      'gender': driftCustomer.gender,
      'address': driftCustomer.address,
      'city': driftCustomer.city,
      'state': driftCustomer.state,
      'zip_code': driftCustomer.zipCode,
      'loyalty_points': driftCustomer.loyaltyPoints,
      'last_visit': driftCustomer.lastVisit?.toIso8601String(),
      'preferred_technician': driftCustomer.preferredTechnicianId?.toString(),
      'notes': driftCustomer.notes,
      'allergies': driftCustomer.allergies,
      'email_opt_in': driftCustomer.emailOptIn ? 1 : 0,
      'sms_opt_in': driftCustomer.smsOptIn ? 1 : 0,
      'status': driftCustomer.status,
      'is_active': driftCustomer.isActive ? 1 : 0,
      'created_at': driftCustomer.createdAt.toIso8601String(),
      'updated_at': driftCustomer.updatedAt.toIso8601String(),
    };
  }
}
