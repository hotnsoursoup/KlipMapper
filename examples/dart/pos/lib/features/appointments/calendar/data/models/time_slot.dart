// lib/features/calendar/data/models/time_slot.dart
// Time slot data model representing a specific hour and minute for calendar grid display.
// Used for building calendar grids with 15-minute intervals and time-based layouts.
// Usage: ACTIVE - Core data model for calendar time slot representation

/// Represents a specific time slot in a calendar grid
/// Used for 15-minute interval scheduling displays
class TimeSlot {
  /// Hour in 24-hour format (0-23)
  final int hour;
  
  /// Minute within the hour (0, 15, 30, 45 for 15-minute intervals)
  final int minute;
  
  const TimeSlot({
    required this.hour, 
    required this.minute,
  });
  
  /// Converts to minutes since midnight for calculations
  int get totalMinutes => hour * 60 + minute;
  
  /// Formats as 12-hour time string (e.g., "2:30 PM")
  String format12Hour() {
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final mm = minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    return '$h12:$mm $ampm';
  }
  
  /// Formats as 24-hour time string (e.g., "14:30")
  String format24Hour() {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
  
  @override
  String toString() => 'TimeSlot($hour:${minute.toString().padLeft(2, '0')})';
}