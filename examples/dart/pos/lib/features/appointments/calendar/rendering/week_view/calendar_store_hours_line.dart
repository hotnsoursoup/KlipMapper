import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/models/setting_model.dart';
import 'calendar_week_constants.dart';

class StoreHoursLines extends StatelessWidget {
  final DateTime day;
  final List<TimeSlot> timeSlots;
  final double slotHeight;
  final bool isFirstColumn;
  final StoreHours storeHours;

  const StoreHoursLines({
    super.key,
    required this.day,
    required this.timeSlots,
    required this.slotHeight,
    required this.isFirstColumn,
    required this.storeHours,
  });

  @override
  Widget build(BuildContext context) {
    final key = getDayKey(day.weekday);
    final h = storeHours.hours[key];
    if (h == null || !h.isOpen) return const SizedBox.shrink();

    final open = h.openTime ?? 540; // 09:00
    final close = h.closeTime ?? 1140; // 19:00

    final firstMin = timeSlots.first.hour * 60 + timeSlots.first.minute;
    final openPos = ((open - firstMin) / 15) * slotHeight;
    final closePos = ((close - firstMin) / 15) * slotHeight;
    final totalH = timeSlots.length * slotHeight;

    return SizedBox(
      height: totalH,
      child: Stack(
        children: [
          if (openPos >= 0 && openPos <= totalH) ...[
            if (isFirstColumn)
              Positioned(
                top: openPos - 12,
                left: 4,
                child: _pill('Store Open', AppColors.successGreen),
              ),
            Positioned(
              top: openPos,
              left: 0,
              right: 0,
              child: _line(
                color: AppColors.successGreen,
                label: isFirstColumn
                    ? 'OPEN ${_fmt(open)}'
                    : null,
              ),
            ),
          ],
          if (closePos >= 0 && closePos <= totalH) ...[
            Positioned(
              top: closePos,
              left: 0,
              right: 0,
              child: _line(
                color: AppColors.errorRed,
                label: isFirstColumn
                    ? 'CLOSE ${_fmt(close)}'
                    : null,
              ),
            ),
            if (isFirstColumn)
              Positioned(
                top: closePos + 4,
                left: 4,
                child: _pill('Store Closed', AppColors.errorRed),
              ),
          ],
        ],
      ),
    );
  }

  String _fmt(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final mm = m == 0 ? '' : ':${m.toString().padLeft(2, '0')}';
    final p = h >= 12 ? 'PM' : 'AM';
    final hr = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hr$mm$p';
  }

  Widget _line({required Color color, String? label}) {
    return Container(
      height: 2,
      color: color.withValues(alpha: 0.8),
      child: Row(
        children: [
          if (label != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Expanded(child: Container(height: 2, color: color)),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
