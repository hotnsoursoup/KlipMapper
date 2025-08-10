// lib/core/database/seeds/models/seed_models.dart
// Seed data models for type-safe YAML/JSON import with validation and schema versioning
// Usage: ACTIVE - Type definitions for asset-based seed data system

import 'package:freezed_annotation/freezed_annotation.dart';

part 'seed_models.freezed.dart';
part 'seed_models.g.dart';

/// Base interface for all seed schemas
abstract class SeedSchema {
  String get schemaVersion;
  DateTime get createdDate;
  String get description;
}

/// Service Category seed data model
@freezed
class ServiceCategorySeed with _$ServiceCategorySeed {
  const factory ServiceCategorySeed({
    required int id,
    required String name,
    required String color,
    required String icon,
    String? description,
  }) = _ServiceCategorySeed;

  factory ServiceCategorySeed.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategorySeedFromJson(json);
}

/// Service Categories schema container
@freezed
class ServiceCategoriesSchema with _$ServiceCategoriesSchema implements SeedSchema {
  const factory ServiceCategoriesSchema({
    @JsonKey(name: 'schema_version') required String schemaVersion,
    @JsonKey(name: 'created_date') required DateTime createdDate,
    required String description,
    required List<ServiceCategorySeed> categories,
    ServiceCategoriesValidation? validation,
  }) = _ServiceCategoriesSchema;

  factory ServiceCategoriesSchema.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoriesSchemaFromJson(json);
}

/// Service seed data model
@freezed
class ServiceSeed with _$ServiceSeed {
  const factory ServiceSeed({
    required String name,
    String? description,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'base_price_cents') required int basePriceCents,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ServiceSeed;

  factory ServiceSeed.fromJson(Map<String, dynamic> json) =>
      _$ServiceSeedFromJson(json);
}

/// Services schema container
@freezed
class ServicesSchema with _$ServicesSchema implements SeedSchema {
  const factory ServicesSchema({
    @JsonKey(name: 'schema_version') required String schemaVersion,
    @JsonKey(name: 'created_date') required DateTime createdDate,
    required String description,
    required List<ServiceSeed> services,
    ServicesValidation? validation,
  }) = _ServicesSchema;

  factory ServicesSchema.fromJson(Map<String, dynamic> json) =>
      _$ServicesSchemaFromJson(json);
}

/// Validation rules for service categories
@freezed
class ServiceCategoriesValidation with _$ServiceCategoriesValidation {
  const factory ServiceCategoriesValidation({
    @JsonKey(name: 'required_fields') List<String>? requiredFields,
    @JsonKey(name: 'color_format') String? colorFormat,
    @JsonKey(name: 'name_max_length') int? nameMaxLength,
    @JsonKey(name: 'description_max_length') int? descriptionMaxLength,
    @JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints,
  }) = _ServiceCategoriesValidation;

  factory ServiceCategoriesValidation.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoriesValidationFromJson(json);
}

/// Validation rules for services
@freezed
class ServicesValidation with _$ServicesValidation {
  const factory ServicesValidation({
    @JsonKey(name: 'required_fields') List<String>? requiredFields,
    @JsonKey(name: 'name_max_length') int? nameMaxLength,
    @JsonKey(name: 'description_max_length') int? descriptionMaxLength,
    @JsonKey(name: 'duration_range') List<int>? durationRange,
    @JsonKey(name: 'price_range') List<int>? priceRange,
    @JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints,
    @JsonKey(name: 'foreign_keys') Map<String, String>? foreignKeys,
  }) = _ServicesValidation;

  factory ServicesValidation.fromJson(Map<String, dynamic> json) =>
      _$ServicesValidationFromJson(json);
}

/// Seed import result with validation feedback
@freezed
class SeedImportResult with _$SeedImportResult {
  const factory SeedImportResult({
    required bool success,
    required String message,
    required int itemsProcessed,
    required int itemsImported,
    required int itemsSkipped,
    required List<String> errors,
    required List<String> warnings,
    String? backupPath,
    DateTime? importedAt,
  }) = _SeedImportResult;

  factory SeedImportResult.fromJson(Map<String, dynamic> json) =>
      _$SeedImportResultFromJson(json);
}

/// Seed backup metadata
@freezed
class SeedBackup with _$SeedBackup {
  const factory SeedBackup({
    required String id,
    required String seedType,
    required String version,
    required String filePath,
    required DateTime createdAt,
    required int itemCount,
    String? description,
    String? createdBy,
  }) = _SeedBackup;

  factory SeedBackup.fromJson(Map<String, dynamic> json) =>
      _$SeedBackupFromJson(json);
}