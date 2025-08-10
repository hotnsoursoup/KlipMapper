// lib/core/database/seeds/seed_importer.dart
// Comprehensive seed import system with type validation, backup creation, and rollback capabilities
// Usage: ACTIVE - Main interface for importing seed data from YAML/JSON assets

import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:drift/drift.dart';

import '../database.dart';
import 'models/seed_models.dart';
import 'validators/seed_validator.dart';
import 'managers/seed_backup_manager.dart';
import '../../utils/logger.dart';

/// Main seed import service with validation and backup capabilities
class SeedImporter {
  final PosDatabase _database;
  
  SeedImporter(this._database);

  /// Import service categories from YAML asset
  Future<SeedImportResult> importServiceCategories({
    String assetPath = 'assets/seeds/service_categories.yaml',
    bool createBackup = true,
    String? importedBy,
  }) async {
    try {
      Logger.info('Starting service categories import from $assetPath');
      
      // Load and parse YAML
      final yamlContent = await rootBundle.loadString(assetPath);
      final yamlMap = loadYaml(yamlContent) as Map;
      final jsonMap = _yamlToJson(yamlMap);
      
      // Parse schema
      final schema = ServiceCategoriesSchema.fromJson(jsonMap);
      
      // Validate schema version
      final versionResult = SchemaValidator.validateVersion(schema.schemaVersion);
      if (!versionResult.isValid) {
        return SeedImportResult(
          success: false,
          message: 'Schema validation failed',
          itemsProcessed: 0,
          itemsImported: 0,
          itemsSkipped: 0,
          errors: versionResult.errors,
          warnings: versionResult.warnings,
        );
      }
      
      // Create backup if requested
      SeedBackup? backup;
      if (createBackup) {
        final currentData = await _getCurrentServiceCategories();
        backup = await SeedBackupManager.createBackup(
          seedType: 'service_categories',
          currentData: currentData,
          description: 'Pre-import backup for ${schema.description}',
          createdBy: importedBy,
        );
      }
      
      // Validate each category
      final validationErrors = <String>[];
      final validationWarnings = <String>[];
      final validCategories = <ServiceCategorySeed>[];
      
      for (final category in schema.categories) {
        final result = ServiceCategoryValidator.validateCategory(category, schema.validation);
        if (result.isValid) {
          validCategories.add(category);
        } else {
          validationErrors.addAll(result.errors.map((e) => '${category.name}: $e'));
        }
        validationWarnings.addAll(result.warnings.map((w) => '${category.name}: $w'));
      }
      
      // Validate collection constraints
      final collectionResult = ServiceCategoryValidator.validateUniqueness(validCategories, schema.validation);
      validationErrors.addAll(collectionResult.errors);
      validationWarnings.addAll(collectionResult.warnings);
      
      if (validationErrors.isNotEmpty) {
        return SeedImportResult(
          success: false,
          message: 'Validation failed',
          itemsProcessed: schema.categories.length,
          itemsImported: 0,
          itemsSkipped: 0,
          errors: validationErrors,
          warnings: validationWarnings,
          backupPath: backup?.filePath,
        );
      }
      
      // Import data
      final importResult = await _importServiceCategoriesData(validCategories);
      
      return SeedImportResult(
        success: true,
        message: 'Service categories imported successfully',
        itemsProcessed: schema.categories.length,
        itemsImported: importResult.imported,
        itemsSkipped: importResult.skipped,
        errors: [],
        warnings: validationWarnings,
        backupPath: backup?.filePath,
        importedAt: DateTime.now(),
      );
      
    } catch (e) {
      Logger.error('Failed to import service categories', e);
      return SeedImportResult(
        success: false,
        message: 'Import failed: $e',
        itemsProcessed: 0,
        itemsImported: 0,
        itemsSkipped: 0,
        errors: [e.toString()],
        warnings: [],
      );
    }
  }

  /// Import services from YAML asset
  Future<SeedImportResult> importServices({
    String assetPath = 'assets/seeds/services.yaml',
    bool createBackup = true,
    String? importedBy,
  }) async {
    try {
      Logger.info('Starting services import from $assetPath');
      
      // Load and parse YAML
      final yamlContent = await rootBundle.loadString(assetPath);
      final yamlMap = loadYaml(yamlContent) as Map;
      final jsonMap = _yamlToJson(yamlMap);
      
      // Parse schema
      final schema = ServicesSchema.fromJson(jsonMap);
      
      // Validate schema version
      final versionResult = SchemaValidator.validateVersion(schema.schemaVersion);
      if (!versionResult.isValid) {
        return SeedImportResult(
          success: false,
          message: 'Schema validation failed',
          itemsProcessed: 0,
          itemsImported: 0,
          itemsSkipped: 0,
          errors: versionResult.errors,
          warnings: versionResult.warnings,
        );
      }
      
      // Get current categories for validation
      final currentCategories = await _getCurrentServiceCategoriesForValidation();
      
      // Create backup if requested
      SeedBackup? backup;
      if (createBackup) {
        final currentData = await _getCurrentServices();
        backup = await SeedBackupManager.createBackup(
          seedType: 'services',
          currentData: currentData,
          description: 'Pre-import backup for ${schema.description}',
          createdBy: importedBy,
        );
      }
      
      // Validate each service
      final validationErrors = <String>[];
      final validationWarnings = <String>[];
      final validServices = <ServiceSeed>[];
      
      for (final service in schema.services) {
        final result = ServiceValidator.validateService(service, schema.validation);
        if (result.isValid) {
          validServices.add(service);
        } else {
          validationErrors.addAll(result.errors.map((e) => '${service.name}: $e'));
        }
        validationWarnings.addAll(result.warnings.map((w) => '${service.name}: $w'));
      }
      
      // Validate collection constraints
      final collectionResult = ServiceValidator.validateCollection(validServices, schema.validation, currentCategories);
      validationErrors.addAll(collectionResult.errors);
      validationWarnings.addAll(collectionResult.warnings);
      
      if (validationErrors.isNotEmpty) {
        return SeedImportResult(
          success: false,
          message: 'Validation failed',
          itemsProcessed: schema.services.length,
          itemsImported: 0,
          itemsSkipped: 0,
          errors: validationErrors,
          warnings: validationWarnings,
          backupPath: backup?.filePath,
        );
      }
      
      // Import data
      final importResult = await _importServicesData(validServices);
      
      return SeedImportResult(
        success: true,
        message: 'Services imported successfully',
        itemsProcessed: schema.services.length,
        itemsImported: importResult.imported,
        itemsSkipped: importResult.skipped,
        errors: [],
        warnings: validationWarnings,
        backupPath: backup?.filePath,
        importedAt: DateTime.now(),
      );
      
    } catch (e) {
      Logger.error('Failed to import services', e);
      return SeedImportResult(
        success: false,
        message: 'Import failed: $e',
        itemsProcessed: 0,
        itemsImported: 0,
        itemsSkipped: 0,
        errors: [e.toString()],
        warnings: [],
      );
    }
  }

  /// Rollback to a previous backup
  Future<SeedImportResult> rollbackToBackup(String backupId) async {
    try {
      Logger.info('Starting rollback to backup: $backupId');
      
      // Validate backup integrity
      final isValid = await SeedBackupManager.validateBackupIntegrity(backupId);
      if (!isValid) {
        return SeedImportResult(
          success: false,
          message: 'Backup integrity check failed',
          itemsProcessed: 0,
          itemsImported: 0,
          itemsSkipped: 0,
          errors: ['Backup data is corrupted or modified'],
          warnings: [],
        );
      }
      
      // Restore backup data
      final backupData = await SeedBackupManager.restoreFromBackup(backupId);
      
      // Determine backup type and restore accordingly
      var totalImported = 0;
      var totalProcessed = 0;
      
      if (backupData.containsKey('categories')) {
        final categories = (backupData['categories'] as List)
            .map((json) => ServiceCategorySeed.fromJson(json))
            .toList();
        final result = await _importServiceCategoriesData(categories);
        totalImported += result.imported;
        totalProcessed += categories.length;
      }
      
      if (backupData.containsKey('services')) {
        final services = (backupData['services'] as List)
            .map((json) => ServiceSeed.fromJson(json))
            .toList();
        final result = await _importServicesData(services);
        totalImported += result.imported;
        totalProcessed += services.length;
      }
      
      return SeedImportResult(
        success: true,
        message: 'Successfully rolled back to backup $backupId',
        itemsProcessed: totalProcessed,
        itemsImported: totalImported,
        itemsSkipped: 0,
        errors: [],
        warnings: [],
        importedAt: DateTime.now(),
      );
      
    } catch (e) {
      Logger.error('Rollback failed', e);
      return SeedImportResult(
        success: false,
        message: 'Rollback failed: $e',
        itemsProcessed: 0,
        itemsImported: 0,
        itemsSkipped: 0,
        errors: [e.toString()],
        warnings: [],
      );
    }
  }

  /// Import service categories data into database
  Future<({int imported, int skipped})> _importServiceCategoriesData(List<ServiceCategorySeed> categories) async {
    var imported = 0;
    var skipped = 0;
    
    await _database.transaction(() async {
      // Clear existing categories (or use upsert logic)
      await _database.delete(_database.serviceCategories).go();
      
      for (final category in categories) {
        try {
          await _database.into(_database.serviceCategories).insert(
            ServiceCategoriesCompanion.insert(
              id: Value(category.id),
              name: category.name,
              color: Value(category.color),
              icon: Value(category.icon),
            ),
            mode: InsertMode.insertOrReplace,
          );
          imported++;
        } catch (e) {
          Logger.error('Failed to import category: ${category.name}', e);
          skipped++;
        }
      }
    });
    
    return (imported: imported, skipped: skipped);
  }

  /// Import services data into database
  Future<({int imported, int skipped})> _importServicesData(List<ServiceSeed> services) async {
    var imported = 0;
    var skipped = 0;
    
    await _database.transaction(() async {
      // Clear existing services (or use upsert logic)
      await _database.delete(_database.services).go();
      
      for (final service in services) {
        try {
          await _database.into(_database.services).insert(
            ServicesCompanion.insert(
              name: service.name,
              description: Value(service.description),
              categoryId: service.categoryId,
              durationMinutes: service.durationMinutes,
              basePriceCents: service.basePriceCents,
              isActive: Value(service.isActive),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrReplace,
          );
          imported++;
        } catch (e) {
          Logger.error('Failed to import service: ${service.name}', e);
          skipped++;
        }
      }
    });
    
    return (imported: imported, skipped: skipped);
  }

  /// Get current service categories for backup
  Future<Map<String, dynamic>> _getCurrentServiceCategories() async {
    final categories = await _database.select(_database.serviceCategories).get();
    return {
      'categories': categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'color': c.color,
        'icon': c.icon,
      }).toList(),
    };
  }

  /// Get current service categories for validation
  Future<List<ServiceCategorySeed>> _getCurrentServiceCategoriesForValidation() async {
    final categories = await _database.select(_database.serviceCategories).get();
    return categories.map((c) => ServiceCategorySeed(
      id: c.id,
      name: c.name,
      color: c.color ?? '',
      icon: c.icon ?? '',
      description: null,
    )).toList();
  }

  /// Get current services for backup
  Future<Map<String, dynamic>> _getCurrentServices() async {
    final services = await _database.select(_database.services).get();
    return {
      'services': services.map((s) => {
        'name': s.name,
        'description': s.description,
        'category_id': s.categoryId,
        'duration_minutes': s.durationMinutes,
        'base_price_cents': s.basePriceCents,
        'is_active': s.isActive,
      }).toList(),
    };
  }

  /// Convert YAML to JSON-compatible map
  dynamic _yamlToJson(dynamic yamlData) {
    if (yamlData is Map) {
      final map = <String, dynamic>{};
      for (final entry in yamlData.entries) {
        map[entry.key.toString()] = _yamlToJson(entry.value);
      }
      return map;
    } else if (yamlData is List) {
      return yamlData.map(_yamlToJson).toList();
    } else {
      return yamlData;
    }
  }
}