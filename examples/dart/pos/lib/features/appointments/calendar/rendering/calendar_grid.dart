// lib/features/appointments/presentation/widgets/calendar_grid.dart (legacy)
// Disabled alternative calendar grid. Kept as a stub to avoid compile-time issues.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarGrid extends ConsumerWidget {
  final Function(String) onAppointmentTap;
  final Function({DateTime? selectedTime, String? selectedTechnicianId}) onTimeSlotTap;
  final Function({
    required String appointmentId,
    required DateTime newStartTime,
    required String newTechnicianId,
  }) onAppointmentMove;

  const CalendarGrid({
    super.key,
    required this.onAppointmentTap,
    required this.onTimeSlotTap,
    required this.onAppointmentMove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('Legacy CalendarGrid is disabled in this build.'),
    );
  }
}

