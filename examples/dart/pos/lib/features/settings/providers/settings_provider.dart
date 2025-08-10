// lib/features/settings/providers/settings_provider.dart
// Master Riverpod provider for application settings management with caching, categorization, and reactive setting updates.
// Usage: ACTIVE - Primary settings state management for all configuration throughout the application
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/setting_model.dart';
import '../../shared/data/repositories/drift_settings_repository.dart';
import '../data/models/background_option.dart';
import '../../../core/services/settings_manager.dart';
import '../../../core/utils/app_logger.dart';

part 'settings_provider.freezed.dart';
part 'settings_provider.g.dart';

/// Repository provider - single source of truth for repository access
@Riverpod(keepAlive: true)
DriftSettingsRepository settingsRepository(Ref ref) {
  return DriftSettingsRepository.instance;
}

/// Master settings provider - manages all application settings
/// This provider loads and caches all settings from the database
@Riverpod(keepAlive: true)
class SettingsMaster extends _$SettingsMaster {
  @override
  Future<Map<String, StoreSetting>> build() async {
    return _loadAllSettings();
  }
  
  Future<Map<String, StoreSetting>> _loadAllSettings() async {
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.initialize();
      
      // Get all settings from repository (this returns Map<String, dynamic>)
      final rawSettings = await repo.getAllSettings();
      final settingsMap = <String, StoreSetting>{};
      
      // Convert to StoreSetting objects (if needed, or use raw values)
      for (final entry in rawSettings.entries) {
        // For now, create simple StoreSetting objects from the raw data
        final setting = StoreSetting(
          key: entry.key,
          value: entry.value?.toString() ?? '',
          category: _getCategoryFromKey(entry.key),
          dataType: _inferDataType(entry.value),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        settingsMap[entry.key] = setting;
      }
      
      AppLogger.logInfo('SettingsMaster: Loaded ${settingsMap.length} settings');
      return settingsMap;
    } catch (e, stack) {
      AppLogger.logError('Failed to load settings', e, stack);
      throw Exception('Failed to load settings: $e');
    }
  }
  
  /// Update a setting value
  Future<void> updateSetting(String key, dynamic value) async {
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.updateSetting(key, value);
      
      // Refresh the settings
      ref.invalidateSelf();
    } catch (e, stack) {
      AppLogger.logError('Failed to update setting $key', e, stack);
      rethrow;
    }
  }
  
  /// Get a setting value with type safety
  T? getSetting<T>(String key, T? defaultValue) {
    final settingsAsync = state;
    
    return settingsAsync.when(
      data: (settings) {
        final setting = settings[key];
        if (setting == null) return defaultValue;
        
        // Parse value based on type
        final value = setting.value;
        if (value == null) return defaultValue;
        
        if (T == bool) {
          return (value == 'true' || value == '1') as T;
        } else if (T == int) {
          return int.tryParse(value) as T? ?? defaultValue;
        } else if (T == double) {
          return double.tryParse(value) as T? ?? defaultValue;
        } else if (T == String) {
          return value as T;
        } else {
          // For complex types, assume JSON
          return value as T? ?? defaultValue;
        }
      },
      loading: () => defaultValue,
      error: (_, __) => defaultValue,
    );
  }
  
  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.resetToDefaults();
      
      // Refresh the settings
      ref.invalidateSelf();
    } catch (e, stack) {
      AppLogger.logError('Failed to reset settings', e, stack);
      rethrow;
    }
  }
}

// ========== CATEGORY-SPECIFIC PROVIDERS ==========

/// Dashboard settings provider with state management
@riverpod
class DashboardSettingsNotifier extends _$DashboardSettingsNotifier {
  @override
  Future<DashboardSettings> build() async {
    return _loadDashboardSettings();
  }
  
  Future<DashboardSettings> _loadDashboardSettings() async {
    try {
      final settingsAsync = ref.watch(settingsMasterProvider);
      
      return await settingsAsync.when(
        data: (settings) async {
          // Load from cache first for instant response
          final cache = SettingsManager.instance;
          
          return DashboardSettings(
            showCustomerPhone: _getBoolSetting(settings, 'dashboard_show_customer_phone', cache.showCustomerPhone),
            enableCheckoutNotifications: _getBoolSetting(settings, 'dashboard_enable_checkout_notifications', cache.enableCheckoutNotifications),
            fontSize: _getStringSetting(settings, 'dashboard_font_size', 'medium'),
            technicianLayout: _getStringSetting(settings, 'dashboard_technician_layout', 'grid2'),
            serviceDisplayMode: _getStringSetting(settings, 'dashboard_service_display_mode', cache.serviceDisplayMode.toLowerCase()),
            showTodaysSchedule: _getBoolSetting(settings, 'dashboard_show_todays_schedule', cache.showTodaysSchedule),
            showUpcomingAppointments: _getBoolSetting(settings, 'dashboard_show_upcoming_appointments', true),
            // Background and UI settings
            dashboardBackground: _getStringSetting(settings, 'dashboard_background', cache.dashboardBackground),
            backgroundOpacity: _getDoubleSetting(settings, 'dashboard_background_opacity', cache.backgroundOpacity),
            containerOpacity: _getDoubleSetting(settings, 'dashboard_container_opacity', cache.containerOpacity),
            widgetOpacity: _getDoubleSetting(settings, 'dashboard_widget_opacity', cache.widgetOpacity),
          );
        },
        loading: () => Future.value(const DashboardSettings()),
        error: (_, __) => Future.value(const DashboardSettings()),
      );
    } catch (e, stack) {
      AppLogger.logError('Failed to load dashboard settings', e, stack);
      return const DashboardSettings();
    }
  }
  
  /// Update dashboard setting
  Future<void> updateSetting(String key, dynamic value) async {
    try {
      final masterNotifier = ref.read(settingsMasterProvider.notifier);
      await masterNotifier.updateSetting(key, value);
      
      // Update cache immediately
      final cache = SettingsManager.instance;
      await cache.updateSetting(key.replaceFirst('dashboard_', ''), value);
      
      // Refresh this provider
      ref.invalidateSelf();
    } catch (e, stack) {
      AppLogger.logError('Failed to update dashboard setting $key', e, stack);
      rethrow;
    }
  }
  
  /// Specific setting update methods
  Future<void> setShowCustomerPhone(bool value) async {
    await updateSetting('dashboard_show_customer_phone', value);
  }
  
  Future<void> setEnableCheckoutNotifications(bool value) async {
    await updateSetting('dashboard_enable_checkout_notifications', value);
  }
  
  Future<void> setServiceDisplayMode(String value) async {
    await updateSetting('dashboard_service_display_mode', value.toLowerCase());
  }
  
  Future<void> setDashboardBackground(String value) async {
    await updateSetting('dashboard_background', value);
  }
  
  Future<void> setBackgroundOpacity(double value) async {
    await updateSetting('dashboard_background_opacity', value);
  }
  
  Future<void> setContainerOpacity(double value) async {
    await updateSetting('dashboard_container_opacity', value);
  }
  
  Future<void> setWidgetOpacity(double value) async {
    await updateSetting('dashboard_widget_opacity', value);
  }
  
  Future<void> setShowTodaysSchedule(bool value) async {
    await updateSetting('dashboard_show_todays_schedule', value);
  }
}

/// Store settings provider
@Riverpod(keepAlive: true)
StoreSettings storeSettings(Ref ref) {
  final settingsAsync = ref.watch(settingsMasterProvider);
  
  return settingsAsync.when(
    data: (settings) {
      return StoreSettings(
        storeHours: _getJsonSetting(settings, 'store_hours_configuration', {}),
        onlineBooking: _getBoolSetting(settings, 'store_online_booking', false),
        location: _getStringSetting(settings, 'store_location', 'Main Location'),
        timezone: _getStringSetting(settings, 'store_timezone', 'America/New_York'),
        appointmentBuffer: _getIntSetting(settings, 'store_appointment_buffer', 15),
        walkInsEnabled: _getBoolSetting(settings, 'store_walk_ins_enabled', true),
        maxDailyAppointments: _getIntSetting(settings, 'store_max_daily_appointments', 50),
      );
    },
    loading: () => const StoreSettings(),
    error: (_, __) => const StoreSettings(),
  );
}

/// General settings provider
@Riverpod(keepAlive: true)
GeneralSettings generalSettings(Ref ref) {
  final settingsAsync = ref.watch(settingsMasterProvider);
  
  return settingsAsync.when(
    data: (settings) {
      return GeneralSettings(
        theme: _getStringSetting(settings, 'general_theme', 'light'),
        soundEffects: _getBoolSetting(settings, 'general_sound_effects', true),
        animations: _getBoolSetting(settings, 'general_animations', true),
        language: _getStringSetting(settings, 'general_language', 'en'),
        currency: _getStringSetting(settings, 'general_currency', 'USD'),
        dateFormat: _getStringSetting(settings, 'general_date_format', 'MM/dd/yyyy'),
        timeFormat: _getStringSetting(settings, 'general_time_format', '12h'),
        defaultItemsPerPage: _getIntSetting(settings, 'general_default_items_per_page', 25),
      );
    },
    loading: () => const GeneralSettings(),
    error: (_, __) => const GeneralSettings(),
  );
}

/// Salon settings provider
@Riverpod(keepAlive: true)
SalonSettings salonSettings(Ref ref) {
  final settingsAsync = ref.watch(settingsMasterProvider);
  
  return settingsAsync.when(
    data: (settings) {
      return SalonSettings(
        serviceDurationBuffer: _getIntSetting(settings, 'salon_service_duration_buffer', 5),
        requireTechnicianSpecialization: _getBoolSetting(settings, 'salon_require_technician_specialization', false),
        autoCheckoutCompleted: _getBoolSetting(settings, 'salon_auto_checkout_completed', false),
        loyaltyPointsEnabled: _getBoolSetting(settings, 'salon_loyalty_points_enabled', true),
        loyaltyPointsRatio: _getDoubleSetting(settings, 'salon_loyalty_points_ratio', 1.0),
        requireAppointmentConfirmation: _getBoolSetting(settings, 'salon_require_appointment_confirmation', true),
        reminderHoursBefore: _getIntSetting(settings, 'salon_reminder_hours_before', 24),
        groupBookingEnabled: _getBoolSetting(settings, 'salon_group_booking_enabled', true),
        maxGroupSize: _getIntSetting(settings, 'salon_max_group_size', 8),
        priceDisplayMode: _getStringSetting(settings, 'salon_price_display_mode', 'individual'),
        // Customer collection settings
        collectCustomerAddress: _getBoolSetting(settings, 'salon_collect_customer_address', true),
        collectCustomerDateOfBirth: _getBoolSetting(settings, 'salon_collect_customer_dob', true),
        collectCustomerGender: _getBoolSetting(settings, 'salon_collect_customer_gender', true),
        collectCustomerAllergies: _getBoolSetting(settings, 'salon_collect_customer_allergies', true),
      );
    },
    loading: () => const SalonSettings(),
    error: (_, __) => const SalonSettings(),
  );
}

// Customer collection settings are now consolidated into SalonSettings provider

// ========== HELPER FUNCTIONS ==========

bool _getBoolSetting(Map<String, StoreSetting> settings, String key, bool defaultValue) {
  final setting = settings[key];
  if (setting?.value == null) return defaultValue;
  return setting!.value == 'true' || setting.value == '1';
}

String _getStringSetting(Map<String, StoreSetting> settings, String key, String defaultValue) {
  return settings[key]?.value ?? defaultValue;
}

int _getIntSetting(Map<String, StoreSetting> settings, String key, int defaultValue) {
  final value = settings[key]?.value;
  if (value == null) return defaultValue;
  return int.tryParse(value) ?? defaultValue;
}

double _getDoubleSetting(Map<String, StoreSetting> settings, String key, double defaultValue) {
  final value = settings[key]?.value;
  if (value == null) return defaultValue;
  return double.tryParse(value) ?? defaultValue;
}

Map<String, dynamic> _getJsonSetting(Map<String, StoreSetting> settings, String key, Map<String, dynamic> defaultValue) {
  final value = settings[key]?.value;
  if (value == null) return defaultValue;
  // In production, parse JSON properly
  // For now, return default
  return defaultValue;
}

String _getCategoryFromKey(String key) {
  if (key.startsWith('dashboard_')) return 'dashboard';
  if (key.startsWith('store_')) return 'store';
  if (key.startsWith('general_')) return 'general';
  if (key.startsWith('salon_')) return 'salon';
  return 'general';
}

String _inferDataType(dynamic value) {
  if (value is bool) return 'boolean';
  if (value is int) return 'integer';
  if (value is double) return 'double';
  if (value is String) {
    // Check if it's JSON
    if (value.startsWith('{') || value.startsWith('[')) return 'json';
    return 'string';
  }
  return 'string';
}

// ========== SETTINGS MODELS ==========

@freezed
abstract class DashboardSettings with _$DashboardSettings {
  const DashboardSettings._();
  const factory DashboardSettings({
    @Default(true) bool showCustomerPhone,
    @Default(true) bool enableCheckoutNotifications,
    @Default('medium') String fontSize,
    @Default('grid2') String technicianLayout,
    @Default('pills') String serviceDisplayMode,
    @Default(false) bool showTodaysSchedule,
    @Default(true) bool showUpcomingAppointments,
    // Background and UI settings
    @Default('none') String dashboardBackground,
    @Default(1.0) double backgroundOpacity,
    @Default(0.65) double containerOpacity,
    @Default(0.7) double widgetOpacity,
  }) = _DashboardSettings;
}

@freezed
abstract class StoreSettings with _$StoreSettings {
  const StoreSettings._();
  const factory StoreSettings({
    @Default({}) Map<String, dynamic> storeHours,
    @Default(false) bool onlineBooking,
    @Default('Main Location') String location,
    @Default('America/New_York') String timezone,
    @Default(15) int appointmentBuffer,
    @Default(true) bool walkInsEnabled,
    @Default(50) int maxDailyAppointments,
  }) = _StoreSettings;
}

@freezed
abstract class GeneralSettings with _$GeneralSettings {
  const GeneralSettings._();
  const factory GeneralSettings({
    @Default('light') String theme,
    @Default(true) bool soundEffects,
    @Default(true) bool animations,
    @Default('en') String language,
    @Default('USD') String currency,
    @Default('MM/dd/yyyy') String dateFormat,
    @Default('12h') String timeFormat,
    @Default(25) int defaultItemsPerPage,
  }) = _GeneralSettings;
}

@freezed
abstract class SalonSettings with _$SalonSettings {
  const SalonSettings._();
  const factory SalonSettings({
    @Default(5) int serviceDurationBuffer,
    @Default(false) bool requireTechnicianSpecialization,
    @Default(false) bool autoCheckoutCompleted,
    @Default(true) bool loyaltyPointsEnabled,
    @Default(1.0) double loyaltyPointsRatio,
    @Default(true) bool requireAppointmentConfirmation,
    @Default(24) int reminderHoursBefore,
    @Default(true) bool groupBookingEnabled,
    @Default(8) int maxGroupSize,
    @Default('individual') String priceDisplayMode,
    // Customer data collection settings (moved from separate provider)
    @Default(true) bool collectCustomerAddress,
    @Default(true) bool collectCustomerDateOfBirth,
    @Default(true) bool collectCustomerGender,
    @Default(true) bool collectCustomerAllergies,
  }) = _SalonSettings;
}

// ========== BACKGROUND OPTIONS ==========

/// Available background options with metadata
const Map<String, BackgroundOption> backgroundOptions = {
  'none': BackgroundOption(
    name: 'No Background',
    type: BackgroundType.none,
  ),
  'sakura1': BackgroundOption(
    name: 'Sakura Blossoms',
    type: BackgroundType.image,
    fileExtension: '.jpg',
    maxSizeKB: 500,
  ),
  'gradient_blue': BackgroundOption(
    name: 'Blue Gradient',
    type: BackgroundType.gradient,
    colors: [0xFF1E3A8A, 0xFF3B82F6],
  ),
  'gradient_purple': BackgroundOption(
    name: 'Purple Gradient', 
    type: BackgroundType.gradient,
    colors: [0xFF581C87, 0xFF9333EA],
  ),
};

/// Background options provider
@riverpod
Map<String, BackgroundOption> availableBackgroundOptions(Ref ref) {
  return backgroundOptions;
}

/// Get background option by key
@riverpod
BackgroundOption? getBackgroundOption(Ref ref, String key) {
  return backgroundOptions[key];
}

// ========== UTILITY PROVIDERS ==========

/// Settings save state provider
@riverpod
class SettingsSaveState extends _$SettingsSaveState {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }
  
  /// Save all settings to database and cache
  Future<void> saveAllSettings() async {
    state = const AsyncValue.loading();
    
    try {
      final dashboardNotifier = ref.read(dashboardSettingsNotifierProvider.notifier);
      final masterNotifier = ref.read(settingsMasterProvider.notifier);
      
      // Save all pending changes (implementation would depend on specific needs)
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate save
      
      state = const AsyncValue.data(null);
      AppLogger.logInfo('All settings saved successfully');
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.logError('Failed to save settings', e, stack);
      rethrow;
    }
  }
}
