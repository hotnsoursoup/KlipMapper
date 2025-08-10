// lib/core/config/service_categories.dart
// Central configuration for service categories with visual properties, colors, and icons. Manages category display settings and provides default color mappings for service categorization.
// Usage: ACTIVE - Used throughout app for service category display and color theming

import 'package:flutter/material.dart';

/// Central configuration for service categories and their visual properties
class ServiceCategoryConfig {
  final String id;
  final String displayName;
  final Color color;
  final IconData? icon;

  const ServiceCategoryConfig({
    required this.id,
    required this.displayName,
    required this.color,
    this.icon,
  });
}

/// Service category configurations loaded from database
class ServiceCategories {
  static Map<String, ServiceCategoryConfig> _categories = {};
  
  // Default colors if not set in database
  static const Map<String, Color> _defaultColors = {
    'nails': Color(0xFF2196F3), // Blue
    'gel': Color(0xFF03A9F4), // Light blue
    'acrylic': Color(0xFF9C27B0), // Purple
    'waxing': Color(0xFF4CAF50), // Green
    'facials': Color(0xFFFFC107), // Amber
    'sns': Color(0xFFFF9800), // Orange
    'massage': Color(0xFF673AB7), // Deep purple
    'hair': Color(0xFFF44336), // Red
    'other': Color(0xFF9E9E9E), // Grey
  };
  
  // Default icons for categories
  static const Map<String, IconData> _categoryIcons = {
    'nails': Icons.pan_tool,
    'gel': Icons.brush,
    'acrylic': Icons.format_paint,
    'waxing': Icons.spa,
    'facials': Icons.face,
    'sns': Icons.layers,
    'massage': Icons.self_improvement,
    'hair': Icons.content_cut,
    'other': Icons.more_horiz,
  };

  /// Get configuration for a category
  static ServiceCategoryConfig getCategory(String categoryId) {
    // Ensure categories are initialized
    if (_categories.isEmpty) {
      _initializeDefaults();
    }
    
    // Try to get the specific category or fall back to 'other'
    return _categories[categoryId.toLowerCase()] ?? 
           _categories['other'] ??
           ServiceCategoryConfig(
             id: 'other',
             displayName: 'Other',
             color: _defaultColors['other'] ?? const Color(0xFF9E9E9E),
             icon: Icons.more_horiz,
           );
  }

  /// Get color for a category
  static Color getCategoryColor(String categoryId) {
    return getCategory(categoryId).color;
  }
  
  /// Get color for a category by numeric ID
  static Color? getCategoryColorById(int categoryId) {
    // Map numeric IDs to category names
    final Map<int, String> idToCategoryMap = {
      1: 'nails',
      2: 'gel',
      3: 'acrylic',
      4: 'waxing',
      5: 'facials',
      6: 'sns',
      7: 'massage',
      8: 'hair',
    };
    
    final categoryName = idToCategoryMap[categoryId];
    if (categoryName != null && _categories.containsKey(categoryName)) {
      return _categories[categoryName]!.color;
    }
    return null;
  }

  /// Get all available categories
  static List<ServiceCategoryConfig> getAllCategories() {
    return _categories.values.toList();
  }

  /// Initialize categories - for now use defaults, database loading will be handled by stores
  static Future<void> initialize() async {
    _initializeDefaults();
  }
  
  /// Initialize with default values
  static void _initializeDefaults() {
    _categories.clear();
    _defaultColors.forEach((key, color) {
      _categories[key] = ServiceCategoryConfig(
        id: key,
        displayName: key[0].toUpperCase() + key.substring(1),
        color: color,
        icon: _categoryIcons[key] ?? Icons.more_horiz,
      );
    });
  }
  
  /// Update category color (called when user changes color in settings)
  static void updateCategoryColor(String categoryId, Color color) {
    final existing = _categories[categoryId.toLowerCase()];
    if (existing != null) {
      _categories[categoryId.toLowerCase()] = ServiceCategoryConfig(
        id: existing.id,
        displayName: existing.displayName,
        color: color,
        icon: existing.icon,
      );
    }
  }
  
  /// Load categories from database data
  static void loadFromDatabase(List<Map<String, dynamic>> dbCategories) {
    _categories.clear();
    
    for (final row in dbCategories) {
      final id = row['id']?.toString() ?? '';
      final name = row['name']?.toString() ?? '';
      final colorHex = row['color']?.toString();
      final iconName = row['icon']?.toString();
      
      // Parse color from hex string or use default
      Color color;
      if (colorHex != null && colorHex.startsWith('#')) {
        try {
          final hex = colorHex.substring(1);
          color = Color(int.parse('0xFF$hex'));
        } catch (e) {
          // Use default color if parsing fails
          color = _defaultColors[name.toLowerCase()] ?? _defaultColors['other']!;
        }
      } else {
        // Use default color if not set
        color = _defaultColors[name.toLowerCase()] ?? _defaultColors['other']!;
      }
      
      // Get icon from database or use default
      IconData icon;
      if (iconName != null && iconName.isNotEmpty) {
        // Try to map the icon name to an IconData
        icon = _getIconFromName(iconName) ?? _categoryIcons[name.toLowerCase()] ?? _categoryIcons['other']!;
      } else {
        // Use default icon for category
        icon = _categoryIcons[name.toLowerCase()] ?? _categoryIcons['other']!;
      }
      
      // Map database names to the keys used by ServicePill
      String categoryKey;
      switch (name.toLowerCase()) {
        case 'mani-pedi':
          categoryKey = 'nails';
          break;
        case 'gel nails':
          categoryKey = 'gel';
          break;
        case 'acrylics':
          categoryKey = 'acrylic';
          break;
        case 'waxing':
          categoryKey = 'waxing';
          break;
        case 'facial':
          categoryKey = 'facials';
          break;
        case 'sns':
          categoryKey = 'sns';
          break;
        default:
          categoryKey = name.toLowerCase();
      }
      
      // Create config with proper key
      _categories[categoryKey] = ServiceCategoryConfig(
        id: id,
        displayName: name,
        color: color,
        icon: icon,
      );
    }
    
    // Add default 'other' category if not present
    if (!_categories.containsKey('other')) {
      _categories['other'] = ServiceCategoryConfig(
        id: 'other',
        displayName: 'Other',
        color: _defaultColors['other']!,
        icon: _categoryIcons['other']!,
      );
    }
  }
  
  /// Map icon name string to IconData
  static IconData? _getIconFromName(String iconName) {
    // Map common icon names to Material Icons
    switch (iconName) {
      case 'pan_tool':
        return Icons.pan_tool;
      case 'brush':
        return Icons.brush;
      case 'format_paint':
        return Icons.format_paint;
      case 'spa':
        return Icons.spa;
      case 'face':
        return Icons.face;
      case 'layers':
        return Icons.layers;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'content_cut':
        return Icons.content_cut;
      case 'more_horiz':
        return Icons.more_horiz;
      case 'colorize':
        return Icons.colorize;
      case 'water_drop':
        return Icons.water_drop;
      case 'architecture':
        return Icons.architecture;
      case 'healing':
        return Icons.healing;
      case 'star':
        return Icons.star;
      default:
        return null;
    }
  }
}