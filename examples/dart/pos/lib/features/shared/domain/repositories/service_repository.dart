// lib/features/shared/domain/repositories/service_repository.dart
// Clean architecture domain interface defining service repository contracts for service and category operations.
// Abstracts data access patterns from business logic, enabling different implementations (Drift, REST API, etc.).
// Usage: ACTIVE - Core domain interface implemented by DriftServiceRepositoryImpl

import '../models/service_category_domain.dart';
import '../models/service_domain.dart';

/// Abstract repository interface for service-related operations
/// 
/// This interface defines the contract for service data operations in the domain layer.
/// It follows clean architecture principles by abstracting data access concerns
/// and allows for different implementations (Drift, REST API, etc.).
abstract class ServiceRepository {
  /// Get all active service categories
  Future<List<ServiceCategoryDomain>> getServiceCategories();

  /// Get all active services
  Future<List<ServiceDomain>> getServices();

  /// Get services filtered by category ID
  Future<List<ServiceDomain>> getServicesByCategory(int categoryId);

  /// Create a new service category
  Future<ServiceCategoryDomain> createServiceCategory({
    required String name,
    required String colorHex,
  });

  /// Create a new service
  Future<ServiceDomain> createService({
    required String name,
    required String description,
    required int durationMinutes,
    required double basePrice,
    required int categoryId,
  });

  /// Update an existing service
  Future<void> updateService(ServiceDomain service);

  /// Update an existing service category
  Future<void> updateServiceCategory(ServiceCategoryDomain category);

  /// Soft delete a service (set isActive to false)
  Future<void> deleteService(String serviceId);

  /// Soft delete a service category (set isActive to false)
  Future<void> deleteServiceCategory(int categoryId);
}