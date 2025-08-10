// lib/core/services/lookup_service.dart
// Global lookup service providing fast in-memory access to technician and service mappings. Caches commonly used data to avoid repeated database queries and provides display name formatting.
// Usage: ACTIVE - Initialized in main.dart and used throughout app for technician/service name lookups

import 'package:flutter/material.dart';
import '../config/service_categories.dart';
import '../../features/shared/data/models/service_model.dart';
import '../../features/shared/data/models/employee_model.dart';

/// Global lookup service for fast in-memory access to commonly needed mappings
class LookupService extends ChangeNotifier {
  // Singleton pattern
  static final LookupService _instance = LookupService._internal();
  factory LookupService() => _instance;
  LookupService._internal();
  
  static LookupService get instance => _instance;
  
  // Technician mappings
  final Map<String, String> _technicianIdToName = {};
  final Map<String, String> _technicianIdToDisplayName = {};
  
  // Service mappings
  final Map<String, Service> _serviceIdToService = {};
  final Map<String, String> _serviceIdToCategoryId = {};
  
  // Category mappings are already handled by ServiceCategories class
  // but we can add convenience methods here
  
  /// Update technician data
  void updateTechnicians(List<dynamic> technicians) {
    _technicianIdToName.clear();
    _technicianIdToDisplayName.clear();
    
    for (final tech in technicians) {
      final id = tech.id.toString();
      
      // Handle different technician model types
      if (tech.name != null) {
        _technicianIdToName[id] = tech.name;
      }
      
      if (tech.displayName != null) {
        _technicianIdToDisplayName[id] = tech.displayName;
      } else if (tech.name != null) {
        // Format as "First L." if displayName not available
        _technicianIdToDisplayName[id] = _formatDisplayName(tech.name);
      }
    }
    
    debugPrint('📚 LookupService: Updated ${_technicianIdToName.length} technicians');
    notifyListeners();
  }
  
  /// Update technician from Employee model
  void updateTechniciansFromEmployees(List<Employee> employees) {
    _technicianIdToName.clear();
    _technicianIdToDisplayName.clear();
    
    for (final emp in employees) {
      final id = emp.id.toString();
      final fullName = emp.displayName ?? '${emp.firstName} ${emp.lastName}'.trim();
      
      _technicianIdToName[id] = fullName;
      _technicianIdToDisplayName[id] = _formatDisplayName(fullName);
    }
    
    debugPrint('📚 LookupService: Updated ${_technicianIdToName.length} technicians from employees');
    notifyListeners();
  }
  
  /// Update service data
  void updateServices(List<Service> services) {
    _serviceIdToService.clear();
    _serviceIdToCategoryId.clear();
    
    for (final service in services) {
      final id = service.id.toString();
      _serviceIdToService[id] = service;
      _serviceIdToCategoryId[id] = service.categoryId.toString();
    }
    
    debugPrint('📚 LookupService: Updated ${_serviceIdToService.length} services');
    notifyListeners();
  }
  
  /// Get technician name by ID
  String? getTechnicianName(String? technicianId) {
    if (technicianId == null || technicianId.isEmpty) return null;
    return _technicianIdToName[technicianId];
  }
  
  /// Get technician display name (formatted as "First L.") by ID
  String getTechnicianDisplayName(String? technicianId) {
    if (technicianId == null || technicianId.isEmpty) return 'Any Available';
    
    debugPrint('🔍 LookupService.getTechnicianDisplayName: Looking for ID "$technicianId"');
    debugPrint('   Available IDs: ${_technicianIdToDisplayName.keys.toList()}');
    
    // First try to get the pre-formatted display name
    final displayName = _technicianIdToDisplayName[technicianId];
    if (displayName != null) {
      debugPrint('   ✅ Found display name: $displayName');
      return displayName;
    }
    
    // Fallback to full name
    final fullName = _technicianIdToName[technicianId];
    if (fullName != null) {
      final formatted = _formatDisplayName(fullName);
      debugPrint('   ✅ Found full name, formatted: $formatted');
      return formatted;
    }
    
    // Last resort - return a placeholder
    debugPrint('   ❌ Not found, returning placeholder');
    return 'Technician $technicianId';
  }
  
  /// Get service by ID
  Service? getService(String? serviceId) {
    if (serviceId == null || serviceId.isEmpty) return null;
    return _serviceIdToService[serviceId];
  }
  
  /// Get service category ID by service ID
  String? getServiceCategoryId(String? serviceId) {
    if (serviceId == null || serviceId.isEmpty) return null;
    return _serviceIdToCategoryId[serviceId];
  }
  
  /// Get category color by category ID (convenience method)
  Color getCategoryColor(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return Colors.grey;
    
    // Handle numeric category IDs
    final numId = int.tryParse(categoryId);
    if (numId != null) {
      final color = ServiceCategories.getCategoryColorById(numId);
      if (color != null) return color;
    }
    
    // Try as string key
    final category = ServiceCategories.getCategory(categoryId);
    return category.color;
  }
  
  /// Get category icon by category ID (convenience method)
  IconData? getCategoryIcon(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return Icons.spa;
    
    // Handle numeric category IDs
    final numId = int.tryParse(categoryId);
    if (numId != null) {
      // Map numeric IDs to category keys
      String categoryKey;
      switch (numId) {
        case 1:
          categoryKey = 'nails';
          break;
        case 2:
          categoryKey = 'gel';
          break;
        case 3:
          categoryKey = 'acrylic';
          break;
        case 4:
          categoryKey = 'waxing';
          break;
        case 5:
          categoryKey = 'facials';
          break;
        case 6:
          categoryKey = 'sns';
          break;
        default:
          categoryKey = 'other';
      }
      return ServiceCategories.getCategory(categoryKey).icon;
    }
    
    // Try as string key
    final category = ServiceCategories.getCategory(categoryId);
    return category.icon;
  }
  
  /// Get category display name by category ID (convenience method)
  String getCategoryDisplayName(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return 'General';
    
    // Handle numeric category IDs
    final numId = int.tryParse(categoryId);
    if (numId != null) {
      // Map numeric IDs to category keys
      String categoryKey;
      switch (numId) {
        case 1:
          categoryKey = 'nails';
          break;
        case 2:
          categoryKey = 'gel';
          break;
        case 3:
          categoryKey = 'acrylic';
          break;
        case 4:
          categoryKey = 'waxing';
          break;
        case 5:
          categoryKey = 'facials';
          break;
        case 6:
          categoryKey = 'sns';
          break;
        default:
          categoryKey = 'other';
      }
      return ServiceCategories.getCategory(categoryKey).displayName;
    }
    
    return ServiceCategories.getCategory(categoryId).displayName;
  }
  
  /// Format a full name as "First L."
  String _formatDisplayName(String fullName) {
    if (fullName.isEmpty) return 'Unknown';
    
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      final firstName = parts[0];
      final lastInitial = parts.last[0].toUpperCase();
      return '$firstName $lastInitial.';
    }
    
    return fullName;
  }
  
  /// Clear all cached data
  void clear() {
    _technicianIdToName.clear();
    _technicianIdToDisplayName.clear();
    _serviceIdToService.clear();
    _serviceIdToCategoryId.clear();
    notifyListeners();
  }
  
  /// Debug info
  void printDebugInfo() {
    debugPrint('=== LookupService Debug Info ===');
    debugPrint('Technicians cached: ${_technicianIdToName.length}');
    debugPrint('Services cached: ${_serviceIdToService.length}');
    _technicianIdToDisplayName.forEach((id, name) {
      debugPrint('  Tech $id: $name');
    });
  }
}