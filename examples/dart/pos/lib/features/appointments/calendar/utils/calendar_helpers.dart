// lib/features/appointments/calendar/utils/calendar_helpers.dart
// Shared calendar utilities for time calculations, date operations, and formatting.
// Contains reusable functions for all calendar views (week, day, month).
// Usage: ACTIVE - Shared utilities used across calendar components

import 'package:flutter/material.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/models/setting_model.dart';

// Time slot data structure
class TimeSlot {
  final int hour;
  final int minute;
  const TimeSlot({required this.hour, required this.minute});
}

// Calendar layout constants
const double kTimeColWidth = 100;
const double kSlotHeight = 45; // 15-min slot
const double kHeaderHeight = 80;

/// Generate quarter-hour time slots for calendar grid
List<TimeSlot> buildQuarterHourSlots(int startHour, int endHour) {
  final slots = <TimeSlot>[];
  for (var h = startHour; h < endHour; h++) {
    slots
      ..add(TimeSlot(hour: h, minute: 0))
      ..add(TimeSlot(hour: h, minute: 15))
      ..add(TimeSlot(hour: h, minute: 30))
      ..add(TimeSlot(hour: h, minute: 45));
  }
  return slots;
}

/// Calculate end hour from store settings with padding
int endHourFromSettings(StoreHours storeHours) {
  final todayName = getDayKey(DateTime.now().weekday);
  final hours = storeHours.hours[todayName] ?? const DayHours();
  final close = (hours.closeTime ?? 1140) ~/ 60; // default 19:00
  final ext = close + 1; // pad one hour past close
  return ext > 22 ? ext : 22; // min until 22:00
}

/// Get week start date (Monday) for any given date
DateTime getWeekStart(DateTime date) {
  final daysFromMonday = date.weekday - 1;
  return DateTime(date.year, date.month, date.day)
      .subtract(Duration(days: daysFromMonday));
}

/// Convert weekday number to day key string
String getDayKey(int weekday) {
  const names = [
    'monday',
    'tuesday', 
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  return names[weekday - 1];
}

/// Filter appointments for specific day
List<Appointment> dayAppointments(
  DateTime day,
  List<Appointment> appointments,
) =>
    (appointments
          .where((a) =>
              a.appointmentDate.year == day.year &&
              a.appointmentDate.month == day.month &&
              a.appointmentDate.day == day.day)
          .toList()
        ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate)));

/// Check if two dates are the same day
bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Format time for clock display (12-hour format)
String formatClock(int hour, int minute) {
  final hr = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final mm = minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  return '$hr:$mm $period';
}

/// Generate appointment color based on capacity level
Color appointmentColor(double capacityLevel) {
  // base purple, darkens with capacity level (0..1)
  const base = Color(0xFF9C27B0);
  final hsl = HSLColor.fromColor(base);
  final lightness = (0.88 - (capacityLevel * 0.55)).clamp(0.25, 0.88);
  return hsl
      .withLightness(lightness)
      .toColor()
      .withValues(alpha: (0.12 + capacityLevel * 0.75).clamp(0.1, 0.9));
}

/// Calculate position and height for appointment blocks
class AppointmentPosition {
  final double top;
  final double height;
  
  const AppointmentPosition({
    required this.top,
    required this.height,
  });
}

/// Calculate appointment block position within time slots
AppointmentPosition calculateAppointmentPosition({
  required DateTime appointmentStart,
  required int durationMinutes,
  required List<TimeSlot> timeSlots,
  required double slotHeight,
}) {
  final end = appointmentStart.add(Duration(minutes: durationMinutes));
  
  final first = timeSlots.first;
  final firstMin = first.hour * 60 + first.minute;
  final startMin = appointmentStart.hour * 60 + appointmentStart.minute;
  final endMin = end.hour * 60 + end.minute;

  final top = ((startMin - firstMin) / 15) * slotHeight;
  final rawHeight = ((endMin - startMin) / 15) * slotHeight;
  final height = rawHeight.clamp(24.0, double.infinity).toDouble();

  return AppointmentPosition(top: top, height: height);
}