// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class AppDateFormatter {
  // Private constructor to prevent instantiation
  AppDateFormatter._();

  // Note: Using DateTime.toIso8601String() for consistency

  /// **DATABASE STORAGE METHODS**
  
  /// Converts DateTime to ISO8601 string for database storage
  /// Returns format: "2025-01-15T10:30:00.123Z"
  static String toIso8601String(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Converts ISO8601 string from database to DateTime
  /// Handles both full timestamps and date-only strings
  static DateTime? fromIso8601String(String? iso8601String) {
    if (iso8601String == null || iso8601String.isEmpty) return null;
    
    try {
      // Handle date-only format (yyyy-MM-dd)
      if (iso8601String.length == 10 && !iso8601String.contains('T')) {
        return DateTime.parse('${iso8601String}T00:00:00.000Z');
      }
      
      // Handle full ISO8601 timestamp
      return DateTime.parse(iso8601String);
    } catch (e) {
      // Fallback: try to parse as standard DateTime
      try {
        return DateTime.parse(iso8601String);
      } catch (_) {
        return null;
      }
    }
  }

  /// **DATE RANGE FILTERING METHODS**
  
  /// Gets start of day in ISO8601 format for database queries
  /// Returns: "2025-01-15T00:00:00.000Z"
  static String getStartOfDayIso8601(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return toIso8601String(startOfDay);
  }

  /// Gets end of day in ISO8601 format for database queries  
  /// Returns: "2025-01-15T23:59:59.999Z"
  static String getEndOfDayIso8601(DateTime date) {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    return toIso8601String(endOfDay);
  }

  /// Gets date range for "Today"
  static _DateRange getToday() {
    final now = DateTime.now();
    return _DateRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
    );
  }

  /// Gets date range for "Yesterday"
  static _DateRange getYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _DateRange(
      start: DateTime(yesterday.year, yesterday.month, yesterday.day),
      end: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999),
    );
  }

  /// Gets date range for "This Week" (Monday to Sunday)
  static _DateRange getThisWeek() {
    final now = DateTime.now();
    final mondayOffset = now.weekday - 1; // Monday = 1, so offset = 0
    final monday = now.subtract(Duration(days: mondayOffset));
    final sunday = monday.add(const Duration(days: 6));
    
    return _DateRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
    );
  }

  /// Gets date range for "Last Week"
  static _DateRange getLastWeek() {
    final thisWeek = getThisWeek();
    final lastWeekStart = thisWeek.start.subtract(const Duration(days: 7));
    final lastWeekEnd = thisWeek.end.subtract(const Duration(days: 7));
    
    return _DateRange(start: lastWeekStart, end: lastWeekEnd);
  }

  /// Gets date range for "This Month"
  static _DateRange getThisMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
    
    return _DateRange(start: firstDay, end: lastDay);
  }

  /// Gets date range for "Last Month"
  static _DateRange getLastMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 1);
    final lastDay = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
    
    return _DateRange(start: firstDay, end: lastDay);
  }

  /// **DISPLAY FORMATTING METHODS**

  /// Formats time, e.g., "9:00 AM"
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  /// Formats time without AM/PM, e.g., "9:00 - 10:30"
  static String formatTimeRange(DateTime start, DateTime end) {
    final startStr = DateFormat.jm().format(start);
    final endStr = DateFormat.jm().format(end);

    if (startStr.endsWith(' AM') && endStr.endsWith(' AM')) {
      return '${startStr.replaceAll(' AM', '')} - ${endStr.replaceAll(' AM', ' AM')}';
    }
    if (startStr.endsWith(' PM') && endStr.endsWith(' PM')) {
      return '${startStr.replaceAll(' PM', '')} - ${endStr.replaceAll(' PM', ' PM')}';
    }
    return '$startStr - $endStr';
  }

  /// Formats a full date, e.g., "EEEE, MMMM d, y" -> "Tuesday, August 5, 2025"
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  /// Formats a short date, e.g., "MMM d, y" -> "Aug 5, 2025"
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// Formats date for UI display, e.g., "Jan 15" or "Jan 15, 2024" if different year
  static String formatDisplayDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('MMM d').format(date);
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  /// Formats date range for display, e.g., "Jan 15 - 20" or "Dec 28 - Jan 3"
  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      // Same month: "Jan 15 - 20"
      return '${DateFormat('MMM d').format(start)} - ${end.day}';
    } else if (start.year == end.year) {
      // Same year, different months: "Dec 28 - Jan 3"
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d').format(end)}';
    } else {
      // Different years: "Dec 28, 2024 - Jan 3, 2025"
      return '${formatDisplayDate(start)} - ${formatDisplayDate(end)}';
    }
  }
}

/// Simple date range holder for internal use
class _DateRange {
  final DateTime start;
  final DateTime end;

  const _DateRange({required this.start, required this.end});
}
