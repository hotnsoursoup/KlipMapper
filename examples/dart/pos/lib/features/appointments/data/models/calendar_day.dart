// lib/features/appointments/data/models/calendar_day.dart
// Calendar day model representing daily schedules with appointments, availability, and analytics.
// Includes conflict detection, utilization tracking, and comprehensive day summary statistics.
// Usage: ACTIVE - Daily calendar views, scheduling conflicts, and technician workload analysis

import 'calendar_appointment.dart';
import 'time_slot.dart';

/// Represents a single day in the calendar with all its appointments and availability
class CalendarDay {
  final DateTime date;
  final List<CalendarAppointment> appointments;
  final Map<String, List<TimeSlot>> technicianSlots; // Per technician time slots
  final Map<String, String> technicianNames; // Technician ID to name mapping
  final bool isToday;
  final bool isWeekend;
  final bool isHoliday;
  final String? holidayName;

  const CalendarDay({
    required this.date,
    required this.appointments,
    required this.technicianSlots,
    required this.technicianNames,
    required this.isToday,
    required this.isWeekend,
    this.isHoliday = false,
    this.holidayName,
  });

  /// Get appointments for a specific technician
  List<CalendarAppointment> getAppointmentsForTechnician(String technicianId) {
    return appointments.where((apt) => apt.technicianId == technicianId).toList();
  }

  /// Get available time slots for a specific technician
  List<TimeSlot> getAvailableSlotsForTechnician(String technicianId) {
    final slots = technicianSlots[technicianId] ?? [];
    return slots.where((slot) => slot.isAvailable).toList();
  }

  /// Get all technician IDs for this day
  List<String> get technicianIds => technicianSlots.keys.toList();

  /// Get total number of appointments for the day
  int get totalAppointments => appointments.length;

  /// Get appointments by status
  List<CalendarAppointment> getAppointmentsByStatus(AppointmentStatus status) {
    return appointments.where((apt) => apt.status == status).toList();
  }

  /// Check if a technician has any appointments
  bool technicianHasAppointments(String technicianId) {
    return appointments.any((apt) => apt.technicianId == technicianId);
  }

  /// Get the earliest appointment time for the day
  DateTime? get earliestAppointmentTime {
    if (appointments.isEmpty) return null;
    return appointments.map((apt) => apt.startTime).reduce((a, b) => a.isBefore(b) ? a : b);
  }

  /// Get the latest appointment time for the day
  DateTime? get latestAppointmentTime {
    if (appointments.isEmpty) return null;
    return appointments.map((apt) => apt.endTime).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// Calculate total revenue for the day
  double get totalRevenue {
    return appointments
        .where((apt) => apt.status == AppointmentStatus.completed)
        .fold(0.0, (sum, apt) => sum + apt.totalCost);
  }

  /// Get utilization rate for a technician (percentage of time booked)
  double getTechnicianUtilization(String technicianId) {
    final slots = technicianSlots[technicianId] ?? [];
    if (slots.isEmpty) return 0.0;

    final totalSlots = slots.length;
    final bookedSlots = slots.where((slot) => !slot.isAvailable || slot.hasAppointment).length;
    
    return (bookedSlots / totalSlots) * 100;
  }

  /// Find conflicts (overlapping appointments) for the day
  List<List<CalendarAppointment>> findConflicts() {
    final conflicts = <List<CalendarAppointment>>[];
    
    for (int i = 0; i < appointments.length; i++) {
      for (int j = i + 1; j < appointments.length; j++) {
        final apt1 = appointments[i];
        final apt2 = appointments[j];
        
        // Check if appointments overlap and are for the same technician
        if (apt1.technicianId == apt2.technicianId &&
            _appointmentsOverlap(apt1, apt2)) {
          conflicts.add([apt1, apt2]);
        }
      }
    }
    
    return conflicts;
  }

  /// Check if two appointments overlap in time
  bool _appointmentsOverlap(CalendarAppointment apt1, CalendarAppointment apt2) {
    return apt1.startTime.isBefore(apt2.endTime) && apt1.endTime.isAfter(apt2.startTime);
  }

  /// Find next available slot for a service duration
  TimeSlot? findNextAvailableSlot({
    required String technicianId,
    required int durationMinutes,
    DateTime? afterTime,
  }) {
    final slots = technicianSlots[technicianId] ?? [];
    final startTime = afterTime ?? DateTime.now();
    
    return TimeSlotGenerator.findAvailableSlots(
      daySlots: slots,
      serviceDurationMinutes: durationMinutes,
      preferredStartTime: startTime,
    ).firstOrNull;
  }

  /// Get day summary statistics
  DaySummary get summary {
    return DaySummary(
      date: date,
      totalAppointments: totalAppointments,
      completedAppointments: getAppointmentsByStatus(AppointmentStatus.completed).length,
      cancelledAppointments: getAppointmentsByStatus(AppointmentStatus.cancelled).length,
      totalRevenue: totalRevenue,
      averageUtilization: _calculateAverageUtilization(),
      conflicts: findConflicts().length,
    );
  }

  double _calculateAverageUtilization() {
    if (technicianIds.isEmpty) return 0.0;
    
    final utilizationRates = technicianIds.map((id) => getTechnicianUtilization(id));
    return utilizationRates.fold(0.0, (sum, rate) => sum + rate) / technicianIds.length;
  }

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: DateTime.parse(json['date'] as String),
      appointments: (json['appointments'] as List)
          .map((apt) => CalendarAppointment.fromJson(apt as Map<String, dynamic>))
          .toList(),
      technicianSlots: (json['technicianSlots'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>)).toList(),
        ),
      ),
      technicianNames: Map<String, String>.from(json['technicianNames'] as Map),
      isToday: json['isToday'] as bool,
      isWeekend: json['isWeekend'] as bool,
      isHoliday: json['isHoliday'] as bool? ?? false,
      holidayName: json['holidayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'appointments': appointments.map((apt) => apt.toJson()).toList(),
      'technicianSlots': technicianSlots.map(
        (key, value) => MapEntry(key, value.map((slot) => slot.toJson()).toList()),
      ),
      'technicianNames': technicianNames,
      'isToday': isToday,
      'isWeekend': isWeekend,
      'isHoliday': isHoliday,
      'holidayName': holidayName,
    };
  }

  CalendarDay copyWith({
    DateTime? date,
    List<CalendarAppointment>? appointments,
    Map<String, List<TimeSlot>>? technicianSlots,
    Map<String, String>? technicianNames,
    bool? isToday,
    bool? isWeekend,
    bool? isHoliday,
    String? holidayName,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      appointments: appointments ?? this.appointments,
      technicianSlots: technicianSlots ?? this.technicianSlots,
      technicianNames: technicianNames ?? this.technicianNames,
      isToday: isToday ?? this.isToday,
      isWeekend: isWeekend ?? this.isWeekend,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName ?? this.holidayName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDay &&
          runtimeType == other.runtimeType &&
          date == other.date;

  @override
  int get hashCode => date.hashCode;

  @override
  String toString() {
    return 'CalendarDay{date: $date, appointments: ${appointments.length}, '
           'technicians: ${technicianIds.length}}';
  }
}

/// Summary statistics for a calendar day
class DaySummary {
  final DateTime date;
  final int totalAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final double totalRevenue;
  final double averageUtilization;
  final int conflicts;

  const DaySummary({
    required this.date,
    required this.totalAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.totalRevenue,
    required this.averageUtilization,
    required this.conflicts,
  });

  factory DaySummary.fromJson(Map<String, dynamic> json) {
    return DaySummary(
      date: DateTime.parse(json['date'] as String),
      totalAppointments: json['totalAppointments'] as int,
      completedAppointments: json['completedAppointments'] as int,
      cancelledAppointments: json['cancelledAppointments'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      averageUtilization: (json['averageUtilization'] as num).toDouble(),
      conflicts: json['conflicts'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalAppointments': totalAppointments,
      'completedAppointments': completedAppointments,
      'cancelledAppointments': cancelledAppointments,
      'totalRevenue': totalRevenue,
      'averageUtilization': averageUtilization,
      'conflicts': conflicts,
    };
  }
}

// Extension for List<T> to add firstOrNull
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}