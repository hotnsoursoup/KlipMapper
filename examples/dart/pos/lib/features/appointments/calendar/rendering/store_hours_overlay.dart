// lib/features/calendar/presentation/widgets/store_hours_overlay.dart
// Store hours overlay widget for calendar grid displaying opening and closing time indicators.
// Shows horizontal lines and labels for store open/close times with scrolling synchronization.
// Usage: ACTIVE - Overlay component for displaying business hours on calendar grids

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../data/models/time_slot.dart';

class StoreHoursOverlay extends StatelessWidget {
  const StoreHoursOverlay({
    super.key,
    required this.scrollController,
    required this.firstSlot,
    required this.rowExtent,
    required this.openMinutes,
    required this.closeMinutes,
    required this.timeColumnWidth,
  });

  final ScrollController scrollController;
  final TimeSlot firstSlot;
  final double rowExtent;
  final int openMinutes;
  final int closeMinutes;
  final double timeColumnWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: StoreHoursPainter(
                scrollOffset: scrollController.hasClients ? scrollController.offset : 0.0,
                firstSlot: firstSlot,
                rowExtent: rowExtent,
                openMinutes: openMinutes,
                closeMinutes: closeMinutes,
                timeColumnWidth: timeColumnWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoreHoursPainter extends CustomPainter {
  StoreHoursPainter({
    required this.scrollOffset,
    required this.firstSlot,
    required this.rowExtent,
    required this.openMinutes,
    required this.closeMinutes,
    required this.timeColumnWidth,
  });

  final double scrollOffset;
  final TimeSlot firstSlot;
  final double rowExtent;
  final int openMinutes;
  final int closeMinutes;
  final double timeColumnWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final firstSlotMinutes = firstSlot.totalMinutes;
    
    // Calculate Y positions for open and close lines
    final openY = ((openMinutes - firstSlotMinutes) / 15.0) * rowExtent - scrollOffset;
    final closeY = ((closeMinutes - firstSlotMinutes) / 15.0) * rowExtent - scrollOffset;

    const greenColor = AppColors.successGreen;
    const redColor = AppColors.errorRed;

    // Clamp positions to visible area
    final clampedOpenY = openY.clamp(0.0, size.height);
    final clampedCloseY = closeY.clamp(0.0, size.height);

    final lineLeft = timeColumnWidth;
    final lineRight = size.width;

    // Draw OPEN line and tag
    _drawTaggedLine(
      canvas,
      y: clampedOpenY,
      left: lineLeft,
      right: lineRight,
      tag: 'OPEN ${_formatTime(openMinutes)}',
      color: greenColor,
    );

    // Draw CLOSE line and tag
    _drawTaggedLine(
      canvas,
      y: clampedCloseY,
      left: lineLeft,
      right: lineRight,
      tag: 'CLOSE ${_formatTime(closeMinutes)}',
      color: redColor,
    );
  }

  /// Draw a horizontal line with a colored tag label
  void _drawTaggedLine(
    Canvas canvas, {
    required double y,
    required double left,
    required double right,
    required String tag,
    required Color color,
  }) {
    // Draw the line
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(left, y), Offset(right, y), linePaint);

    // Create and layout text painter for the tag
    final textPainter = _buildTextPainter(
      tag,
      const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.w600,
      ),
    );

    // Draw tag background
    final tagBackground = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + 4,
        y - 10,
        textPainter.width + 8,
        textPainter.height + 2,
      ),
      const Radius.circular(3),
    );
    
    final backgroundPaint = Paint()..color = color;
    canvas.drawRRect(tagBackground, backgroundPaint);

    // Draw tag text
    textPainter.paint(canvas, Offset(left + 8, y - 10 + 1));
  }

  /// Create a configured TextPainter for rendering text
  TextPainter _buildTextPainter(String text, TextStyle style) {
    return TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  /// Format minutes since midnight as 12-hour time string
  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final displayHour = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    final period = hours >= 12 ? 'PM' : 'AM';
    final minuteStr = mins == 0 ? '' : ':${mins.toString().padLeft(2, '0')}';
    return '$displayHour$minuteStr$period';
  }

  @override
  bool shouldRepaint(covariant StoreHoursPainter oldDelegate) =>
      oldDelegate.scrollOffset != scrollOffset ||
      oldDelegate.firstSlot != firstSlot ||
      oldDelegate.openMinutes != openMinutes ||
      oldDelegate.closeMinutes != closeMinutes ||
      oldDelegate.rowExtent != rowExtent ||
      oldDelegate.timeColumnWidth != timeColumnWidth;
}
