// lib/features/shared/data/models/service_model.dart
// Service data model representing individual services with pricing, duration, and category relationships.
// Usage: ACTIVE - Core service data model used throughout service management and booking systems
import '../repositories/drift_service_repository.dart';

/// Service model representing a single service
class Service {
  final String id;
  final String name;
  final String description;
  final int categoryId;  // Changed to int to match database schema and domain model
  final double basePrice;  // Renamed from price for consistency
  final int durationMinutes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? technicianId;  // Changed from technicianName to technicianId

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.basePrice,
    required this.durationMinutes,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.technicianId,
  });

  // Factory constructors
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as int,
      basePrice: (json['basePrice'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      technicianId: json['technicianId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'basePrice': basePrice,
      'durationMinutes': durationMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (technicianId != null) 'technicianId': technicianId,
    };
  }
  
  // Helper method to get category name
  String getCategoryName() {
    return DriftServiceRepository.getCategoryName(categoryId);
  }

  // Compatibility getters for old code  
  double get price => basePrice;
  String get categoryIdString => categoryId.toString();  // For backward compatibility with String categoryId
}
