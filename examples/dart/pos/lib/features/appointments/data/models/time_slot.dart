// lib/features/appointments/data/models/time_slot.dart
// Time slot model for calendar availability tracking with generation utilities and visual styling.
// Includes availability detection, color management, and slot generation algorithms for scheduling.
// Usage: ACTIVE - Calendar time slot management, availability tracking, and appointment scheduling

import 'package:flutter/material.dart';

/// Represents a time slot in the calendar for availability tracking
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? reason; // "Break", "Lunch", "Blocked", "Appointment"
  final String? appointmentId; // If occupied by an appointment
  final String? technicianId; // Associated technician

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.reason,
    this.appointmentId,
    this.technicianId,
  });

  /// Duration of the time slot in minutes
  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// Duration of the time slot in hours (decimal)
  double get durationHours => durationMinutes / 60.0;

  /// Whether this time slot is in the past
  bool get isPast => endTime.isBefore(DateTime.now());

  /// Whether this time slot contains the current time
  bool get isCurrentTime {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Whether this time slot is a break or blocked time
  bool get isBlocked => !isAvailable && (reason == 'Break' || reason == 'Lunch' || reason == 'Blocked');

  /// Whether this time slot is occupied by an appointment
  bool get hasAppointment => !isAvailable && appointmentId != null;

  /// Display color for the time slot
  Color get displayColor {
    if (isAvailable) {
      return Colors.grey.shade100;
    } else if (isBlocked) {
      return Colors.grey.shade300;
    } else if (hasAppointment) {
      return Colors.blue.shade100;
    }
    return Colors.white;
  }

  /// Border color for the time slot
  Color get borderColor {
    if (isCurrentTime) {
      return Colors.red;
    } else if (isBlocked) {
      return Colors.grey.shade400;
    } else if (hasAppointment) {
      return Colors.blue.shade300;
    }
    return Colors.grey.shade200;
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool,
      reason: json['reason'] as String?,
      appointmentId: json['appointmentId'] as String?,
      technicianId: json['technicianId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
      'reason': reason,
      'appointmentId': appointmentId,
      'technicianId': technicianId,
    };
  }

  TimeSlot copyWith({
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? reason,
    String? appointmentId,
    String? technicianId,
  }) {
    return TimeSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      reason: reason ?? this.reason,
      appointmentId: appointmentId ?? this.appointmentId,
      technicianId: technicianId ?? this.technicianId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          technicianId == other.technicianId;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode ^ technicianId.hashCode;

  @override
  String toString() {
    return 'TimeSlot{startTime: $startTime, endTime: $endTime, '
           'isAvailable: $isAvailable, reason: $reason, '
           'technicianId: $technicianId}';
  }
}

/// Utility class for generating time slots
class TimeSlotGenerator {
  /// Generate time slots for a given date and technician
  static List<TimeSlot> generateDaySlots({
    required DateTime date,
    required String technicianId,
    int startHour = 8, // 8 AM
    int endHour = 20, // 8 PM
    int intervalMinutes = 15,
    List<DateTime> breakTimes = const [],
    List<DateTime> lunchTimes = const [],
    List<DateTime> blockedTimes = const [],
  }) {
    final slots = <TimeSlot>[];
    
    final startOfDay = DateTime(date.year, date.month, date.day, startHour);
    final endOfDay = DateTime(date.year, date.month, date.day, endHour);
    
    DateTime currentTime = startOfDay;
    
    while (currentTime.isBefore(endOfDay)) {
      final slotEnd = currentTime.add(Duration(minutes: intervalMinutes));
      
      // Check if this slot should be blocked
      bool isBlocked = false;
      String? blockReason;
      
      // Check for breaks
      for (final breakTime in breakTimes) {
        if (_timeOverlaps(currentTime, slotEnd, breakTime, breakTime.add(const Duration(minutes: 15)))) {
          isBlocked = true;
          blockReason = 'Break';
          break;
        }
      }
      
      // Check for lunch
      if (!isBlocked) {
        for (final lunchTime in lunchTimes) {
          if (_timeOverlaps(currentTime, slotEnd, lunchTime, lunchTime.add(const Duration(hours: 1)))) {
            isBlocked = true;
            blockReason = 'Lunch';
            break;
          }
        }
      }
      
      // Check for blocked times
      if (!isBlocked) {
        for (final blockedTime in blockedTimes) {
          if (_timeOverlaps(currentTime, slotEnd, blockedTime, blockedTime.add(const Duration(minutes: 30)))) {
            isBlocked = true;
            blockReason = 'Blocked';
            break;
          }
        }
      }
      
      slots.add(TimeSlot(
        startTime: currentTime,
        endTime: slotEnd,
        isAvailable: !isBlocked,
        reason: blockReason,
        technicianId: technicianId,
      ),);
      
      currentTime = slotEnd;
    }
    
    return slots;
  }
  
  /// Check if two time ranges overlap
  static bool _timeOverlaps(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }
  
  /// Find available slots that can accommodate a service of given duration
  static List<TimeSlot> findAvailableSlots({
    required List<TimeSlot> daySlots,
    required int serviceDurationMinutes,
    DateTime? preferredStartTime,
  }) {
    final availableSlots = <TimeSlot>[];
    
    for (int i = 0; i < daySlots.length; i++) {
      final slot = daySlots[i];
      
      if (!slot.isAvailable) continue;
      
      // Check if we can fit the service starting from this slot
      int remainingDuration = serviceDurationMinutes;
      int consecutiveSlots = 0;
      
      for (int j = i; j < daySlots.length && remainingDuration > 0; j++) {
        final checkSlot = daySlots[j];
        
        if (!checkSlot.isAvailable) break;
        
        remainingDuration -= checkSlot.durationMinutes;
        consecutiveSlots++;
        
        if (remainingDuration <= 0) {
          // Found enough consecutive available slots
          availableSlots.add(TimeSlot(
            startTime: slot.startTime,
            endTime: daySlots[i + consecutiveSlots - 1].endTime,
            isAvailable: true,
            technicianId: slot.technicianId,
          ),);
          break;
        }
      }
    }
    
    // Sort by preference if specified
    if (preferredStartTime != null) {
      availableSlots.sort((a, b) {
        final aDiff = a.startTime.difference(preferredStartTime).abs();
        final bDiff = b.startTime.difference(preferredStartTime).abs();
        return aDiff.compareTo(bDiff);
      });
    }
    
    return availableSlots;
  }
}