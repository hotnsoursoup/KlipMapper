// lib/features/calendar/presentation/widgets/calendar_skeleton_grid.dart
// Skeleton loading grid widget for calendar displaying placeholder rows while data loads.
// Provides visual feedback during loading states with alternating row patterns.
// Usage: ACTIVE - Loading state component for calendar grids

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CalendarSkeletonGrid extends StatelessWidget {
  const CalendarSkeletonGrid({
    super.key,
    required this.rowExtent,
    this.rowCount = 40,
  });

  final double rowExtent;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFixedExtentList(
          itemExtent: rowExtent,
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: index.isEven
                        ? AppColors.border.withValues(alpha: 0.4)
                        : AppColors.border.withValues(alpha: 0.2),
                    width: index.isEven ? 1.5 : 1,
                  ),
                ),
              ),
            ),
            childCount: rowCount,
          ),
        ),
      ],
    );
  }
}