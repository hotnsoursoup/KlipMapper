import 'package:flutter/material.dart';
import '../../../../shared/data/models/appointment_model.dart';
import '../utils/calendar_helpers.dart';

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

    final position = calculateAppointmentPosition(
      appointmentStart: start,
      durationMinutes: appointment.durationMinutes,
      timeSlots: timeSlots,
      slotHeight: slotHeight,
    );

    // optional: inject capacity level if you have it
    final color = appointmentColor(0.5);

    return Positioned(
      top: position.top,
      left: 4,
      right: 4,
      height: position.height,
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
