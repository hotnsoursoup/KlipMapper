// lib/features/shared/data/models/setting_model.dart
// Store settings model with Freezed for app configuration, store hours, and typed value handling.
// Includes comprehensive settings categories, Drift integration, and predefined setting keys for type safety.
// Usage: ACTIVE - Core application settings management, store configuration, and user preferences

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/drift_database.dart' as db;
import 'package:drift/drift.dart' as drift;

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

/// Store settings model for POS application configuration
@freezed
class StoreSetting with _$StoreSetting {
  const factory StoreSetting({
    required String key,
    required String value,
    String? category,
    String? dataType,
    String? description,
    @Default(false) bool isSystem,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StoreSetting;

  factory StoreSetting.fromJson(Map<String, dynamic> json) =>
      _$StoreSettingFromJson(json);

  const StoreSetting._();

  /// Convert from Drift database object
  factory StoreSetting.fromDrift(db.Setting driftSetting) {
    return StoreSetting(
      key: driftSetting.key,
      value: driftSetting.value,
      category: driftSetting.category,
      dataType: driftSetting.dataType,
      description: driftSetting.description,
      isSystem: (driftSetting.isSystem ?? 0) == 1,
      createdAt: driftSetting.createdAt != null
          ? DateTime.tryParse(driftSetting.createdAt!) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: driftSetting.updatedAt != null
          ? DateTime.tryParse(driftSetting.updatedAt!) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert to Drift database format
  db.SettingsCompanion toDrift() {
    return db.SettingsCompanion(
      key: drift.Value(key),
      value: drift.Value(value),
      category: drift.Value(category),
      dataType: drift.Value(dataType),
      description: drift.Value(description),
      isSystem: drift.Value(isSystem ? 1 : 0),
      createdAt: drift.Value(createdAt.toIso8601String()),
      updatedAt: drift.Value(updatedAt.toIso8601String()),
    );
  }

  /// Get the typed value based on dataType
  T? getTypedValue<T>() {
    try {
      switch (dataType?.toLowerCase()) {
        case 'boolean':
          final boolValue = value.toLowerCase() == 'true';
          return boolValue as T?;
        case 'integer':
          final intValue = int.tryParse(value);
          return intValue as T?;
        case 'double':
          final doubleValue = double.tryParse(value);
          return doubleValue as T?;
        case 'string':
        default:
          return value as T?;
      }
    } catch (e) {
      return null;
    }
  }

  /// Get boolean value
  bool get boolValue => getTypedValue<bool>() ?? false;

  /// Get integer value
  int get intValue => getTypedValue<int>() ?? 0;

  /// Get double value
  double get doubleValue => getTypedValue<double>() ?? 0.0;

  /// Get string value
  String get stringValue => value;

  /// Create a setting with typed value
  static StoreSetting createTyped({
    required String key,
    required dynamic value,
    String? category,
    String? description,
    bool isSystem = false,
  }) {
    String dataType;
    String stringValue;

    if (value is bool) {
      dataType = 'boolean';
      stringValue = value.toString();
    } else if (value is int) {
      dataType = 'integer';
      stringValue = value.toString();
    } else if (value is double) {
      dataType = 'double';
      stringValue = value.toString();
    } else {
      dataType = 'string';
      stringValue = value.toString();
    }

    final now = DateTime.now();
    return StoreSetting(
      key: key,
      value: stringValue,
      category: category,
      dataType: dataType,
      description: description,
      isSystem: isSystem,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Update the setting with a new value
  StoreSetting updateValue(dynamic newValue) {
    String stringValue;
    
    if (newValue is bool) {
      stringValue = newValue.toString();
    } else if (newValue is int) {
      stringValue = newValue.toString();
    } else if (newValue is double) {
      stringValue = newValue.toString();
    } else {
      stringValue = newValue.toString();
    }

    return copyWith(
      value: stringValue,
      updatedAt: DateTime.now(),
    );
  }
}

/// Store hours configuration for each day of the week
@freezed
class StoreHours with _$StoreHours {
  const factory StoreHours({
    @Default({}) Map<String, DayHours> hours,
  }) = _StoreHours;

  factory StoreHours.fromJson(Map<String, dynamic> json) =>
      _$StoreHoursFromJson(json);

  const StoreHours._();

  /// Create default store hours (9 AM - 6 PM, Monday-Saturday, closed Sunday)
  factory StoreHours.defaultHours() {
    return StoreHours(
      hours: {
        'monday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080),    // 9:00 AM - 6:00 PM
        'tuesday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080),   // 9:00 AM - 6:00 PM
        'wednesday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080), // 9:00 AM - 6:00 PM
        'thursday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080),  // 9:00 AM - 6:00 PM
        'friday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080),    // 9:00 AM - 6:00 PM
        'saturday': const DayHours(isOpen: true, openTime: 540, closeTime: 1080),  // 9:00 AM - 6:00 PM
        'sunday': const DayHours(),
      },
    );
  }

  /// Get summary text for display
  String getSummary() {
    final openDays = hours.entries.where((e) => e.value.isOpen).toList();
    if (openDays.isEmpty) return 'Closed all days';
    
    if (openDays.length == 7) {
      final sampleHours = openDays.first.value;
      final allSameHours = openDays.every((e) => 
        e.value.openTime == sampleHours.openTime && 
        e.value.closeTime == sampleHours.closeTime,);
      
      if (allSameHours && sampleHours.openTimeDisplay != null && sampleHours.closeTimeDisplay != null) {
        return 'Daily: ${sampleHours.openTimeDisplay} - ${sampleHours.closeTimeDisplay}';
      }
    }
    
    return '${openDays.length} days open with varying hours';
  }
}

/// Hours configuration for a single day
@freezed
class DayHours with _$DayHours {
  const factory DayHours({
    @Default(false) bool isOpen,
    int? openTime,  // Minutes since midnight (e.g., 390 = 6:30 AM)
    int? closeTime, // Minutes since midnight (e.g., 1080 = 6:00 PM)
  }) = _DayHours;

  factory DayHours.fromJson(Map<String, dynamic> json) =>
      _$DayHoursFromJson(json);

  const DayHours._();

  /// Convert minutes since midnight to display format (e.g., "6:30 AM")
  static String minutesToDisplay(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHour = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '$displayHour:${mins.toString().padLeft(2, '0')} $period';
  }

  /// Convert display format (e.g., "6:30 PM") to minutes since midnight
  static int displayToMinutes(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    var hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';
    
    if (hours == 12 && !isPM) {
      hours = 0; // 12:00 AM = 0:00
    } else if (hours != 12 && isPM) {
      hours += 12; // Convert PM hours
    }
    
    return hours * 60 + minutes;
  }

  /// Get display strings for the times
  String? get openTimeDisplay => openTime != null ? minutesToDisplay(openTime!) : null;
  String? get closeTimeDisplay => closeTime != null ? minutesToDisplay(closeTime!) : null;

  /// Create from display time strings
  factory DayHours.fromDisplayTimes({
    required bool isOpen,
    String? openTime,
    String? closeTime,
  }) {
    return DayHours(
      isOpen: isOpen,
      openTime: openTime != null ? displayToMinutes(openTime) : null,
      closeTime: closeTime != null ? displayToMinutes(closeTime) : null,
    );
  }
}

/// Predefined setting categories
class SettingCategories {
  static const String dashboard = 'dashboard';
  static const String store = 'store';
  static const String general = 'general';
  static const String salon = 'salon';

  static const List<String> all = [
    dashboard,
    store,
    general,
    salon,
  ];
}

/// Predefined setting keys for type safety
class SettingKeys {
  // Dashboard
  static const String dashboardShowCustomerPhone = 'dashboard_show_customer_phone';
  static const String dashboardEnableCheckoutNotifications = 'dashboard_enable_checkout_notifications';
  static const String dashboardServiceDisplayMode = 'dashboard_service_display_mode';
  static const String dashboardFontSize = 'dashboard_font_size';
  static const String dashboardTechnicianLayout = 'dashboard_technician_layout';

  // Store
  static const String storeHoursConfiguration = 'store_hours_configuration';
  static const String storeOnlineBooking = 'store_online_booking';
  static const String storeLocation = 'store_location';
  static const String storeTimezone = 'store_timezone';
  static const String storeAppointmentBuffer = 'store_appointment_buffer';
  static const String storeWalkInsEnabled = 'store_walk_ins_enabled';
  static const String storeMaxDailyAppointments = 'store_max_daily_appointments';

  // General
  static const String generalTheme = 'general_theme';
  static const String generalSoundEffects = 'general_sound_effects';
  static const String generalAnimations = 'general_animations';
  static const String generalLanguage = 'general_language';
  static const String generalCurrency = 'general_currency';
  static const String generalDateFormat = 'general_date_format';
  static const String generalTimeFormat = 'general_time_format';
  static const String generalDefaultItemsPerPage = 'general_default_items_per_page';

  // Salon
  static const String salonServiceDurationBuffer = 'salon_service_duration_buffer';
  static const String salonRequireTechnicianSpecialization = 'salon_require_technician_specialization';
  static const String salonAutoCheckoutCompleted = 'salon_auto_checkout_completed';
  static const String salonLoyaltyPointsEnabled = 'salon_loyalty_points_enabled';
  static const String salonLoyaltyPointsRatio = 'salon_loyalty_points_ratio';
  static const String salonRequireAppointmentConfirmation = 'salon_require_appointment_confirmation';
  static const String salonReminderHoursBefore = 'salon_reminder_hours_before';
  static const String salonGroupBookingEnabled = 'salon_group_booking_enabled';
  static const String salonMaxGroupSize = 'salon_max_group_size';
  static const String salonPriceDisplayMode = 'salon_price_display_mode';
}