// lib/core/services/settings_service.dart
// Service for persisting user settings across app sessions using SharedPreferences. Handles dashboard preferences, layout settings, and user interface customization storage.
// Usage: ACTIVE - Used throughout app for persisting user preferences and settings

import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting user settings across app sessions
class SettingsService {
  static const String _fontSizeKey = 'dashboard_font_size';
  static const String _statusQueueLayoutKey = 'dashboard_status_queue_layout';
  static const String _showTodaysScheduleKey = 'dashboard_show_todays_schedule';
  static const String _showUpcomingAppointmentsKey = 'dashboard_show_upcoming_appointments';
  static const String _isTimelineExpandedKey = 'dashboard_is_timeline_expanded';
  
  static SettingsService? _instance;
  static SettingsService get instance => _instance ??= SettingsService._();
  
  SettingsService._();
  
  SharedPreferences? _prefs;
  
  /// Initialize the service - call this before using any methods
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Ensure prefs is initialized
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('SettingsService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // Font Size Settings
  Future<void> setFontSize(String fontSize) async {
    await _preferences.setString(_fontSizeKey, fontSize);
  }
  
  String getFontSize() {
    return _preferences.getString(_fontSizeKey) ?? 'medium';
  }
  
  // Status Queue Layout Settings
  Future<void> setStatusQueueLayout(String layout) async {
    await _preferences.setString(_statusQueueLayoutKey, layout);
  }
  
  String getStatusQueueLayout() {
    return _preferences.getString(_statusQueueLayoutKey) ?? 'grid2';
  }
  
  // Show Today's Schedule Settings
  Future<void> setShowTodaysSchedule(bool show) async {
    await _preferences.setBool(_showTodaysScheduleKey, show);
  }
  
  bool getShowTodaysSchedule() {
    // Force to false until Today's Schedule feature is complete
    return false;
    // return _preferences.getBool(_showTodaysScheduleKey) ?? false;
  }
  
  // Show Upcoming Appointments Settings
  Future<void> setShowUpcomingAppointments(bool show) async {
    await _preferences.setBool(_showUpcomingAppointmentsKey, show);
  }
  
  bool getShowUpcomingAppointments() {
    return _preferences.getBool(_showUpcomingAppointmentsKey) ?? true;
  }
  
  // Timeline Expanded Settings
  Future<void> setIsTimelineExpanded(bool expanded) async {
    await _preferences.setBool(_isTimelineExpandedKey, expanded);
  }
  
  bool getIsTimelineExpanded() {
    return _preferences.getBool(_isTimelineExpandedKey) ?? false;
  }
  
  /// Load all dashboard settings at once
  Map<String, dynamic> getAllDashboardSettings() {
    return {
      'fontSize': getFontSize(),
      'statusQueueLayout': getStatusQueueLayout(),
      'showTodaysSchedule': getShowTodaysSchedule(),
      'showUpcomingAppointments': getShowUpcomingAppointments(),
      'isTimelineExpanded': getIsTimelineExpanded(),
    };
  }
  
  /// Clear all settings (useful for testing or reset functionality)
  Future<void> clearAllSettings() async {
    await _preferences.remove(_fontSizeKey);
    await _preferences.remove(_statusQueueLayoutKey);
    await _preferences.remove(_showTodaysScheduleKey);
    await _preferences.remove(_showUpcomingAppointmentsKey);
    await _preferences.remove(_isTimelineExpandedKey);
  }
}