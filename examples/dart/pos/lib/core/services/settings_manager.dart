// lib/core/services/settings_manager.dart
// Global settings manager that loads and caches all application settings in memory for fast access. Initialized before app startup to ensure settings are available throughout the app lifecycle.
// Usage: ACTIVE - Initialized in main.dart and used throughout app for dashboard, store, and general settings

import '../../features/shared/data/repositories/drift_settings_repository.dart';
import '../../features/shared/data/models/setting_model.dart';
import '../../utils/error_logger.dart';
import 'settings_service.dart';

/// Global settings manager that loads and caches all settings in memory
/// This is initialized before the app starts to ensure settings are available
/// before the first render
class SettingsManager {
  static SettingsManager? _instance;
  static SettingsManager get instance => _instance ??= SettingsManager._();

  SettingsManager._();

  // Cached settings
  final Map<String, dynamic> _cachedSettings = {};
  bool _isInitialized = false;

  // Dashboard settings
  bool get showCustomerPhone => _cachedSettings['showCustomerPhone'] ?? true;
  bool get enableCheckoutNotifications => _cachedSettings['enableCheckoutNotifications'] ?? true;
  String get serviceDisplayMode => _cachedSettings['serviceDisplayMode'] ?? 'Pills';
  bool get showTodaysSchedule => false; // Forced to false until feature is complete
  bool get showUpcomingAppointments => _cachedSettings['showUpcomingAppointments'] ?? true;
  bool get isTimelineExpanded => _cachedSettings['isTimelineExpanded'] ?? false;
  String get dashboardFontSize => _cachedSettings['dashboardFontSize'] ?? 'medium';
  String get statusQueueLayout => _cachedSettings['statusQueueLayout'] ?? 'grid2';
  
  // Background settings
  String get dashboardBackground => _cachedSettings['dashboardBackground'] ?? 'none';
  double get backgroundOpacity => _cachedSettings['backgroundOpacity'] ?? 1.0;
  double get containerOpacity => _cachedSettings['containerOpacity'] ?? 0.65;
  double get widgetOpacity => _cachedSettings['widgetOpacity'] ?? 0.7;

  // Store settings
  StoreHours get storeHours => _cachedSettings['storeHours'] ?? StoreHours.defaultHours();
  bool get enableOnlineBooking => _cachedSettings['enableOnlineBooking'] ?? false;

  // General settings
  String get theme => _cachedSettings['theme'] ?? 'light';
  bool get enableSounds => _cachedSettings['enableSounds'] ?? true;
  bool get enableAnimations => _cachedSettings['enableAnimations'] ?? true;
  String get language => _cachedSettings['language'] ?? 'en';

  // Pagination settings
  int get defaultItemsPerPage => _cachedSettings['defaultItemsPerPage'] ?? 25;

  // Check if settings are initialized
  bool get isInitialized => _isInitialized;

  /// Initialize settings manager by loading all settings into memory
  /// This should be called before runApp()
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      ErrorLogger.logInfo('Initializing SettingsManager...');

      // Initialize repositories
      final driftSettingsRepo = DriftSettingsRepository.instance;
      await driftSettingsRepo.initialize();

      // Initialize legacy settings service
      await SettingsService.instance.initialize();

      // Load all settings into cache
      await _loadAllSettings();

      _isInitialized = true;
      ErrorLogger.logInfo('SettingsManager initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to initialize SettingsManager', e, stack);
      // Use default values if initialization fails
      _isInitialized = true;
    }
  }

  /// Load all settings from repositories into memory cache
  Future<void> _loadAllSettings() async {
    final driftSettingsRepo = DriftSettingsRepository.instance;
    final legacySettings = SettingsService.instance;

    try {
      // Load dashboard settings from drift
      _cachedSettings['showCustomerPhone'] = await driftSettingsRepo.getDashboardShowCustomerPhone();
      _cachedSettings['enableCheckoutNotifications'] = await driftSettingsRepo.getDashboardEnableCheckoutNotifications();
      _cachedSettings['serviceDisplayMode'] = await driftSettingsRepo.getDashboardServiceDisplayMode();

      // Load background settings from drift
      _cachedSettings['dashboardBackground'] = await driftSettingsRepo.getSetting<String>('dashboard_background', defaultValue: 'none') ?? 'none';
      _cachedSettings['backgroundOpacity'] = await driftSettingsRepo.getSetting<double>('dashboard_background_opacity', defaultValue: 1.0) ?? 1.0;
      _cachedSettings['containerOpacity'] = await driftSettingsRepo.getSetting<double>('dashboard_container_opacity', defaultValue: 0.65) ?? 0.65;
      _cachedSettings['widgetOpacity'] = await driftSettingsRepo.getSetting<double>('dashboard_widget_opacity', defaultValue: 0.7) ?? 0.7;

      // Load dashboard settings from legacy service
      _cachedSettings['showTodaysSchedule'] = legacySettings.getShowTodaysSchedule();
      _cachedSettings['showUpcomingAppointments'] = legacySettings.getShowUpcomingAppointments();
      _cachedSettings['isTimelineExpanded'] = legacySettings.getIsTimelineExpanded();
      _cachedSettings['dashboardFontSize'] = legacySettings.getFontSize();
      _cachedSettings['statusQueueLayout'] = legacySettings.getStatusQueueLayout();

      // Load store settings
      _cachedSettings['storeHours'] = await driftSettingsRepo.getStoreHoursConfiguration();
      _cachedSettings['enableOnlineBooking'] = await driftSettingsRepo.getStoreOnlineBooking();

      // Load general settings
      _cachedSettings['theme'] = await driftSettingsRepo.getGeneralTheme();
      _cachedSettings['enableSounds'] = await driftSettingsRepo.getGeneralSoundEffects();
      _cachedSettings['enableAnimations'] = await driftSettingsRepo.getGeneralAnimations();
      _cachedSettings['language'] = await driftSettingsRepo.getGeneralLanguage();

      ErrorLogger.logInfo('All settings loaded into cache');
    } catch (e, stack) {
      ErrorLogger.logError('Error loading settings into cache', e, stack);
    }
  }

  /// Update a setting in cache and persist it
  Future<void> updateSetting(String key, dynamic value) async {
    _cachedSettings[key] = value;

    // Persist the change based on the setting type
    try {
      final driftSettingsRepo = DriftSettingsRepository.instance;
      final legacySettings = SettingsService.instance;

      switch (key) {
        // Dashboard settings (drift)
        case 'showCustomerPhone':
          await driftSettingsRepo.setDashboardShowCustomerPhone(value as bool);
          break;
        case 'enableCheckoutNotifications':
          await driftSettingsRepo.setDashboardEnableCheckoutNotifications(value as bool);
          break;

        // Background settings (drift)
        case 'dashboardBackground':
          await driftSettingsRepo.setSetting('dashboard_background', value);
          break;
        case 'backgroundOpacity':
          await driftSettingsRepo.setSetting('dashboard_background_opacity', value);
          break;
        case 'containerOpacity':
          await driftSettingsRepo.setSetting('dashboard_container_opacity', value);
          break;
        case 'widgetOpacity':
          await driftSettingsRepo.setSetting('dashboard_widget_opacity', value);
          break;

        // Dashboard settings (legacy)
        case 'showTodaysSchedule':
          await legacySettings.setShowTodaysSchedule(value as bool);
          break;
        case 'showUpcomingAppointments':
          await legacySettings.setShowUpcomingAppointments(value as bool);
          break;
        case 'isTimelineExpanded':
          await legacySettings.setIsTimelineExpanded(value as bool);
          break;
        case 'dashboardFontSize':
          await legacySettings.setFontSize(value as String);
          break;
        case 'statusQueueLayout':
          await legacySettings.setStatusQueueLayout(value as String);
          break;

        // Store settings
        case 'storeHours':
          await driftSettingsRepo.setStoreHoursConfiguration(value as StoreHours);
          break;
        case 'enableOnlineBooking':
          await driftSettingsRepo.setStoreOnlineBooking(value as bool);
          break;

        // General settings
        case 'theme':
          await driftSettingsRepo.setGeneralTheme(value as String);
          break;
        case 'enableSounds':
          await driftSettingsRepo.setGeneralSoundEffects(value as bool);
          break;
        case 'enableAnimations':
          await driftSettingsRepo.setGeneralAnimations(value as bool);
          break;
        case 'language':
          await driftSettingsRepo.setGeneralLanguage(value as String);
          break;
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error persisting setting $key', e, stack);
    }
  }

  /// Reload all settings from storage
  Future<void> reload() async {
    await _loadAllSettings();
  }

  /// Get all cached settings as a map
  Map<String, dynamic> getAllSettings() => Map.from(_cachedSettings);

  /// Clear all cached settings (useful for testing)
  void clearCache() {
    _cachedSettings.clear();
    _isInitialized = false;
  }
}