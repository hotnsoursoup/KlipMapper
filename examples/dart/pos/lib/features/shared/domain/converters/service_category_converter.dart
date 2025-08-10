// lib/features/shared/domain/converters/service_category_converter.dart
// Converter providing translation layer between Drift database models and ServiceCategory domain models.
// Decouples database implementation from business logic following clean architecture principles.
// Usage: ACTIVE - Essential for domain/data layer separation in service category operations

import '../../../../core/database/database.dart' as db;
import '../models/service_category_domain.dart';

/// Converter between Drift database models and ServiceCategory domain models
/// 
/// This class provides the translation layer that decouples the database
/// implementation from the business logic layer, following clean architecture principles.
class ServiceCategoryConverter {
  /// Convert from Drift database model to domain model
  static ServiceCategoryDomain fromDrift(db.ServiceCategory driftModel) {
    return ServiceCategoryDomain(
      id: driftModel.id.toString(),
      name: driftModel.name,
      colorHex: driftModel.color ?? '#6B7280',
      createdAt: DateTime.now(), // Drift model doesn't have createdAt field
    );
  }

  /// Convert from domain model to Drift database model
  static db.ServiceCategory toDrift(ServiceCategoryDomain domainModel) {
    return db.ServiceCategory(
      id: int.tryParse(domainModel.id) ?? 0,
      name: domainModel.name,
      color: domainModel.colorHex,
    );
  }

  /// Convert a list of Drift models to domain models
  static List<ServiceCategoryDomain> fromDriftList(List<db.ServiceCategory> driftModels) {
    return driftModels.map(fromDrift).toList();
  }

  /// Convert a list of domain models to Drift models
  static List<db.ServiceCategory> toDriftList(List<ServiceCategoryDomain> domainModels) {
    return domainModels.map(toDrift).toList();
  }

  /// Create a new domain model with generated ID for creation
  static ServiceCategoryDomain createNew({
    required String name,
    String colorHex = '#6B7280',
    bool isActive = true,
  }) {
    final now = DateTime.now();
    return ServiceCategoryDomain(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      colorHex: colorHex,
      isActive: isActive,
      createdAt: now,
    );
  }
}
