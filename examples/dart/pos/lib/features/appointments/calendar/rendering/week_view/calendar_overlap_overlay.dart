import 'package:flutter/material.dart';

import '../../../../shared/data/models/appointment_model.dart';
import 'calendar_week_constants.dart';

class OverlapOverlay extends StatelessWidget {
  final DateTime day;
  final List<TimeSlot> timeSlots;
  final double slotHeight;
  final List<Appointment> appointments;

  const OverlapOverlay({
    super.key,
    required this.day,
    required this.timeSlots,
    required this.slotHeight,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final a in appointments)
          _OverlayForAppointment(
            a: a,
            day: day,
            slots: timeSlots,
            slotHeight: slotHeight,
            appointments: appointments,
          ),
      ],
    );
  }
}

class _OverlayForAppointment extends StatelessWidget {
  final Appointment a;
  final DateTime day;
  final List<TimeSlot> slots;
  final double slotHeight;
  final List<Appointment> appointments;

  const _OverlayForAppointment({
    required this.a,
    required this.day,
    required this.slots,
    required this.slotHeight,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final start = a.appointmentDate;
    final end = start.add(Duration(minutes: a.durationMinutes));

    final startMin = start.hour * 60 + start.minute;
    final firstMin = slots.first.hour * 60 + slots.first.minute;

    final top = ((startMin - firstMin) / 15) * slotHeight;

    final data = _intervalCounts(a, appointments, start, end);
    if (data.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: top,
      left: 4,
      right: 4,
      child: Column(
        children: [
          for (final it in data)
            _CountCell(count: it.count, isTop: it.isTop, h: slotHeight),
        ],
      ),
    );
  }

  List<_Interval> _intervalCounts(
    Appointment target,
    List<Appointment> dayAppts,
    DateTime start,
    DateTime end,
  ) {
    final list = <_Interval>[];
    var cur = DateTime(
      start.year,
      start.month,
      start.day,
      start.hour,
      (start.minute ~/ 15) * 15,
    );
    while (cur.isBefore(end)) {
      final next = cur.add(const Duration(minutes: 15));
      final overlaps = dayAppts.where((x) {
        final s = x.appointmentDate;
        final e = s.add(Duration(minutes: x.durationMinutes));
        return s.isBefore(next) && e.isAfter(cur);
      }).toList();
      overlaps.sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      final isTop = overlaps.isNotEmpty && overlaps.first.id == target.id;
      list.add(_Interval(count: overlaps.length, isTop: isTop));
      cur = next;
    }
    return list;
  }
}

class _Interval {
  final int count;
  final bool isTop;
  const _Interval({required this.count, required this.isTop});
}

class _CountCell extends StatelessWidget {
  final int count;
  final bool isTop;
  final double h;
  const _CountCell({required this.count, required this.isTop, required this.h});
  @override
  Widget build(BuildContext context) {
    if (!isTop || count <= 1) return SizedBox(height: h);
    return SizedBox(
      height: h,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF4A148C).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
