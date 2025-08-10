import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/models/appointment_model.dart';
import '../../../../shared/data/models/setting_model.dart';
import '../../widgets/appointment_block.dart';
import 'calendar_overlap_overlay.dart';
import 'calendar_store_hours_line.dart';
import 'calendar_week_constants.dart';

class DayColumn extends StatefulWidget {
  final DateTime day;
  final List<TimeSlot> timeSlots;
  final double slotHeight;
  final double width;
  final bool isLastDay;
  final bool isFirstColumn;
  final StoreHours storeHours;
  final List<Appointment> appointments;
  final bool showOverlapCount;
  final void Function({
    DateTime? selectedTime,
    String? selectedTechnicianId,
  }) onTimeSlotTap;
  final void Function(Appointment) onAppointmentTap;

  const DayColumn({
    super.key,
    required this.day,
    required this.timeSlots,
    required this.slotHeight,
    required this.width,
    required this.isLastDay,
    required this.isFirstColumn,
    required this.storeHours,
    required this.appointments,
    required this.showOverlapCount,
    required this.onTimeSlotTap,
    required this.onAppointmentTap,
  });

  @override
  State<DayColumn> createState() => _DayColumnState();
}

class _DayColumnState extends State<DayColumn> {
  String? _hoverKey;

  @override
  Widget build(BuildContext context) {
    final open = _isOpen(widget.day, widget.storeHours);
    return SizedBox(
      width: widget.width,
      height: widget.timeSlots.length * widget.slotHeight,
      child: Stack(
        children: [
          // grid background
          Positioned.fill(
            child: Column(
              children: [
                for (final s in widget.timeSlots)
                  _GridCell(
                    slotHeight: widget.slotHeight,
                    isHour: s.minute == 0,
                    showRight: !widget.isLastDay,
                  ),
              ],
            ),
          ),
          if (open)
            StoreHoursLines(
              day: widget.day,
              timeSlots: widget.timeSlots,
              slotHeight: widget.slotHeight,
              isFirstColumn: widget.isFirstColumn,
              storeHours: widget.storeHours,
            ),
          if (open)
            for (final a in widget.appointments)
              AppointmentBlock(
                day: widget.day,
                appointment: a,
                timeSlots: widget.timeSlots,
                slotHeight: widget.slotHeight,
                onTap: () => widget.onAppointmentTap(a),
              ),
          if (open)
            Positioned.fill(
              child: Column(
                children: [
                  for (final s in widget.timeSlots)
                    _HoverTapCell(
                      day: widget.day,
                      slot: s,
                      slotHeight: widget.slotHeight,
                      hoverKey: _hoverKey,
                      onEnter: (k) => setState(() => _hoverKey = k),
                      onExit: () => setState(() => _hoverKey = null),
                      onTap: (dt) => widget.onTimeSlotTap(
                        selectedTime: dt,
                        selectedTechnicianId: null,
                      ),
                    ),
                ],
              ),
            ),
          if (open && widget.showOverlapCount)
            OverlapOverlay(
              day: widget.day,
              timeSlots: widget.timeSlots,
              slotHeight: widget.slotHeight,
              appointments: widget.appointments,
            ),
          if (!open)
            Positioned.fill(
              child: Container(
                color: const Color(0xFFE0E0E0),
                child: Center(
                  child: Text(
                    'CLOSED',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isOpen(DateTime d, StoreHours s) {
    final key = getDayKey(d.weekday);
    final h = s.hours[key];
    return h != null && h.isOpen;
  }
}

class _GridCell extends StatelessWidget {
  final double slotHeight;
  final bool isHour;
  final bool showRight;

  const _GridCell({
    required this.slotHeight,
    required this.isHour,
    required this.showRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: slotHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(
              alpha: isHour ? 0.3 : 0.1,
            ),
            width: isHour ? 1 : 0.5,
          ),
          right: showRight
              ? BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                )
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _HoverTapCell extends StatelessWidget {
  final DateTime day;
  final TimeSlot slot;
  final double slotHeight;
  final String? hoverKey;
  final void Function(String key) onEnter;
  final VoidCallback onExit;
  final void Function(DateTime dt) onTap;

  const _HoverTapCell({
    required this.day,
    required this.slot,
    required this.slotHeight,
    required this.hoverKey,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final k = '${day.millisecondsSinceEpoch}-${slot.hour}-${slot.minute}';
    final hovered = hoverKey == k;
    final dt = DateTime(
      day.year,
      day.month,
      day.day,
      slot.hour,
      slot.minute,
    );

    return MouseRegion(
      onEnter: (_) => onEnter(k),
      onExit: (_) => onExit(),
      child: InkWell(
        onTap: () => onTap(dt),
        hoverColor: Colors.transparent,
        child: Container(
          height: slotHeight,
          decoration: BoxDecoration(
            color: hovered
                ? AppColors.primaryBlue.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border(
              left: hovered
                  ? BorderSide(color: AppColors.primaryBlue, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: hovered
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${slot.hour.toString().padLeft(2, '0')}:'
                      '${slot.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                )
              : const SizedBox.expand(),
        ),
      ),
    );
  }
}
