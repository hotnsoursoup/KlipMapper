// lib/features/shared/domain/converters/service_converter.dart
// Converter providing translation layer between Service data models and Service domain models.
// Decouples database implementation from business logic following clean architecture principles.
// Usage: ACTIVE - Essential for domain/data layer separation in service operations

import '../../data/models/service_model.dart';
import '../models/service_domain.dart';

/// Converter between Service data models and Service domain models
/// 
/// This class provides the translation layer that decouples the database
/// implementation from the business logic layer, following clean architecture principles.
class ServiceConverter {
  /// Convert from data model to domain model
  static ServiceDomain fromDataModel(Service dataModel) {
    return ServiceDomain(
      id: dataModel.id,
      name: dataModel.name,
      description: dataModel.description,
      durationMinutes: dataModel.durationMinutes,
      basePrice: dataModel.basePrice,
      categoryId: dataModel.categoryId,
      isActive: dataModel.isActive,
      createdAt: dataModel.createdAt,
      updatedAt: dataModel.updatedAt,
    );
  }

  /// Convert from domain model to data model
  static Service toDataModel(ServiceDomain domainModel) {
    return Service(
      id: domainModel.id,
      name: domainModel.name,
      description: domainModel.description,
      durationMinutes: domainModel.durationMinutes,
      basePrice: domainModel.basePrice,
      categoryId: domainModel.categoryId,
      isActive: domainModel.isActive,
      createdAt: domainModel.createdAt,
      updatedAt: domainModel.updatedAt,
    );
  }

  /// Convert a list of data models to domain models
  static List<ServiceDomain> fromDataModelList(List<Service> dataModels) {
    return dataModels.map(fromDataModel).toList();
  }

  /// Convert a list of domain models to data models
  static List<Service> toDataModelList(List<ServiceDomain> domainModels) {
    return domainModels.map(toDataModel).toList();
  }

  /// Create a new domain model with generated ID for creation
  static ServiceDomain createNew({
    required String name,
    required String description,
    required int durationMinutes,
    required double basePrice,
    required int categoryId,
    bool isActive = true,
  }) {
    final now = DateTime.now();
    return ServiceDomain(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      durationMinutes: durationMinutes,
      basePrice: basePrice,
      categoryId: categoryId,
      isActive: isActive,
      createdAt: now,
    );
  }
}