import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'calendar_week_constants.dart';

class WeekHeader extends StatelessWidget {
  final List<DateTime> weekDays;
  final double dayWidth;
  final double timeColWidth;
  final double headerHeight;

  const WeekHeader({
    super.key,
    required this.weekDays,
    required this.dayWidth,
    required this.timeColWidth,
    required this.headerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: timeColWidth,
            child: Center(
              child: Text(
                'Time',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          for (var i = 0; i < weekDays.length; i++)
            _DayHeaderCell(
              day: weekDays[i],
              width: dayWidth,
              isLast: i == weekDays.length - 1,
            ),
        ],
      ),
    );
  }
}

class _DayHeaderCell extends StatelessWidget {
  final DateTime day;
  final double width;
  final bool isLast;

  const _DayHeaderCell({
    required this.day,
    required this.width,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = sameDay(day, DateTime.now());
    const names = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final label = names[day.weekday - 1];

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isToday
                  ? AppColors.primaryBlue
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.month}/${day.day}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: isToday
                  ? AppColors.primaryBlue
                  : AppColors.textPrimary,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
