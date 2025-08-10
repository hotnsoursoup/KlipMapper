// lib/features/shared/data/repositories/service_repository.dart
// Legacy service repository wrapper providing backwards compatibility while delegating operations to DriftServiceRepository.
// Maintains legacy API surface for existing code while using modern Drift-based implementations underneath.
// Usage: ACTIVE - Used by legacy code, but deprecated in favor of DriftServiceRepository

import '../models/service_model.dart';
import 'drift_service_repository.dart';
import '../../../../utils/error_logger.dart';

/// Repository for service data management
/// DEPRECATED: Use DriftServiceRepository directly
class ServiceRepository {
  final DriftServiceRepository _driftRepo = DriftServiceRepository.instance;

  // Singleton pattern
  static final ServiceRepository instance = ServiceRepository._internal();
  ServiceRepository._internal();

  /// Get all active services
  Future<List<Service>> getAllServices({bool activeOnly = true}) async {
    try {
      return await _driftRepo.getServices();
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.getAllServices', e, stack);
      return [];
    }
  }

  /// Get services by category
  Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      return await _driftRepo.getServicesByCategory(categoryId);
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.getServicesByCategory', e, stack);
      return [];
    }
  }

  /// Get service by ID
  @Deprecated('Use DriftServiceRepository directly')
  Future<Service?> getServiceById(String id) async {
    throw UnimplementedError(
      'ServiceRepository.getServiceById() is deprecated. '
      'Use DriftServiceRepository.instance methods instead.'
    );
  }

  /// Search services
  @Deprecated('Use DriftServiceRepository directly')
  Future<List<Service>> searchServices(String query) async {
    throw UnimplementedError(
      'ServiceRepository.searchServices() is deprecated. '
      'Use DriftServiceRepository.instance methods instead.'
    );
  }

  /// Get all categories  
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final categories = await _driftRepo.getCategoriesWithCounts();
      return categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'display_order': 0, // Default display order since not in current schema
      },).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.getAllCategories', e, stack);
      return [];
    }
  }

  /// Create service
  Future<Service> createService(Service service) async {
    try {
      return await _driftRepo.createService(
        name: service.name,
        description: '', // Default description since not in Service model
        durationMinutes: service.durationMinutes,
        basePrice: service.price,
        categoryId: service.categoryId,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.createService', e, stack);
      rethrow;
    }
  }

  /// Update service
  Future<void> updateService(Service service) async {
    try {
      await _driftRepo.updateService(service);
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.updateService', e, stack);
      rethrow;
    }
  }

  /// Delete service
  Future<void> deleteService(String id) async {
    try {
      await _driftRepo.deleteService(id);
    } catch (e, stack) {
      ErrorLogger.logError('Error in ServiceRepository.deleteService', e, stack);
      rethrow;
    }
  }

  /// All other methods are deprecated
  @Deprecated('Use DriftServiceRepository directly')
  Future<void> toggleServiceActive(String id, bool isActive) async {
    throw UnimplementedError(
      'ServiceRepository legacy methods are deprecated. '
      'Use DriftServiceRepository.instance instead.'
    );
  }

  @Deprecated('Use DriftServiceRepository directly')
  Future<List<Service>> getPopularServices({int limit = 10}) async {
    throw UnimplementedError(
      'ServiceRepository legacy methods are deprecated. '
      'Use DriftServiceRepository.instance instead.'
    );
  }
}