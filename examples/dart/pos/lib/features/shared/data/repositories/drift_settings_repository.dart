// lib/features/shared/data/repositories/drift_settings_repository.dart
// Comprehensive settings management repository handling typed setting storage, bulk operations, and reactive streams.
// Provides type-safe setting operations with category organization, migration support, and convenience methods for common settings.
// Usage: ACTIVE - Primary repository for all application configuration and user preferences

import 'dart:convert' as dart_convert;
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/database.dart' as db;
import '../models/setting_model.dart' as models;
import '../../../../utils/error_logger.dart';

/// Repository for managing application settings using Drift database
class DriftSettingsRepository {
  // Singleton pattern
  static final DriftSettingsRepository _instance = DriftSettingsRepository._internal();
  static DriftSettingsRepository get instance => _instance;
  
  DriftSettingsRepository._internal();
  
  // Database instance management
  db.PosDatabase? _database;
  bool _initialized = false;
  
  /// Initialize the repository with database connection
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftSettingsRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftSettingsRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Get a setting by key with type safety
  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    try {
      await initialize();
      
      final setting = await (_database!.select(_database!.settings)
        ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
      
      if (setting == null) return defaultValue;
      
      final storeSetting = models.StoreSetting.fromDrift(setting);
      return storeSetting.getTypedValue<T>() ?? defaultValue;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting setting for key: $key', e, stack);
      return defaultValue;
    }
  }

  /// Set a setting value
  Future<void> setSetting(String key, dynamic value, {String? category}) async {
    try {
      await initialize();
      
      final now = DateTime.now();
      final storeSetting = models.StoreSetting.createTyped(
        key: key,
        value: value,
        category: category,
      );
      
      await _database!.into(_database!.settings).insertOnConflictUpdate(
        db.SettingsCompanion(
          key: drift.Value(key),
          value: drift.Value(storeSetting.value),
          category: drift.Value(category),
          dataType: drift.Value(storeSetting.dataType),
          updatedAt: drift.Value(now),
        ),
      );
      
      ErrorLogger.logInfo('Setting updated: $key = $value');
    } catch (e, stack) {
      ErrorLogger.logError('Error setting value for key: $key', e, stack);
      rethrow;
    }
  }

  /// Get all settings by category
  Future<Map<String, dynamic>> getSettingsByCategory(String category) async {
    try {
      await initialize();
      
      final settings = await (_database!.select(_database!.settings)
        ..where((s) => s.category.equals(category)))
        .get();
      
      final Map<String, dynamic> result = {};
      for (var setting in settings) {
        final storeSetting = models.StoreSetting.fromDrift(setting);
        result[setting.key] = storeSetting.getTypedValue();
      }
      
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting settings for category: $category', e, stack);
      return {};
    }
  }

  /// Get all settings as StoreSetting models by category
  Future<List<models.StoreSetting>> getSettingsModelsByCategory(String category) async {
    try {
      await initialize();
      
      final settings = await (_database!.select(_database!.settings)
        ..where((s) => s.category.equals(category))
        ..orderBy([(s) => drift.OrderingTerm.asc(s.key)]))
        .get();
      
      return settings.map((s) => models.StoreSetting.fromDrift(s)).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error getting setting models for category: $category', e, stack);
      return [];
    }
  }

  /// Set multiple settings at once (bulk operation)
  Future<void> setSettingsBulk(Map<String, dynamic> settings, {String? category}) async {
    try {
      await initialize();
      
      await _database!.transaction(() async {
        for (final entry in settings.entries) {
          await setSetting(entry.key, entry.value, category: category);
        }
      });
      
      ErrorLogger.logInfo('Bulk settings updated: ${settings.length} settings');
    } catch (e, stack) {
      ErrorLogger.logError('Error setting bulk settings', e, stack);
      rethrow;
    }
  }

  /// Get all settings (for export/backup)
  Future<Map<String, dynamic>> getAllSettings() async {
    try {
      await initialize();
      
      final settings = await _database!.select(_database!.settings).get();
      
      final Map<String, dynamic> result = {};
      for (var setting in settings) {
        final storeSetting = models.StoreSetting.fromDrift(setting);
        result[setting.key] = {
          'value': storeSetting.getTypedValue(),
          'category': setting.category,
          'dataType': setting.dataType,
          'description': setting.description,
          'isSystem': storeSetting.isSystem,
        };
      }
      
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting all settings', e, stack);
      return {};
    }
  }

  /// Reset settings for a category to defaults
  Future<void> resetCategoryToDefaults(String category) async {
    try {
      await initialize();
      
      // Delete current settings for the category
      await (_database!.delete(_database!.settings)
        ..where((s) => s.category.equals(category) & s.isSystem.equals(0)))
        .go();
      
      // Re-insert defaults (this would need to be implemented based on your default values)
      // For now, we'll just log that the reset happened
      ErrorLogger.logInfo('Settings reset for category: $category');
    } catch (e, stack) {
      ErrorLogger.logError('Error resetting settings for category: $category', e, stack);
      rethrow;
    }
  }

  /// Watch settings changes for a category (reactive)
  Stream<Map<String, dynamic>> watchSettingsByCategory(String category) {
    try {
      return (_database!.select(_database!.settings)
        ..where((s) => s.category.equals(category)))
        .watch()
        .map((settings) {
          final Map<String, dynamic> result = {};
          for (var setting in settings) {
            final storeSetting = models.StoreSetting.fromDrift(setting);
            result[setting.key] = storeSetting.getTypedValue();
          }
          return result;
        });
    } catch (e, stack) {
      ErrorLogger.logError('Error watching settings for category: $category', e, stack);
      return Stream.value({});
    }
  }

  /// Check if a setting exists
  Future<bool> settingExists(String key) async {
    try {
      await initialize();
      
      final setting = await (_database!.select(_database!.settings)
        ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
      
      return setting != null;
    } catch (e, stack) {
      ErrorLogger.logError('Error checking if setting exists: $key', e, stack);
      return false;
    }
  }

  /// Delete a setting
  Future<void> deleteSetting(String key) async {
    try {
      await initialize();
      
      await (_database!.delete(_database!.settings)
        ..where((s) => s.key.equals(key)))
        .go();
      
      ErrorLogger.logInfo('Setting deleted: $key');
    } catch (e, stack) {
      ErrorLogger.logError('Error deleting setting: $key', e, stack);
      rethrow;
    }
  }

  /// Import settings from a backup
  Future<void> importSettings(Map<String, dynamic> settingsData) async {
    try {
      await initialize();
      
      await _database!.transaction(() async {
        for (final entry in settingsData.entries) {
          final key = entry.key;
          final data = entry.value as Map<String, dynamic>;
          
          await setSetting(
            key,
            data['value'],
            category: data['category'],
          );
        }
      });
      
      ErrorLogger.logInfo('Settings imported: ${settingsData.length} settings');
    } catch (e, stack) {
      ErrorLogger.logError('Error importing settings', e, stack);
      rethrow;
    }
  }

  /// Convenience methods for common settings

  // Dashboard settings
  Future<bool> getDashboardShowCustomerPhone() async {
    return await getSetting<bool>(models.SettingKeys.dashboardShowCustomerPhone, defaultValue: true) ?? true;
  }

  Future<void> setDashboardShowCustomerPhone(bool value) async {
    await setSetting(models.SettingKeys.dashboardShowCustomerPhone, value, category: models.SettingCategories.dashboard);
  }

  Future<bool> getDashboardEnableCheckoutNotifications() async {
    return await getSetting<bool>(models.SettingKeys.dashboardEnableCheckoutNotifications, defaultValue: true) ?? true;
  }

  Future<void> setDashboardEnableCheckoutNotifications(bool value) async {
    await setSetting(models.SettingKeys.dashboardEnableCheckoutNotifications, value, category: models.SettingCategories.dashboard);
  }

  Future<String> getDashboardServiceDisplayMode() async {
    return await getSetting<String>(models.SettingKeys.dashboardServiceDisplayMode, defaultValue: 'Pills') ?? 'Pills';
  }

  Future<void> setDashboardServiceDisplayMode(String value) async {
    await setSetting(models.SettingKeys.dashboardServiceDisplayMode, value, category: models.SettingCategories.dashboard);
  }

  // Store settings
  Future<models.StoreHours> getStoreHoursConfiguration() async {
    try {
      final jsonString = await getSetting<String>(models.SettingKeys.storeHoursConfiguration, defaultValue: '');
      if (jsonString == null || jsonString.isEmpty) {
        return models.StoreHours.defaultHours();
      }
      
      final Map<String, dynamic> json = dart_convert.jsonDecode(jsonString);
      
      // Check if we need to migrate from old string format to numeric format
      json['hours'] = _migrateHoursFormat(json['hours'] as Map<String, dynamic>?);
      
      return models.StoreHours.fromJson(json);
    } catch (e, stack) {
      ErrorLogger.logError('Error parsing store hours configuration', e, stack);
      // Log the actual JSON string for debugging
      final debugJson = await getSetting<String>(models.SettingKeys.storeHoursConfiguration, defaultValue: '');
      ErrorLogger.logError('Store hours JSON: $debugJson', null);
      return models.StoreHours.defaultHours();
    }
  }

  /// Migrates store hours from old string format ("9:00 AM") to new numeric format (minutes since midnight)
  Map<String, dynamic> _migrateHoursFormat(Map<String, dynamic>? hoursJson) {
    if (hoursJson == null) return {};
    
    final migratedHours = <String, dynamic>{};
    
    for (final entry in hoursJson.entries) {
      final dayHours = entry.value as Map<String, dynamic>?;
      if (dayHours == null) continue;
      
      final migratedDayHours = <String, dynamic>{
        'isOpen': dayHours['isOpen'] ?? false,
      };
      
      // Check if openTime and closeTime are strings (old format) and convert to minutes
      final openTime = dayHours['openTime'];
      final closeTime = dayHours['closeTime'];
      
      if (openTime is String && openTime.isNotEmpty) {
        migratedDayHours['openTime'] = models.DayHours.displayToMinutes(openTime);
      } else if (openTime is num) {
        migratedDayHours['openTime'] = openTime.toInt();
      }
      
      if (closeTime is String && closeTime.isNotEmpty) {
        migratedDayHours['closeTime'] = models.DayHours.displayToMinutes(closeTime);
      } else if (closeTime is num) {
        migratedDayHours['closeTime'] = closeTime.toInt();
      }
      
      migratedHours[entry.key] = migratedDayHours;
    }
    
    return migratedHours;
  }

  Future<void> setStoreHoursConfiguration(models.StoreHours storeHours) async {
    try {
      // Use the model's toJson which properly serializes the data
      final jsonString = dart_convert.jsonEncode(storeHours.toJson());
      await setSetting(models.SettingKeys.storeHoursConfiguration, jsonString, category: models.SettingCategories.store);
    } catch (e) {
      ErrorLogger.logError('Error saving store hours configuration', e, StackTrace.current);
      rethrow;
    }
  }

  Future<bool> getStoreOnlineBooking() async {
    return await getSetting<bool>(models.SettingKeys.storeOnlineBooking, defaultValue: false) ?? false;
  }

  Future<void> setStoreOnlineBooking(bool value) async {
    await setSetting(models.SettingKeys.storeOnlineBooking, value, category: models.SettingCategories.store);
  }

  // General settings
  Future<String> getGeneralTheme() async {
    return await getSetting<String>(models.SettingKeys.generalTheme, defaultValue: 'light') ?? 'light';
  }

  Future<void> setGeneralTheme(String value) async {
    await setSetting(models.SettingKeys.generalTheme, value, category: models.SettingCategories.general);
  }

  Future<bool> getGeneralSoundEffects() async {
    return await getSetting<bool>(models.SettingKeys.generalSoundEffects, defaultValue: true) ?? true;
  }

  Future<void> setGeneralSoundEffects(bool value) async {
    await setSetting(models.SettingKeys.generalSoundEffects, value, category: models.SettingCategories.general);
  }

  Future<bool> getGeneralAnimations() async {
    return await getSetting<bool>(models.SettingKeys.generalAnimations, defaultValue: true) ?? true;
  }

  Future<void> setGeneralAnimations(bool value) async {
    await setSetting(models.SettingKeys.generalAnimations, value, category: models.SettingCategories.general);
  }

  Future<String> getGeneralLanguage() async {
    return await getSetting<String>(models.SettingKeys.generalLanguage, defaultValue: 'en') ?? 'en';
  }

  Future<void> setGeneralLanguage(String value) async {
    await setSetting(models.SettingKeys.generalLanguage, value, category: models.SettingCategories.general);
  }

  Future<void> setGeneralDefaultItemsPerPage(int value) async {
    await setSetting(models.SettingKeys.generalDefaultItemsPerPage, value, category: models.SettingCategories.general);
  }
}
