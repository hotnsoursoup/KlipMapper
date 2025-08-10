import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'calendar_week_constants.dart';

class TimeColumn extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final double width;
  final double slotHeight;

  const TimeColumn({
    super.key,
    required this.timeSlots,
    required this.width,
    required this.slotHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: timeSlots.length * slotHeight,
      child: Column(
        children: [
          for (final s in timeSlots) _TimeCell(
            slot: s, slotHeight: slotHeight, width: width),
        ],
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  final TimeSlot slot;
  final double width;
  final double slotHeight;

  const _TimeCell({
    required this.slot,
    required this.width,
    required this.slotHeight,
  });

  @override
  Widget build(BuildContext context) {
    final show = slot.minute == 0 || slot.minute == 30;
    final text = show
        ? _fmt(slot.hour, slot.minute)
        : '';
    return Container(
      height: slotHeight,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.2),
            width: 0.5,
          ),
          right: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 8),
      child: show 
        ? Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          )
        : const SizedBox.shrink(),
    );
  }
}

String _fmt(int h, int m) {
  final hr = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  final mm = m.toString().padLeft(2, '0');
  final p = h >= 12 ? 'PM' : 'AM';
  return '$hr:$mm $p';
}
