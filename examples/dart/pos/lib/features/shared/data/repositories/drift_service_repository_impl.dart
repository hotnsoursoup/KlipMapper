// lib/features/shared/data/repositories/drift_service_repository_impl.dart
// Clean architecture implementation of ServiceRepository interface using Drift database operations.
// Bridges domain layer with data persistence, handling service and category CRUD operations with proper conversion layers.
// Usage: ACTIVE - Primary implementation of domain service repository interface

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../../domain/models/service_category_domain.dart';
import '../../domain/models/service_domain.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/converters/service_category_converter.dart';
import '../../domain/converters/service_converter.dart';
import '../models/service_model.dart';
import '../../../../utils/error_logger.dart';

/// Drift-based implementation of ServiceRepository
/// 
/// This class implements the domain repository interface using Drift database.
/// It follows clean architecture by keeping database concerns separate from domain logic.
class DriftServiceRepositoryImpl implements ServiceRepository {
  static DriftServiceRepositoryImpl? _instance;
  static DriftServiceRepositoryImpl get instance => _instance ??= DriftServiceRepositoryImpl._();
  
  DriftServiceRepositoryImpl._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftServiceRepositoryImpl initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftServiceRepositoryImpl initialization', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<ServiceCategoryDomain>> getServiceCategories() async {
    await initialize();
    
    try {
      final categories = await _database!.select(_database!.serviceCategories).get();
      return ServiceCategoryConverter.fromDriftList(categories);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch service categories', e, stack);
      return [];
    }
  }

  @override
  Future<List<ServiceDomain>> getServices() async {
    try {
      await initialize();
      
      final services = await (_database!.select(_database!.services)
        ..where((s) => s.isActive.equals(true))
        ..orderBy([
          (s) => OrderingTerm(expression: s.name),
        ]))
        .get();

      // Convert Drift services to data models, then to domain models
      final dataModels = services.map((s) => _convertDriftToDataModel(s)).toList();
      return ServiceConverter.fromDataModelList(dataModels);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch services', e, stack);
      return [];
    }
  }

  @override
  Future<List<ServiceDomain>> getServicesByCategory(int categoryId) async {
    try {
      await initialize();
      
      final services = await (_database!.select(_database!.services)
        ..where((s) => s.categoryId.equals(categoryId))
        ..where((s) => s.isActive.equals(true))
        ..orderBy([
          (s) => OrderingTerm(expression: s.name),
        ]))
        .get();

      final dataModels = services.map((s) => _convertDriftToDataModel(s)).toList();
      return ServiceConverter.fromDataModelList(dataModels);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch services by category', e, stack);
      return [];
    }
  }

  @override
  Future<ServiceCategoryDomain> createServiceCategory({
    required String name,
    required String colorHex,
  }) async {
    try {
      await initialize();
      
      // Insert new category (auto-increment id)
      final newId = await _database!.into(_database!.serviceCategories).insert(
        db.ServiceCategoriesCompanion(
          name: Value(name),
          color: Value(colorHex),
        ),
      );
      
      return ServiceCategoryDomain(
        id: newId.toString(),
        name: name,
        colorHex: colorHex,
        createdAt: DateTime.now(),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create service category', e, stack);
      rethrow;
    }
  }

  @override
  Future<ServiceDomain> createService({
    required String name,
    required String description,
    required int durationMinutes,
    required double basePrice,
    required int categoryId,
  }) async {
    try {
      await initialize();
      
      final id = await _database!.into(_database!.services).insert(
        db.ServicesCompanion(
          name: Value(name),
          description: Value(description),
          durationMinutes: Value(durationMinutes),
          basePriceCents: Value((basePrice * 100).round()),
          categoryId: Value(categoryId),
          isActive: const Value(true),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      
      return ServiceDomain(
        id: id.toString(),
        name: name,
        description: description,
        durationMinutes: durationMinutes,
        basePrice: basePrice,
        categoryId: categoryId,
        createdAt: DateTime.now(),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create service', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> updateService(ServiceDomain service) async {
    try {
      await initialize();
      
      final serviceId = int.tryParse(service.id) ?? 0;
      
      await (_database!.update(_database!.services)
        ..where((s) => s.id.equals(serviceId)))
        .write(db.ServicesCompanion(
          name: Value(service.name),
          description: Value(service.description),
          durationMinutes: Value(service.durationMinutes),
          basePriceCents: Value((service.basePrice * 100).round()),
          categoryId: Value(service.categoryId),
          isActive: Value(service.isActive),
          updatedAt: Value(DateTime.now()),
        ),);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update service', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> updateServiceCategory(ServiceCategoryDomain category) async {
    try {
      await initialize();
      
      final intId = int.tryParse(category.id) ?? -1;
      await (_database!.update(_database!.serviceCategories)
        ..where((c) => c.id.equals(intId)))
        .write(db.ServiceCategoriesCompanion(
          name: Value(category.name),
          color: Value(category.colorHex),
        ),);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update service category', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      await initialize();
      
      final id = int.tryParse(serviceId) ?? 0;
      await (_database!.update(_database!.services)
        ..where((s) => s.id.equals(id)))
        .write(const db.ServicesCompanion(
          isActive: Value(0),
        ),);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteServiceCategory(int categoryId) async {
    try {
      await initialize();
      
      // Note: This is a soft delete by deactivating all services in the category
      // Since we don't have isActive on ServiceCategories table
      await (_database!.update(_database!.services)
        ..where((s) => s.categoryId.equals(categoryId)))
        .write(const db.ServicesCompanion(
          isActive: Value(false),
        ),);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service category', e, stack);
      rethrow;
    }
  }

  /// Convert Drift Service to Data Model Service (compatibility layer)
  Service _convertDriftToDataModel(db.Service driftService) {
    return Service(
      id: driftService.id.toString(),
      name: driftService.name,
      description: driftService.description ?? '',
      categoryId: driftService.categoryId,
      basePrice: driftService.basePriceCents / 100.0,
      durationMinutes: driftService.durationMinutes,
      isActive: driftService.isActive,
      createdAt: driftService.createdAt,
      updatedAt: driftService.updatedAt,
    );
  }
}
