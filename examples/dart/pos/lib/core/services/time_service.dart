// lib/core/services/time_service.dart
// Singleton service providing standardized time operations for the POS application. Centralizes date/time formatting, comparisons, and business day calculations with consistent formatting across features.
// Usage: ACTIVE - Used throughout the app for timestamp formatting, business date calculations, and appointment scheduling
/// Time service that provides current time for the application
class TimeService {
  static final TimeService _instance = TimeService._internal();
  static TimeService get instance => _instance;
  
  TimeService._internal();
  
  /// Get current time
  DateTime get now => DateTime.now();
  
  /// Get current date
  DateTime get today => DateTime.now();
  
  /// Get formatted date string (MM/dd/yyyy)
  String get todayFormatted {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
  }
  
  /// Get formatted time string (HH:mm)
  String get timeFormatted {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
  
  /// Get formatted datetime string for display
  String get nowFormatted => '$todayFormatted at $timeFormatted';
  
  /// Check if given date is today
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Get start of day for given date
  DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Get end of day for given date
  DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  /// Get start of current day
  DateTime get startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  
  /// Get end of current day
  DateTime get endOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }
}