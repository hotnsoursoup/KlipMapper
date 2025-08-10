// lib/features/shared/domain/models/service_domain.dart
// Immutable domain model for services with business logic methods for formatting and manipulation.
// Provides duration/price formatting, search functionality, and immutable update methods for service data.
// Usage: ACTIVE - Core domain model used throughout the application for service management

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_domain.freezed.dart';
part 'service_domain.g.dart';

/// Immutable domain model for services
/// 
/// This model is completely decoupled from database implementation details.
/// It represents a service as understood by the business logic layer.
@freezed
abstract class ServiceDomain with _$ServiceDomain {
  /// Private constructor to enable custom methods
  const ServiceDomain._();

  /// Primary constructor for Service domain model
  const factory ServiceDomain({
    required String id,
    required String name,
    required String description,
    required int durationMinutes,
    required double basePrice,
    required int categoryId,  // Changed to int to match database schema
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ServiceDomain;

  /// JSON serialization support
  factory ServiceDomain.fromJson(Map<String, dynamic> json) => 
      _$ServiceDomainFromJson(json);

  /// Format duration as human-readable string
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}min';
    }
    
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    }
    
    return '${hours}h ${minutes}min';
  }

  /// Format price as currency string
  String get formattedPrice {
    return '\$${basePrice.toStringAsFixed(2)}';
  }

  /// Check if service matches search query
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final queryLower = query.toLowerCase();
    return name.toLowerCase().contains(queryLower) ||
           description.toLowerCase().contains(queryLower);
  }

  /// Create a copy with updated timestamp
  ServiceDomain markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Create a copy with new price
  ServiceDomain withPrice(double newPrice) {
    return copyWith(
      basePrice: newPrice,
      updatedAt: DateTime.now(),
    );
  }

  /// Create a copy with new duration
  ServiceDomain withDuration(int newDurationMinutes) {
    return copyWith(
      durationMinutes: newDurationMinutes,
      updatedAt: DateTime.now(),
    );
  }
}