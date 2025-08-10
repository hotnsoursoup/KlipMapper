// lib/features/shared/domain/models/service_category_domain.dart
// Immutable domain model for service categories with business logic methods and UI helper functions.
// Provides color conversion, icon mapping, search functionality, and update tracking for service categories.
// Usage: ACTIVE - Core domain model used throughout the application for service categorization

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_category_domain.freezed.dart';
part 'service_category_domain.g.dart';

/// Immutable domain model for service categories
/// 
/// This model is completely decoupled from database implementation details.
/// It represents a service category as understood by the business logic layer.
@freezed
abstract class ServiceCategoryDomain with _$ServiceCategoryDomain {
  /// Private constructor to enable custom methods
  const ServiceCategoryDomain._();

  /// Primary constructor for ServiceCategory domain model
  const factory ServiceCategoryDomain({
    required String id,
    required String name,
    @Default('#6B7280') String colorHex,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ServiceCategoryDomain;

  /// JSON serialization support
  factory ServiceCategoryDomain.fromJson(Map<String, dynamic> json) => 
      _$ServiceCategoryDomainFromJson(json);

  /// Convert hex color to Flutter Color object
  Color get color {
    try {
      if (colorHex.startsWith('#')) {
        final colorInt = int.parse(colorHex.substring(1), radix: 16);
        return Color(colorInt | 0xFF000000);
      }
      return const Color(0xFF6B7280); // Default gray
    } catch (e) {
      return const Color(0xFF6B7280); // Default gray on error
    }
  }

  /// Get appropriate icon for the category based on name
  IconData get icon {
    final nameLower = name.toLowerCase();
    
    if (nameLower.contains('nail')) return Icons.colorize;
    if (nameLower.contains('gel')) return Icons.water_drop;
    if (nameLower.contains('acrylic')) return Icons.architecture;
    if (nameLower.contains('wax')) return Icons.spa;
    if (nameLower.contains('facial')) return Icons.face;
    if (nameLower.contains('sns') || nameLower.contains('dip')) return Icons.layers;
    if (nameLower.contains('massage')) return Icons.healing;
    if (nameLower.contains('hair')) return Icons.content_cut;
    if (nameLower.contains('makeup')) return Icons.brush;
    if (nameLower.contains('brow') || nameLower.contains('lash')) return Icons.remove_red_eye;
    
    return Icons.star; // Default icon
  }

  /// Check if category name matches search query
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    return name.toLowerCase().contains(query.toLowerCase());
  }

  /// Create a copy with updated timestamp
  ServiceCategoryDomain markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }
}