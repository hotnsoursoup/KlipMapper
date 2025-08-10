// lib/features/calendar/presentation/widgets/current_time_overlay.dart
// Current time overlay widget for calendar grid displaying a real-time indicator line.
// Shows current time position with clock icon and horizontal line that updates every minute.
// Usage: ACTIVE - Time indicator overlay for calendar grids showing current time position

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../data/models/time_slot.dart';

class CurrentTimeOverlay extends StatelessWidget {
  const CurrentTimeOverlay({
    super.key,
    required this.scrollController,
    required this.firstSlot,
    required this.rowExtent,
    required this.nowListenable,
    required this.timeColumnWidth,
  });

  final ScrollController scrollController;
  final TimeSlot firstSlot;
  final double rowExtent;
  final ValueListenable<DateTime> nowListenable;
  final double timeColumnWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scrollController, nowListenable]),
      builder: (context, _) {
        final now = nowListenable.value;
        final firstSlotMinutes = firstSlot.totalMinutes;
        final nowMinutes = now.hour * 60 + now.minute;
        
        // Calculate Y position for current time line
        final y = ((nowMinutes - firstSlotMinutes) / 15.0) * rowExtent - 
                  (scrollController.hasClients ? scrollController.offset : 0.0);

        return Positioned(
          left: timeColumnWidth,
          right: 0,
          top: y.clamp(0.0, MediaQuery.sizeOf(context).height), // Clamp to viewport
          child: IgnorePointer(
            child: Row(
              children: [
                // Time indicator icon
                Container(
                  width: 24,
                  height: 18,
                  margin: const EdgeInsets.only(left: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.errorRed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                // Current time line
                Expanded(
                  child: Container(
                    height: 2,
                    color: AppColors.errorRed.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
