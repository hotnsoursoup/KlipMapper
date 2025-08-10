// lib/features/shared/data/repositories/customer_repository.dart
// Legacy compatibility wrapper for customer data operations using DriftCustomerRepository.
// Provides backwards compatibility layer for legacy Customer model while underlying operations use Drift ORM.
// Usage: ACTIVE - Used by legacy code, but deprecated in favor of DriftCustomerRepository

import '../models/customer_model.dart';
import 'drift_customer_repository.dart';
import '../../../../utils/error_logger.dart';

/// Repository for customer data management
/// DEPRECATED: Use DriftCustomerRepository directly with Customer
class CustomerRepository {
  final DriftCustomerRepository _driftRepo = DriftCustomerRepository.instance;

  // Singleton pattern
  static final CustomerRepository instance = CustomerRepository._internal();
  CustomerRepository._internal();

  /// Get all customers (returns legacy Customer objects for backward compatibility)
  Future<List<Customer>> getAllCustomers() async {
    try {
      final customersV3 = await _driftRepo.getCustomers();
      return customersV3.map((c) => _convertToLegacy(c)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.getAllCustomers', e, stack);
      return [];
    }
  }

  /// Get customer by ID (returns legacy Customer object for backward compatibility)
  Future<Customer?> getCustomerById(String id) async {
    try {
      final customerV3 = await _driftRepo.getCustomerById(id);
      return customerV3 != null ? _convertToLegacy(customerV3) : null;
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.getCustomerById', e, stack);
      return null;
    }
  }

  /// Search customers by name or phone (returns legacy Customer objects)
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      final customersV3 = await _driftRepo.searchCustomers(query);
      return customersV3.map((c) => _convertToLegacy(c)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.searchCustomers', e, stack);
      return [];
    }
  }

  /// Create new customer (accepts legacy Customer object)
  Future<Customer> createCustomer(Customer customer) async {
    try {
      final customerV3 = await _driftRepo.createCustomerLegacy(
        name: customer.name,
        phone: customer.phone ?? '',
        email: customer.email,
        notes: customer.notes,
      );
      return _convertToLegacy(customerV3);
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.createCustomer', e, stack);
      rethrow;
    }
  }

  /// Delete customer
  Future<void> deleteCustomer(String id) async {
    try {
      await _driftRepo.deleteCustomer(id);
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.deleteCustomer', e, stack);
      rethrow;
    }
  }

  // Methods requiring CustomerV3 features - provide helpful migration messages
  @Deprecated('Use DriftCustomerRepository with CustomerV3 model for full functionality')
  Future<void> updateCustomer(String id, Map<String, dynamic> updates) async {
    try {
      // Get current customer
      final currentV3 = await _driftRepo.getCustomerById(id);
      if (currentV3 == null) {
        throw Exception('Customer not found: $id');
      }

      // Apply basic updates that we can handle
      Customer updatedCustomer = currentV3;
      
      if (updates.containsKey('name')) {
        final nameParts = (updates['name'] as String).split(' ');
        updatedCustomer = updatedCustomer.copyWith(
          firstName: nameParts.isNotEmpty ? nameParts.first : '',
          lastName: nameParts.length > 1 ? nameParts.skip(1).join(' ') : '',
        );
      }
      
      if (updates.containsKey('phone')) {
        updatedCustomer = updatedCustomer.copyWith(phone: updates['phone'] as String?);
      }
      
      if (updates.containsKey('email')) {
        updatedCustomer = updatedCustomer.copyWith(email: updates['email'] as String?);
      }
      
      if (updates.containsKey('notes')) {
        updatedCustomer = updatedCustomer.copyWith(notes: updates['notes'] as String?);
      }

      await _driftRepo.updateCustomer(updatedCustomer);
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.updateCustomer', e, stack);
      rethrow;
    }
  }

  @Deprecated('Use Customer.addLoyaltyPoints() with DriftCustomerRepository')
  Future<void> updateLoyaltyPoints(String customerId, int points) async {
    try {
      final customer = await _driftRepo.getCustomerById(customerId);
      if (customer == null) {
        throw Exception('Customer not found: $customerId');
      }
      
      final updatedCustomer = customer.addLoyaltyPoints(points);
      await _driftRepo.updateCustomer(updatedCustomer);
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.updateLoyaltyPoints', e, stack);
      rethrow;
    }
  }

  @Deprecated('Use Customer.updateLastVisit() with DriftCustomerRepository')
  Future<void> updateCustomerStats(String customerId, double amount) async {
    try {
      final customer = await _driftRepo.getCustomerById(customerId);
      if (customer == null) {
        throw Exception('Customer not found: $customerId');
      }
      
      // Update last visit and add loyalty points based on amount spent
      final loyaltyPoints = (amount / 10).floor(); // 1 point per $10 spent
      final updatedCustomer = customer
          .updateLastVisit()
          .addLoyaltyPoints(loyaltyPoints);
      
      await _driftRepo.updateCustomer(updatedCustomer);
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.updateCustomerStats', e, stack);
      rethrow;
    }
  }

  @Deprecated('Use Customer model directly with loyalty point information')
  Future<Map<String, dynamic>> getCustomerStats(String customerId) async {
    try {
      final customer = await _driftRepo.getCustomerById(customerId);
      if (customer == null) {
        return {'loyalty_points': 0, 'total_spent': 0.0, 'visit_count': 0};
      }
      
      return {
        'loyalty_points': customer.loyaltyPoints,
        'total_spent': 0.0, // Not tracked in current schema
        'visit_count': 0, // Not tracked in current schema
        'membership_level': customer.membershipLevel,
        'last_visit': customer.lastVisit?.toIso8601String(),
      };
    } catch (e, stack) {
      ErrorLogger.logError('Error in CustomerRepository.getCustomerStats', e, stack);
      return {'loyalty_points': 0, 'total_spent': 0.0, 'visit_count': 0};
    }
  }

  /// Convert Customer to legacy Customer model for backward compatibility
  Customer _convertToLegacy(Customer customerV3) {
    return Customer.withName(
      id: customerV3.id,
      name: customerV3.name,
      phone: customerV3.phone ?? '',
      email: customerV3.email,
      preferredTechnician: customerV3.preferredTechnician,
      lastVisit: customerV3.lastVisit,
      notes: customerV3.notes,
      createdAt: customerV3.createdAt,
      updatedAt: customerV3.updatedAt,
    );
  }
}