// lib/features/services/providers/services_provider.dart
// Master Riverpod providers for service and category management with comprehensive filtering, grouping, and state management.
// Usage: ACTIVE - Primary service state management throughout the application
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models/service_model.dart';
import '../../shared/data/repositories/drift_service_repository.dart';
import '../../../core/database/database.dart' as db;
import '../../../utils/error_logger.dart';

part 'services_provider.g.dart';

/// Repository provider - single source of truth for repository access
@riverpod
DriftServiceRepository serviceRepository(Ref ref) {
  return DriftServiceRepository.instance;
}

/// Master services provider - single source of truth for ALL services
/// This is the ONLY provider that fetches services from the database
@riverpod
class ServicesMaster extends _$ServicesMaster {
  Timer? _refreshTimer;
  
  @override
  Future<List<Service>> build() async {
    // Set up auto-refresh every 2 minutes
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      ref.invalidateSelf();
    });
    
    // Clean up timer on dispose
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });
    
    return _loadAllServices();
  }
  
  Future<List<Service>> _loadAllServices() async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.initialize();
      
      // Load ALL services from database (including inactive)
      final services = await repo.getAllServices();
      
      ErrorLogger.logInfo('ServicesMaster: Loaded ${services.length} total services');
      return services;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load master services', e, stack);
      throw Exception('Failed to load services: $e');
    }
  }
  
  /// Add a new service
  Future<void> addService(Service service) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.insertService(service);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to add service', e, stack);
      rethrow;
    }
  }
  
  /// Update an existing service
  Future<void> updateService(Service service) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.updateService(service);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update service', e, stack);
      rethrow;
    }
  }
  
  /// Delete a service (soft delete - sets inactive)
  Future<void> deleteService(int serviceId) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.deleteServiceById(serviceId);
      
      // Refresh the master list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete service', e, stack);
      rethrow;
    }
  }
  
  /// Force refresh services from database
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Master service categories provider
@riverpod
class ServiceCategoriesMaster extends _$ServiceCategoriesMaster {
  @override
  Future<List<db.ServiceCategory>> build() async {
    return _loadAllCategories();
  }
  
  Future<List<db.ServiceCategory>> _loadAllCategories() async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.initialize();
      
      final categories = await repo.getServiceCategories();
      
      ErrorLogger.logInfo('ServiceCategoriesMaster: Loaded ${categories.length} categories');
      return categories;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to load service categories', e, stack);
      throw Exception('Failed to load categories: $e');
    }
  }
  
  /// Add a new category
  Future<void> addCategory(String name, String color) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.insertServiceCategory(name, color);
      
      // Refresh the categories list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to add category', e, stack);
      rethrow;
    }
  }
  
  /// Update a category
  Future<void> updateCategory(String id, String name, String color) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.updateServiceCategory(id, name, color);
      
      // Refresh the categories list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update category', e, stack);
      rethrow;
    }
  }
  
  /// Delete a category
  Future<void> deleteCategory(String id) async {
    try {
      final repo = ref.read(serviceRepositoryProvider);
      await repo.deleteServiceCategory(id);
      
      // Refresh the categories list
      ref.invalidateSelf();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete category', e, stack);
      rethrow;
    }
  }
}

// ========== FILTER CLASSES ==========

/// Filter for services
class ServiceFilter {
  final int? categoryId;
  final bool? includeInactive;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  
  const ServiceFilter({
    this.categoryId,
    this.includeInactive,
    this.search,
    this.minPrice,
    this.maxPrice,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceFilter &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          includeInactive == other.includeInactive &&
          search == other.search &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice;
  
  @override
  int get hashCode =>
      categoryId.hashCode ^
      includeInactive.hashCode ^
      search.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode;
}

// ========== FAMILY PROVIDERS FOR FILTERING ==========

/// Provider for services filtered by criteria
/// Uses family to enable caching per filter combination
@riverpod
List<Service> servicesByFilter(Ref ref, ServiceFilter filter) {
  // Watch the master list
  final allServicesAsync = ref.watch(servicesMasterProvider);
  
  return allServicesAsync.when(
    data: (services) {
      var filtered = services;
      
      // Apply inactive filter (default: hide inactive)
      if (filter.includeInactive != true) {
        filtered = filtered.where((s) => s.isActive).toList();
      }
      
      // Apply category filter
      if (filter.categoryId != null) {
        filtered = filtered.where((s) => s.categoryId == filter.categoryId).toList();
      }
      
      // Apply search filter
      if (filter.search != null && filter.search!.isNotEmpty) {
        final query = filter.search!.toLowerCase();
        filtered = filtered.where((s) =>
          s.name.toLowerCase().contains(query) ||
          (s.description?.toLowerCase().contains(query) ?? false)
        ).toList();
      }
      
      // Apply price filters
      if (filter.minPrice != null) {
        filtered = filtered.where((s) => s.price >= filter.minPrice!).toList();
      }
      if (filter.maxPrice != null) {
        filtered = filtered.where((s) => s.price <= filter.maxPrice!).toList();
      }
      
      // Sort by name
      filtered.sort((a, b) => a.name.compareTo(b.name));
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for services by category
@riverpod
List<Service> servicesByCategory(Ref ref, int categoryId) {
  return ref.watch(servicesByFilterProvider(
    ServiceFilter(categoryId: categoryId),
  ));
}

// ========== COMPOSED PROVIDERS FOR COMMON VIEWS ==========

/// Provider for active services only
@riverpod
List<Service> activeServices(Ref ref) {
  return ref.watch(servicesByFilterProvider(
    const ServiceFilter(includeInactive: false),
  ));
}

/// Provider for services grouped by category
@riverpod
Map<int, List<Service>> servicesGroupedByCategory(Ref ref) {
  final allServicesAsync = ref.watch(servicesMasterProvider);
  
  return allServicesAsync.when(
    data: (services) {
      final grouped = <int, List<Service>>{};
      
      for (final service in services.where((s) => s.isActive)) {
        final categoryId = service.categoryId ?? 0;
        grouped.putIfAbsent(categoryId, () => []).add(service);
      }
      
      // Sort services within each category
      grouped.forEach((key, value) {
        value.sort((a, b) => a.name.compareTo(b.name));
      });
      
      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
}

/// Provider for service by ID
@riverpod
Service? serviceById(Ref ref, int serviceId) {
  final allServicesAsync = ref.watch(servicesMasterProvider);
  
  return allServicesAsync.when(
    data: (services) {
      try {
        return services.firstWhere((s) => s.id == serviceId);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for service statistics
@riverpod
ServiceStatistics serviceStatistics(Ref ref) {
  final allServicesAsync = ref.watch(servicesMasterProvider);
  final categoriesAsync = ref.watch(serviceCategoriesMasterProvider);
  
  return allServicesAsync.when(
    data: (services) {
      final activeCount = services.where((s) => s.isActive).length;
      final inactiveCount = services.where((s) => !s.isActive).length;
      
      final categoryCount = categoriesAsync.when(
        data: (categories) => categories.length,
        loading: () => 0,
        error: (_, __) => 0,
      );
      
      // Calculate average price
      final activeServices = services.where((s) => s.isActive);
      final averagePrice = activeServices.isEmpty 
        ? 0.0 
        : activeServices.map((s) => s.price).reduce((a, b) => a + b) / activeServices.length;
      
      return ServiceStatistics(
        totalCount: services.length,
        activeCount: activeCount,
        inactiveCount: inactiveCount,
        categoryCount: categoryCount,
        averagePrice: averagePrice,
      );
    },
    loading: () => const ServiceStatistics(),
    error: (_, __) => const ServiceStatistics(),
  );
}

/// Service statistics model
class ServiceStatistics {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final int categoryCount;
  final double averagePrice;
  
  const ServiceStatistics({
    this.totalCount = 0,
    this.activeCount = 0,
    this.inactiveCount = 0,
    this.categoryCount = 0,
    this.averagePrice = 0.0,
  });
}

// ========== UI STATE PROVIDERS ==========

/// Search query for services screen
@riverpod
class ServiceSearchQuery extends _$ServiceSearchQuery {
  @override
  String build() => '';
  
  void setQuery(String query) {
    state = query;
  }
}

/// Selected category filter
@riverpod
class ServiceCategoryFilter extends _$ServiceCategoryFilter {
  @override
  int? build() => null;
  
  void setCategory(int? categoryId) {
    state = categoryId;
  }
}

/// Show inactive services toggle
@riverpod
class ShowInactiveServices extends _$ShowInactiveServices {
  @override
  bool build() => false;
  
  void toggle() {
    state = !state;
  }
}

/// Expanded categories in UI
@riverpod
class ExpandedServiceCategories extends _$ExpandedServiceCategories {
  @override
  Set<int> build() => {};
  
  void toggleCategory(int categoryId) {
    if (state.contains(categoryId)) {
      state = {...state}..remove(categoryId);
    } else {
      state = {...state, categoryId};
    }
  }
  
  void expandAll() {
    final categoriesAsync = ref.read(serviceCategoriesMasterProvider);
    categoriesAsync.whenData((categories) {
      state = categories.map((c) => int.parse(c.id!)).toSet();
    });
  }
  
  void collapseAll() {
    state = {};
  }
}
