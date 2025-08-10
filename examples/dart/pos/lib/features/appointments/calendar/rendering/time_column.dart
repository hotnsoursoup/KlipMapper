// lib/features/appointments/presentation/widgets/time_column.dart
// Time column widget displaying hourly time labels for calendar grid with formatted time display.
// Shows time intervals with proper formatting and alignment for appointment grid layouts.
// Usage: ACTIVE - Time axis component for calendar grid showing hourly time markers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/calendar_theme.dart';

class TimeColumn extends StatelessWidget {
  final int startHour;
  final int endHour;
  final int intervalMinutes;
  final Function(DateTime)? onTimeSlotTap;

  const TimeColumn({
    super.key,
    this.startHour = 8,
    this.endHour = 20,
    this.intervalMinutes = 15,
    this.onTimeSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    
    return Container(
      width: CalendarTheme.timeColumnWidth,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
      ),
      child: Column(
        children: timeSlots.map((timeSlot) => _buildTimeSlot(timeSlot)).toList(),
      ),
    );
  }

  Widget _buildTimeSlot(TimeSlotInfo timeSlot) {
    final isCurrentTime = _isCurrentTime(timeSlot.time);
    final isHourMark = timeSlot.time.minute == 0;
    
    return Container(
      height: CalendarTheme.hourRowHeight / (60 / intervalMinutes),
      decoration: BoxDecoration(
        color: isCurrentTime 
            ? CalendarTheme.currentTimeLineColor.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: InkWell(
        onTap: onTimeSlotTap != null ? () => onTimeSlotTap!(timeSlot.time) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  timeSlot.displayText,
                  style: CalendarTheme.timeColumnTextStyle.copyWith(
                    color: isCurrentTime 
                        ? CalendarTheme.currentTimeLineColor
                        : CalendarTheme.timeColumnTextStyle.color,
                    fontWeight: isCurrentTime || isHourMark
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              if (isCurrentTime)
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: CalendarTheme.currentTimeLineColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<TimeSlotInfo> _generateTimeSlots() {
    final slots = <TimeSlotInfo>[];
    final totalMinutes = (endHour - startHour) * 60;
    final now = DateTime.now();
    
    for (int minutes = 0; minutes < totalMinutes; minutes += intervalMinutes) {
      final hour = startHour + (minutes ~/ 60);
      final minute = minutes % 60;
      
      final time = DateTime(now.year, now.month, now.day, hour, minute);
      final displayText = _formatTime(time, minute == 0);
      
      slots.add(TimeSlotInfo(
        time: time,
        displayText: displayText,
        isHourMark: minute == 0,
      ),);
    }
    
    return slots;
  }

  String _formatTime(DateTime time, bool isHourMark) {
    if (isHourMark) {
      // Show full time for hour marks (e.g., "9:00 AM")
      return DateFormat.jm().format(time);
    } else {
      // Show just minutes for quarter hours (e.g., ":15", ":30", ":45")
      return ':${time.minute.toString().padLeft(2, '0')}';
    }
  }

  bool _isCurrentTime(DateTime time) {
    final now = DateTime.now();
    final currentRoundedTime = DateTime(
      now.year, 
      now.month, 
      now.day, 
      now.hour, 
      (now.minute ~/ intervalMinutes) * intervalMinutes,
    );
    
    return time.isAtSameMomentAs(currentRoundedTime);
  }
}

class TimeSlotInfo {
  final DateTime time;
  final String displayText;
  final bool isHourMark;

  const TimeSlotInfo({
    required this.time,
    required this.displayText,
    required this.isHourMark,
  });
}
