// lib/features/shared/data/models/appointment_model.dart
// Freezed data model for appointments with customer and service relationships, supporting group bookings and status tracking.
// Usage: ACTIVE - Core appointment data model used throughout appointment system
import 'package:freezed_annotation/freezed_annotation.dart';
import 'customer_model.dart';
import 'service_model.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

/// Appointment model
@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String customerId,
    required DateTime appointmentDate,
    required String appointmentTime, // HH:mm format
    required int durationMinutes,
    @Default('scheduled') String status,
    String? requestedTechnicianId,
    String? assignedTechnicianId,
    required List<String> serviceIds,
    String? notes,
    @Default(false) bool reminderSent,
    @Default(false) bool confirmationSent,
    @Default('pos') String source,
    DateTime? cancelledAt,
    String? cancellationReason,
    @Default(false) bool isGroupBooking,
    @Default(1) int groupSize,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // Populated objects (loaded from repository)
    Customer? customer,
    List<Service>? services,
    String? requestedTechnicianName,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}

/// Appointment status enum
enum AppointmentStatus {
  scheduled,
  confirmed,
  arrived,
  inService,
  completed,
  noShow,
  cancelled,
}

/// Appointment source enum
enum AppointmentSource {
  pos,
  online,
  phone,
  walkIn,
}

extension AppointmentStatusX on AppointmentStatus {
  String get value {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'scheduled';
      case AppointmentStatus.confirmed:
        return 'confirmed';
      case AppointmentStatus.arrived:
        return 'arrived';
      case AppointmentStatus.inService:
        return 'in-service';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.noShow:
        return 'no-show';
      case AppointmentStatus.cancelled:
        return 'cancelled';
    }
  }

  static AppointmentStatus fromString(String value) {
    switch (value) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'arrived':
        return AppointmentStatus.arrived;
      case 'in-service':
        return AppointmentStatus.inService;
      case 'completed':
        return AppointmentStatus.completed;
      case 'no-show':
        return AppointmentStatus.noShow;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.scheduled;
    }
  }
}

extension AppointmentHelpers on Appointment {
  /// Get customer name - uses customer object if available, otherwise customer ID
  String get customerName => customer?.name ?? customerId;
  
  /// Get the scheduled start time as DateTime
  DateTime get scheduledStartTime {
    final timeParts = appointmentTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      hour,
      minute,
    );
  }
  
  /// Get the scheduled end time as DateTime
  DateTime get scheduledEndTime {
    return scheduledStartTime.add(Duration(minutes: durationMinutes));
  }
  
  /// Get duration in minutes
  int get duration => durationMinutes;
}
