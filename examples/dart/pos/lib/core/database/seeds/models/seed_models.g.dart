// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceCategorySeed _$ServiceCategorySeedFromJson(Map<String, dynamic> json) =>
    _ServiceCategorySeed(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ServiceCategorySeedToJson(
  _ServiceCategorySeed instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'icon': instance.icon,
  'description': instance.description,
};

_ServiceCategoriesSchema _$ServiceCategoriesSchemaFromJson(
  Map<String, dynamic> json,
) => _ServiceCategoriesSchema(
  schemaVersion: json['schema_version'] as String,
  createdDate: DateTime.parse(json['created_date'] as String),
  description: json['description'] as String,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => ServiceCategorySeed.fromJson(e as Map<String, dynamic>))
      .toList(),
  validation: json['validation'] == null
      ? null
      : ServiceCategoriesValidation.fromJson(
          json['validation'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ServiceCategoriesSchemaToJson(
  _ServiceCategoriesSchema instance,
) => <String, dynamic>{
  'schema_version': instance.schemaVersion,
  'created_date': instance.createdDate.toIso8601String(),
  'description': instance.description,
  'categories': instance.categories,
  'validation': instance.validation,
};

_ServiceSeed _$ServiceSeedFromJson(Map<String, dynamic> json) => _ServiceSeed(
  name: json['name'] as String,
  description: json['description'] as String?,
  categoryId: (json['category_id'] as num).toInt(),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  basePriceCents: (json['base_price_cents'] as num).toInt(),
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ServiceSeedToJson(_ServiceSeed instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category_id': instance.categoryId,
      'duration_minutes': instance.durationMinutes,
      'base_price_cents': instance.basePriceCents,
      'is_active': instance.isActive,
    };

_ServicesSchema _$ServicesSchemaFromJson(Map<String, dynamic> json) =>
    _ServicesSchema(
      schemaVersion: json['schema_version'] as String,
      createdDate: DateTime.parse(json['created_date'] as String),
      description: json['description'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceSeed.fromJson(e as Map<String, dynamic>))
          .toList(),
      validation: json['validation'] == null
          ? null
          : ServicesValidation.fromJson(
              json['validation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ServicesSchemaToJson(_ServicesSchema instance) =>
    <String, dynamic>{
      'schema_version': instance.schemaVersion,
      'created_date': instance.createdDate.toIso8601String(),
      'description': instance.description,
      'services': instance.services,
      'validation': instance.validation,
    };

_ServiceCategoriesValidation _$ServiceCategoriesValidationFromJson(
  Map<String, dynamic> json,
) => _ServiceCategoriesValidation(
  requiredFields: (json['required_fields'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  colorFormat: json['color_format'] as String?,
  nameMaxLength: (json['name_max_length'] as num?)?.toInt(),
  descriptionMaxLength: (json['description_max_length'] as num?)?.toInt(),
  uniqueConstraints: (json['unique_constraints'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ServiceCategoriesValidationToJson(
  _ServiceCategoriesValidation instance,
) => <String, dynamic>{
  'required_fields': instance.requiredFields,
  'color_format': instance.colorFormat,
  'name_max_length': instance.nameMaxLength,
  'description_max_length': instance.descriptionMaxLength,
  'unique_constraints': instance.uniqueConstraints,
};

_ServicesValidation _$ServicesValidationFromJson(Map<String, dynamic> json) =>
    _ServicesValidation(
      requiredFields: (json['required_fields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nameMaxLength: (json['name_max_length'] as num?)?.toInt(),
      descriptionMaxLength: (json['description_max_length'] as num?)?.toInt(),
      durationRange: (json['duration_range'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      priceRange: (json['price_range'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      uniqueConstraints: (json['unique_constraints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      foreignKeys: (json['foreign_keys'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ServicesValidationToJson(_ServicesValidation instance) =>
    <String, dynamic>{
      'required_fields': instance.requiredFields,
      'name_max_length': instance.nameMaxLength,
      'description_max_length': instance.descriptionMaxLength,
      'duration_range': instance.durationRange,
      'price_range': instance.priceRange,
      'unique_constraints': instance.uniqueConstraints,
      'foreign_keys': instance.foreignKeys,
    };

_SeedImportResult _$SeedImportResultFromJson(Map<String, dynamic> json) =>
    _SeedImportResult(
      success: json['success'] as bool,
      message: json['message'] as String,
      itemsProcessed: (json['itemsProcessed'] as num).toInt(),
      itemsImported: (json['itemsImported'] as num).toInt(),
      itemsSkipped: (json['itemsSkipped'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      warnings: (json['warnings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      backupPath: json['backupPath'] as String?,
      importedAt: json['importedAt'] == null
          ? null
          : DateTime.parse(json['importedAt'] as String),
    );

Map<String, dynamic> _$SeedImportResultToJson(_SeedImportResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'itemsProcessed': instance.itemsProcessed,
      'itemsImported': instance.itemsImported,
      'itemsSkipped': instance.itemsSkipped,
      'errors': instance.errors,
      'warnings': instance.warnings,
      'backupPath': instance.backupPath,
      'importedAt': instance.importedAt?.toIso8601String(),
    };

_SeedBackup _$SeedBackupFromJson(Map<String, dynamic> json) => _SeedBackup(
  id: json['id'] as String,
  seedType: json['seedType'] as String,
  version: json['version'] as String,
  filePath: json['filePath'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  itemCount: (json['itemCount'] as num).toInt(),
  description: json['description'] as String?,
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$SeedBackupToJson(_SeedBackup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seedType': instance.seedType,
      'version': instance.version,
      'filePath': instance.filePath,
      'createdAt': instance.createdAt.toIso8601String(),
      'itemCount': instance.itemCount,
      'description': instance.description,
      'createdBy': instance.createdBy,
    };
