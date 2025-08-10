import 'package:flutter/material.dart';

import '../../../../shared/data/models/appointment_model.dart';
import 'calendar_week_constants.dart';

class AppointmentBlock extends StatelessWidget {
  final DateTime day;
  final Appointment appointment;
  final List<TimeSlot> timeSlots;
  final double slotHeight;
  final VoidCallback onTap;

  const AppointmentBlock({
    super.key,
    required this.day,
    required this.appointment,
    required this.timeSlots,
    required this.slotHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final start = appointment.appointmentDate;
    final end = start.add(Duration(minutes: appointment.durationMinutes));

    final first = timeSlots.first;
    final firstMin = first.hour * 60 + first.minute;
    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;

    final top = ((startMin - firstMin) / 15) * slotHeight;
    final rawH = ((endMin - startMin) / 15) * slotHeight;
    final height = rawH.clamp(24.0, double.infinity).toDouble();

    // optional: inject capacity level if you have it
    final color = appointmentColor(0.5);

    return Positioned(
      top: top,
      left: 4,
      right: 4,
      height: height,
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white),
            ),
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
