// lib/features/reports/presentation/widgets/report_time_range_selector.dart
// Time range selector widget for filtering reports by different date periods with custom range support.
// Provides predefined time ranges and custom date picker integration for flexible report date filtering.
// Usage: ACTIVE - Used in report screens for temporal filtering of report data

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/presentation/widgets/date_range_picker.dart';
import '../../data/models/report_data.dart';

/// Time range selector for reports
/// Follows UI Bible principles: const constructors, RepaintBoundary
class ReportTimeRangeSelector extends StatelessWidget {
  final ReportTimeRange selectedRange;
  final ValueChanged<ReportTimeRange> onRangeChanged;
  final Function(DateTime startDate, DateTime endDate) onCustomRangeSelected;

  const ReportTimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.onCustomRangeSelected,
  });

  static const List<ReportTimeRange> _availableRanges = [
    ReportTimeRange.today,
    ReportTimeRange.yesterday,
    ReportTimeRange.thisWeek,
    ReportTimeRange.lastWeek,
    ReportTimeRange.thisMonth,
    ReportTimeRange.lastMonth,
    ReportTimeRange.thisYear,
    ReportTimeRange.custom,
  ];

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: _availableRanges.map((range) {
          final isSelected = selectedRange == range;
          return _TimeRangeChip(
            range: range,
            isSelected: isSelected,
            onTap: () => _handleRangeSelection(context, range),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _handleRangeSelection(BuildContext context, ReportTimeRange range) async {
    if (range == ReportTimeRange.custom) {
      final result = await showDialog<DateTimeRange?>(
        context: context,
        builder: (context) => DateRangePicker(
          onRangeSelected: (range) {
            Navigator.of(context).pop(range);
          },
        ),
      );
      
      if (result != null) {
        onCustomRangeSelected(result.start, result.end);
      }
    } else {
      onRangeChanged(range);
    }
  }
}

class _TimeRangeChip extends StatelessWidget {
  final ReportTimeRange range;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeRangeChip({
    required this.range,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: isSelected 
            ? AppColors.primaryBlue 
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 2 : 0,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primaryBlue 
                    : AppColors.border,
                width: 1,
              ),
            ),
            child: Text(
              _getRangeLabel(),
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected 
                    ? Colors.white 
                    : AppColors.textSecondary,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRangeLabel() {
    switch (range) {
      case ReportTimeRange.today:
        return 'Today';
      case ReportTimeRange.yesterday:
        return 'Yesterday';
      case ReportTimeRange.thisWeek:
        return 'This Week';
      case ReportTimeRange.lastWeek:
        return 'Last Week';
      case ReportTimeRange.thisMonth:
        return 'This Month';
      case ReportTimeRange.lastMonth:
        return 'Last Month';
      case ReportTimeRange.thisYear:
        return 'This Year';
      case ReportTimeRange.custom:
        return 'Custom Range';
    }
  }
}