// lib/features/appointments/data/models/calendar_appointment.dart
// Enhanced calendar appointment model with comprehensive status tracking and business logic.
// Includes color coding, validation, cost calculations, and support for recurring/group appointments.
// Usage: ACTIVE - Calendar view rendering, appointment management, and scheduling system

import 'package:flutter/material.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/data/models/service_model.dart';

/// Status of a calendar appointment
enum AppointmentStatus {
  scheduled,
  confirmed,
  checkedIn,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled,
}

/// Enhanced appointment model specifically designed for calendar view
class CalendarAppointment {
  final String id;
  final Customer customer;
  final List<Service> services;
  final String technicianId;
  final String? technicianName; // For display without lookup
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentStatus status;
  final Color color; // Color coding based on technician
  final bool isBlocked; // For technician breaks/lunch/off time
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isRecurring;
  final String? recurringPattern; // weekly, biweekly, monthly
  final bool isGroupAppointment;
  final List<String>? groupMemberIds;

  const CalendarAppointment({
    required this.id,
    required this.customer,
    required this.services,
    required this.technicianId,
    this.technicianName,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.color,
    this.isBlocked = false,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.isRecurring = false,
    this.recurringPattern,
    this.isGroupAppointment = false,
    this.groupMemberIds,
  });

  /// Duration of the appointment in minutes
  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// Duration of the appointment in hours (decimal)
  double get durationHours => durationMinutes / 60.0;

  /// Whether this appointment is happening today
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
           startTime.month == now.month &&
           startTime.day == now.day;
  }

  /// Whether this appointment is in the past
  bool get isPast => endTime.isBefore(DateTime.now());

  /// Whether this appointment is currently happening
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Whether this appointment can be edited
  bool get canEdit => !isPast && status != AppointmentStatus.completed;

  /// Whether this appointment can be cancelled
  bool get canCancel => !isPast && 
                        status != AppointmentStatus.completed && 
                        status != AppointmentStatus.cancelled;

  /// Total cost of all services
  double get totalCost => services.fold(0.0, (sum, service) => sum + service.price);

  /// Display text for appointment status
  String get statusDisplayText {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.checkedIn:
        return 'Checked In';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  /// Color for status indicator
  Color get statusColor {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.checkedIn:
        return Colors.orange;
      case AppointmentStatus.inProgress:
        return Colors.purple;
      case AppointmentStatus.completed:
        return Colors.green.shade700;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.red.shade700;
      case AppointmentStatus.rescheduled:
        return Colors.amber;
    }
  }

  factory CalendarAppointment.fromJson(Map<String, dynamic> json) {
    return CalendarAppointment(
      id: json['id'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      services: (json['services'] as List)
          .map((s) => Service.fromJson(s as Map<String, dynamic>))
          .toList(),
      technicianId: json['technicianId'] as String,
      technicianName: json['technicianName'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      color: Color(json['color'] as int? ?? 0xFF2196F3), // Colors.blue equivalent
      isBlocked: json['isBlocked'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPattern: json['recurringPattern'] as String?,
      isGroupAppointment: json['isGroupAppointment'] as bool? ?? false,
      groupMemberIds: (json['groupMemberIds'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer.toJson(),
      'services': services.map((s) => s.toJson()).toList(),
      'technicianId': technicianId,
      'technicianName': technicianName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.name,
      'color': color.toARGB32(),
      'isBlocked': isBlocked,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'isGroupAppointment': isGroupAppointment,
      'groupMemberIds': groupMemberIds,
    };
  }

  CalendarAppointment copyWith({
    String? id,
    Customer? customer,
    List<Service>? services,
    String? technicianId,
    String? technicianName,
    DateTime? startTime,
    DateTime? endTime,
    AppointmentStatus? status,
    Color? color,
    bool? isBlocked,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
    String? recurringPattern,
    bool? isGroupAppointment,
    List<String>? groupMemberIds,
  }) {
    return CalendarAppointment(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      services: services ?? this.services,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      color: color ?? this.color,
      isBlocked: isBlocked ?? this.isBlocked,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      isGroupAppointment: isGroupAppointment ?? this.isGroupAppointment,
      groupMemberIds: groupMemberIds ?? this.groupMemberIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarAppointment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CalendarAppointment{id: $id, customer: ${customer.name}, '
           'technician: $technicianName, startTime: $startTime, '
           'endTime: $endTime, status: $status}';
  }
}