// lib/features/appointments/data/services/technician_service_compatibility_service.dart
// Service that manages technician-service compatibility logic with caching and detailed compatibility checking. Determines which technicians can perform specific services, provides compatibility results, and suggests alternative technicians for incompatible services.
// Usage: ACTIVE - Core service for appointment scheduling validation and technician assignment logic

import '../../../shared/data/models/employee_model.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/repositories/drift_employee_repository.dart';
import '../../../../core/database/database.dart' as db;
import '../../../../core/utils/logger.dart';

/// Service to handle technician-service compatibility logic
/// Determines which technicians can perform which services based on their capabilities
class TechnicianServiceCompatibilityService {
  static final TechnicianServiceCompatibilityService _instance = 
      TechnicianServiceCompatibilityService._internal();
  
  factory TechnicianServiceCompatibilityService() => _instance;
  TechnicianServiceCompatibilityService._internal();

  final DriftEmployeeRepository _employeeRepository = DriftEmployeeRepository.instance;
  
  // Cache for performance
  final Map<int, List<String>> _technicianCapabilitiesCache = {};
  final Map<String, String> _serviceCategoryCache = {};
  DateTime? _lastCacheUpdate;
  static const Duration _cacheExpiry = Duration(minutes: 10);

  /// Check if a technician can perform a specific service
  Future<bool> canTechnicianPerformService({
    required String technicianId,
    required Service service,
  }) async {
    try {
      // Handle "any" technician case
      if (technicianId == 'any') return true;
      
      final techId = int.tryParse(technicianId);
      if (techId == null) return false;

      // Get technician capabilities
      final capabilities = await _getTechnicianCapabilities(techId);
      
      // Get service category
      final serviceCategory = await _getServiceCategory(service);
      
      // Check if technician has capability for this service category
      return capabilities.contains(serviceCategory);
      
    } catch (e) {
      Logger.error('Error checking technician-service compatibility: $e');
      return true; // Default to allowing if there's an error
    }
  }

  /// Get all services that a technician can perform
  Future<List<Service>> getCompatibleServices({
    required String technicianId,
    required List<Service> allServices,
  }) async {
    try {
      // Handle "any" technician case
      if (technicianId == 'any') return allServices;
      
      final techId = int.tryParse(technicianId);
      if (techId == null) return allServices;

      final capabilities = await _getTechnicianCapabilities(techId);
      
      final compatibleServices = <Service>[];
      
      for (final service in allServices) {
        final serviceCategory = await _getServiceCategory(service);
        if (capabilities.contains(serviceCategory)) {
          compatibleServices.add(service);
        }
      }
      
      return compatibleServices;
      
    } catch (e) {
      Logger.error('Error getting compatible services: $e');
      return allServices; // Default to all services if there's an error
    }
  }

  /// Get technicians who can perform a specific service
  Future<List<Employee>> getCompatibleTechnicians({
    required Service service,
    required List<Employee> allTechnicians,
  }) async {
    try {
      final serviceCategory = await _getServiceCategory(service);
      final compatibleTechnicians = <Employee>[];
      
      for (final technician in allTechnicians) {
        final capabilities = await _getTechnicianCapabilities(technician.id);
        if (capabilities.contains(serviceCategory)) {
          compatibleTechnicians.add(technician);
        }
      }
      
      return compatibleTechnicians;
      
    } catch (e) {
      Logger.error('Error getting compatible technicians: $e');
      return allTechnicians; // Default to all technicians if there's an error
    }
  }

  /// Check compatibility for multiple services
  Future<ServiceCompatibilityResult> checkMultiServiceCompatibility({
    required String technicianId,
    required List<Service> services,
  }) async {
    if (services.isEmpty) {
      return ServiceCompatibilityResult(
        isFullyCompatible: true,
        compatibleServices: [],
        incompatibleServices: [],
        warningMessage: null,
      );
    }

    final compatibleServices = <Service>[];
    final incompatibleServices = <Service>[];

    for (final service in services) {
      final canPerform = await canTechnicianPerformService(
        technicianId: technicianId,
        service: service,
      );
      
      if (canPerform) {
        compatibleServices.add(service);
      } else {
        incompatibleServices.add(service);
      }
    }

    final isFullyCompatible = incompatibleServices.isEmpty;
    String? warningMessage;

    if (!isFullyCompatible) {
      final technicianName = await _getTechnicianName(technicianId);
      if (incompatibleServices.length == 1) {
        warningMessage = '$technicianName cannot perform ${incompatibleServices.first.name}. '
                        'Consider selecting a different technician or removing this service.';
      } else {
        final serviceNames = incompatibleServices.map((s) => s.name).join(', ');
        warningMessage = '$technicianName cannot perform these services: $serviceNames. '
                        'Consider selecting a different technician or removing these services.';
      }
    }

    return ServiceCompatibilityResult(
      isFullyCompatible: isFullyCompatible,
      compatibleServices: compatibleServices,
      incompatibleServices: incompatibleServices,
      warningMessage: warningMessage,
    );
  }

  /// Get suggested alternative technicians for incompatible services
  Future<List<Employee>> getSuggestedTechnicians({
    required List<Service> incompatibleServices,
    required List<Employee> allTechnicians,
  }) async {
    if (incompatibleServices.isEmpty) return [];

    final suggestions = <Employee>[];
    
    for (final technician in allTechnicians) {
      bool canPerformAll = true;
      
      for (final service in incompatibleServices) {
        final canPerform = await canTechnicianPerformService(
          technicianId: technician.id.toString(),
          service: service,
        );
        
        if (!canPerform) {
          canPerformAll = false;
          break;
        }
      }
      
      if (canPerformAll) {
        suggestions.add(technician);
      }
    }
    
    return suggestions;
  }

  /// Get technician capabilities (service categories they can perform)
  Future<List<String>> _getTechnicianCapabilities(int technicianId) async {
    // Check cache first
    if (_isCacheValid() && _technicianCapabilitiesCache.containsKey(technicianId)) {
      return _technicianCapabilitiesCache[technicianId]!;
    }

    try {
      await _employeeRepository.initialize();
      final database = db.PosDatabase.instance;
      // Join employee_service_categories to service_categories to read category names
      final query = database.select(database.employeeServiceCategories).join([
        innerJoin(
          database.serviceCategories,
          database.serviceCategories.id.equalsExp(database.employeeServiceCategories.categoryId),
        ),
      ])..where(database.employeeServiceCategories.employeeId.equals(technicianId));

      final rows = await query.get();
      final categoryNames = rows
          .map((row) => row.read(database.serviceCategories).name)
          .toList();
      
      // Cache the result
      _technicianCapabilitiesCache[technicianId] = categoryNames;
      _lastCacheUpdate ??= DateTime.now();
      
      return categoryNames;
      
    } catch (e) {
      Logger.error('Error loading technician capabilities for ID $technicianId: $e');
      return ['Nails', 'Gel', 'Acrylic']; // Default capabilities
    }
  }

  /// Get service category name
  Future<String> _getServiceCategory(Service service) async {
    // Check cache first
    if (_isCacheValid() && _serviceCategoryCache.containsKey(service.id)) {
      return _serviceCategoryCache[service.id]!;
    }

    try {
      final database = db.PosDatabase.instance;
      
      if (service.categoryId > 0) {
        final category = await (database.select(database.serviceCategories)
            ..where((tbl) => tbl.id.equals(service.categoryId.toString())))
            .getSingleOrNull();
        
        final categoryName = category?.name ?? 'Other';
        
        // Cache the result
        _serviceCategoryCache[service.id] = categoryName;
        
        return categoryName;
      }
      
      return 'Other';
      
    } catch (e) {
      Logger.error('Error loading service category for ${service.name}: $e');
      return 'Other';
    }
  }

  /// Get technician name for display
  Future<String> _getTechnicianName(String technicianId) async {
    if (technicianId == 'any') return 'Any Technician';
    
    try {
      final techId = int.tryParse(technicianId);
      if (techId == null) return 'Unknown Technician';
      
      await _employeeRepository.initialize();
      final technicians = await _employeeRepository.getEmployees();
      
      final technician = technicians.firstWhere(
        (t) => t.id == techId,
        orElse: () => Employee(
          id: techId,
          firstName: 'Unknown',
          lastName: 'Technician',
          email: '',
          phone: '',
          username: 'unknown',
          role: 'technician',
          locationId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      
      return technician.fullName;
      
    } catch (e) {
      Logger.error('Error getting technician name: $e');
      return 'Unknown Technician';
    }
  }

  /// Check if cache is still valid
  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    final age = DateTime.now().difference(_lastCacheUpdate!);
    return age < _cacheExpiry;
  }

  /// Clear cached data
  void clearCache() {
    _technicianCapabilitiesCache.clear();
    _serviceCategoryCache.clear();
    _lastCacheUpdate = null;
    Logger.info('Technician-Service compatibility cache cleared');
  }
}

/// Result of service compatibility check
class ServiceCompatibilityResult {
  final bool isFullyCompatible;
  final List<Service> compatibleServices;
  final List<Service> incompatibleServices;
  final String? warningMessage;

  const ServiceCompatibilityResult({
    required this.isFullyCompatible,
    required this.compatibleServices,
    required this.incompatibleServices,
    required this.warningMessage,
  });

  @override
  String toString() => 'ServiceCompatibilityResult('
      'isFullyCompatible: $isFullyCompatible, '
      'compatible: ${compatibleServices.length}, '
      'incompatible: ${incompatibleServices.length})';
}
