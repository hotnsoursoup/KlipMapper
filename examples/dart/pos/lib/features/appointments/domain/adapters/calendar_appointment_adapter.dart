// lib/features/appointments/domain/adapters/calendar_appointment_adapter.dart
import 'package:flutter/material.dart';

import '../../data/models/calendar_appointment.dart';
import '../../../shared/data/models/appointment_model.dart' as domain;
import '../../../shared/data/models/customer_model.dart';

/// Map your domain Appointment → CalendarAppointment used by AppointmentBlock.
CalendarAppointment toCalendarAppointment(domain.Appointment a) {
  // Convert appointmentDate + appointmentTime to DateTime
  final startTime = _combineDateTime(a.appointmentDate, a.appointmentTime);
  final endTime = startTime.add(Duration(minutes: a.durationMinutes));

  // Pick a color deterministically (or from your status/theme)
  final Color color = _colorForStatus(a.status);

  // Customer name (fallback if customer object not populated)
  final customerName = a.customer?.name ?? 'Customer ${a.customerId}';

  // Status enum mapping
  final status = _statusFor(a.status);

  return CalendarAppointment(
    id: a.id,
    customer: a.customer ?? _createFallbackCustomer(a.customerId, customerName),
    services: a.services ?? [],
    technicianId: a.assignedTechnicianId ?? a.requestedTechnicianId ?? '',
    technicianName: a.requestedTechnicianName,
    startTime: startTime,
    endTime: endTime,
    status: status,
    color: color,
    isBlocked: false,
    notes: a.notes,
    createdAt: a.createdAt,
    updatedAt: a.updatedAt,
    isRecurring: false,
    recurringPattern: null,
    isGroupAppointment: a.isGroupBooking,
    groupMemberIds: a.isGroupBooking ? [] : null,
  );
}

/// Helper to combine appointmentDate and appointmentTime into DateTime
DateTime _combineDateTime(DateTime date, String timeString) {
  final parts = timeString.split(':');
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  
  return DateTime(
    date.year,
    date.month,
    date.day,
    hour,
    minute,
  );
}

/// Create a fallback customer when domain model doesn't have populated customer
Customer _createFallbackCustomer(String customerId, String name) {
  return Customer.withName(
    id: customerId,
    name: name,
    phone: '',
  );
}

AppointmentStatus _statusFor(String status) {
  switch (status.toLowerCase()) {
    case 'scheduled': return AppointmentStatus.scheduled;
    case 'confirmed': return AppointmentStatus.confirmed;
    case 'arrived':   return AppointmentStatus.checkedIn;
    case 'in-service':
    case 'inprogress':
    case 'in_progress': return AppointmentStatus.inProgress;
    case 'completed': return AppointmentStatus.completed;
    case 'cancelled': return AppointmentStatus.cancelled;
    case 'no-show':
    case 'no_show':   return AppointmentStatus.noShow;
    case 'rescheduled': return AppointmentStatus.rescheduled;
    default: return AppointmentStatus.scheduled;
  }
}

Color _colorForStatus(String status) {
  switch (status.toLowerCase()) {
    case 'confirmed': return const Color(0xFF2ECC71);
    case 'arrived':
    case 'in-service': return const Color(0xFFF5A623);
    case 'completed': return const Color(0xFFBDBDBD);
    case 'cancelled':
    case 'no-show':   return const Color(0xFFE74C3C);
    default:          return const Color(0xFF1A73E8);
  }
}

Color _statusColor(AppointmentStatus s) {
  switch (s) {
    case AppointmentStatus.scheduled:  return const Color(0xFF1A73E8);
    case AppointmentStatus.confirmed:  return const Color(0xFF2ECC71);
    case AppointmentStatus.checkedIn:  return const Color(0xFFF5A623);
    case AppointmentStatus.inProgress: return const Color(0xFFF39C12);
    case AppointmentStatus.completed:  return const Color(0xFF9E9E9E);
    case AppointmentStatus.cancelled:  return const Color(0xFFE74C3C);
    case AppointmentStatus.noShow:     return const Color(0xFFE74C3C);
    case AppointmentStatus.rescheduled:return const Color(0xFF7F8C8D);
  }
}
