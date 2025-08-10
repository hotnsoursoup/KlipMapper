// lib/features/shared/data/repositories/drift_service_repository.dart
// Drift repository implementation for service and service category management with caching, category mapping, and CRUD operations.
// Usage: ACTIVE - Primary service data access layer with category cache optimization
import 'package:drift/drift.dart';
import '../../../../core/database/drift_database.dart' as db;
import '../models/service_model.dart';
import '../../../../utils/error_logger.dart';

/// Drift-based Service Repository
/// This loads services from the database with proper category mapping
class DriftServiceRepository {
  static DriftServiceRepository? _instance;
  static DriftServiceRepository get instance => _instance ??= DriftServiceRepository._();
  
  DriftServiceRepository._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  // Cache for category mappings
  static final Map<int, String> _categoryCache = {};
  static bool _categoriesLoaded = false;
  
  /// Get category name from ID (with caching)
  static String getCategoryName(int categoryId) {
    // Try cache first
    if (_categoryCache.containsKey(categoryId)) {
      return _categoryCache[categoryId]!;
    }
    
    // Fallback for common categories
    switch (categoryId) {
      case 1:
        return 'Nails';
      case 2:
        return 'Gel';
      case 3:
        return 'Acrylic';
      case 4:
        return 'Waxing';
      case 5:
        return 'Facials';
      case 6:
        return 'SNS/Dip';
      default:
        return 'Other';
    }
  }
  
  /// Get all service categories from database
  Future<List<db.ServiceCategory>> getServiceCategories() async {
    await initialize();
    
    try {
      final categories = await _database!.select(_database!.serviceCategories).get();
      
      // Update cache
      for (final category in categories) {
        if (category.id != null) {
          final categoryId = int.tryParse(category.id!);
          if (categoryId != null) {
            _categoryCache[categoryId] = category.name;
          }
        }
      }
      _categoriesLoaded = true;
      
      return categories;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch service categories', e, stack);
      return [];
    }
  }
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      // Ensure database is fully initialized
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftServiceRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftServiceRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Get all active services
  Future<List<Service>> getServices() async {
    try {
      await initialize();
      
      final services = await (_database!.select(_database!.services)
        ..where((s) => s.isActive.equals(true))
        ..orderBy([
          (s) => OrderingTerm(expression: s.name),
        ]))
        .get();

      return services.map((s) => _convertToModel(s)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch services', e, stack);
      return [];
    }
  }

  /// Get all services (including inactive)
  Future<List<Service>> getAllServices() async {
    try {
      await initialize();

      final rows = await (_database!.select(_database!.services)
            ..orderBy([(s) => OrderingTerm(expression: s.name)])).
          get();

      return rows.map(_convertToModel).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch all services', e, stack);
      return [];
    }
  }

  /// Get services by category
  Future<List<Service>> getServicesByCategory(String category) async {
    try {
      await initialize();
      
      // Load categories if not cached
      if (!_categoriesLoaded) {
        await getCategoriesWithCounts();
      }
      
      // Find category ID from name
      int? categoryId;
      for (var entry in _categoryCache.entries) {
        if (entry.value == category) {
          categoryId = entry.key;
          break;
        }
      }
      
      if (categoryId == null) return [];
      
      final services = await (_database!.select(_database!.services)
        ..where((s) => s.isActive.equals(true))
        ..orderBy([
          (s) => OrderingTerm(expression: s.name),
        ]))
        .get();

      return services
          .where((s) => s.categoryId == categoryId)
          .map((s) => _convertToModel(s))
          .toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch services by category', e, stack);
      return [];
    }
  }

  /// Convert Drift Service to Model Service
  Service _convertToModel(db.Service driftService) {
    return Service(
      id: driftService.id.toString(),
      name: driftService.name,
      description: driftService.description ?? '',
      categoryId: driftService.categoryId,
      basePrice: (driftService.basePriceCents / 100.0),
      durationMinutes: driftService.durationMinutes,
      isActive: driftService.isActive,
      createdAt: driftService.createdAt,
      updatedAt: driftService.updatedAt,
    );
  }

  /// Get all active service categories with their service counts
  Future<List<ServiceCategoryWithCount>> getCategoriesWithCounts() async {
    try {
      await initialize();
      
      // Load all categories
      final categories = await _database!.select(_database!.serviceCategories).get();
      
      // Get service counts for each category
      final List<ServiceCategoryWithCount> result = [];
      
      for (final cat in categories) {
        // Parse category ID to int
        final categoryId = int.tryParse(cat.id ?? '') ?? 0;
        
        // Count services in this category
        final serviceCount = await (_database!.select(_database!.services)
          ..where((s) => s.categoryId.equals(categoryId))
          ..where((s) => s.isActive.equals(true)))
          .get()
          .then((services) => services.length);
        
        // Only include categories that have services
        if (serviceCount > 0) {
          // Cache the category name
          _categoryCache[categoryId] = cat.name;
          
          result.add(ServiceCategoryWithCount(
            id: categoryId,
            name: cat.name,
            color: cat.color ?? '#808080',
            serviceCount: serviceCount,
          ),);
        }
      }
      
      _categoriesLoaded = true;
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch categories', e, stack);
      return [];
    }
  }
  
  /// Get service categories (legacy method)
  Future<List<ServiceCategory>> getCategories() async {
    final categoriesWithCount = await getCategoriesWithCounts();
    return categoriesWithCount.map((cat) => ServiceCategory(
      id: cat.id.toString(),
      name: cat.name,
      color: cat.color,
    ),).toList();
  }
  
  /// Create a new service
  Future<Service> createService({
    required String name,
    required String description,
    required int durationMinutes,
    required double basePrice,
    required int categoryId,
  }) async {
    try {
      await initialize();
      
      // categoryId is now passed as int directly
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
      
      return Service(
        id: id.toString(),
        name: name,
        description: description,
        categoryId: categoryId,
        basePrice: basePrice,
        durationMinutes: durationMinutes,
        isActive: true,
        createdAt: DateTime.now(),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create service', e, stack);
      rethrow;
    }
  }

  /// Insert a new service from model (compat with providers)
  Future<void> insertService(Service service) async {
    try {
      await initialize();
      await _database!.into(_database!.services).insert(
        db.ServicesCompanion(
          name: Value(service.name),
          description: Value(service.description),
          durationMinutes: Value(service.durationMinutes),
          basePriceCents: Value((service.basePrice * 100).round()),
          categoryId: Value(service.categoryId),
          isActive: Value(service.isActive),
          createdAt: Value(service.createdAt),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to insert service', e, stack);
      rethrow;
    }
  }
  
  /// Update an existing service
  Future<void> updateService(Service service) async {
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
  
  /// Delete a service (soft delete by setting isActive to 0)
  Future<void> deleteService(String serviceId) async {
    try {
      await initialize();
      
      final id = int.tryParse(serviceId) ?? 0;
      await (_database!.update(_database!.services)
        ..where((s) => s.id.equals(id)))
        .write(const db.ServicesCompanion(
          isActive: Value(false),
        ),);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service', e, stack);
      rethrow;
    }
  }

  /// Delete a service (compat) by numeric id
  Future<void> deleteServiceCompat(int serviceId) async {
    await deleteServiceById(serviceId);
  }

  /// Delete a service by numeric id (soft delete)
  Future<void> deleteServiceById(int serviceId) async {
    try {
      await initialize();
      await (_database!.update(_database!.services)
            ..where((s) => s.id.equals(serviceId)))
          .write(const db.ServicesCompanion(isActive: Value(0))); 
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service by id', e, stack);
      rethrow;
    }
  }
  
  /// Create a new service category
  Future<ServiceCategoryWithCount> createServiceCategory({
    required String name,
    required String color,
  }) async {
    try {
      await initialize();
      
      // Insert new category (auto-increment id)
      final newId = await _database!.into(_database!.serviceCategories).insert(
        db.ServiceCategoriesCompanion(
          name: Value(name),
          color: Value(color),
        ),
      );
      
      // Clear cache to force reload
      _categoriesLoaded = false;
      _categoryCache.clear();
      
      return ServiceCategoryWithCount(
        id: newId,
        name: name,
        color: color,
        serviceCount: 0,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create service category', e, stack);
      rethrow;
    }
  }

  /// Insert service category (compat with providers)
  Future<void> insertServiceCategory(String name, String color) async {
    await createServiceCategory(name: name, color: color);
  }

  /// Update service category by id
  Future<void> updateServiceCategory(String id, String name, String color) async {
    try {
      await initialize();
      final intId = int.tryParse(id) ?? -1;
      await (_database!.update(_database!.serviceCategories)
            ..where((c) => c.id.equals(intId)))
          .write(db.ServiceCategoriesCompanion(
            name: Value(name),
            color: Value(color),
          ));
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update service category', e, stack);
      rethrow;
    }
  }

  /// Delete service category by id
  Future<void> deleteServiceCategory(String id) async {
    try {
      await initialize();
      final intId = int.tryParse(id) ?? -1;
      await (_database!.delete(_database!.serviceCategories)
            ..where((c) => c.id.equals(intId)))
          .go();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service category', e, stack);
      rethrow;
    }
  }
}

/// Service Category model
class ServiceCategory {
  final String id;
  final String name;
  final String color;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.color,
  });
}

/// Service Category with service count
class ServiceCategoryWithCount {
  final int id;
  final String name;
  final String color;
  final int serviceCount;

  ServiceCategoryWithCount({
    required this.id,
    required this.name,
    required this.color,
    required this.serviceCount,
  });
}
