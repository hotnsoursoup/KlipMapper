// lib/features/shared/presentation/widgets/date_range_picker.dart
// Date range picker component with quick selection buttons and custom range support.
// Features modal dialog interface, predefined date ranges, and flexible configuration options.
// Usage: ACTIVE - Used in reports and filtering screens for date-based data selection

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DateRangePicker extends StatefulWidget {
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTimeRange?> onRangeSelected;
  final bool showQuickSelectors;
  final double? width;

  const DateRangePicker({
    super.key,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    required this.onRangeSelected,
    this.showQuickSelectors = true,
    this.width,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _startDate = widget.initialRange!.start;
      _endDate = widget.initialRange!.end;
      _updateControllers();
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    if (_startDate != null) {
      _startController.text = _formatDate(_startDate!);
    }
    if (_endDate != null) {
      _endController.text = _formatDate(_endDate!);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDisplayText() {
    if (_startDate != null && _endDate != null) {
      return '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';
    } else if (_startDate != null) {
      return 'From ${_formatDate(_startDate!)}';
    } else {
      return 'Select date range';
    }
  }

  void _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          // If end date is before start date, clear it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _endController.clear();
          }
        } else {
          _endDate = date;
          // If start date is not set, set it to the same as end date
          if (_startDate == null) {
            _startDate = date;
            _startController.text = _formatDate(date);
          }
        }
        _updateControllers();
      });

      // Notify parent if both dates are selected
      if (_startDate != null && _endDate != null) {
        widget.onRangeSelected(DateTimeRange(start: _startDate!, end: _endDate!));
      }
    }
  }

  void _setQuickRange(int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    setState(() {
      if (days == 0) {
        // Today only
        _startDate = today;
        _endDate = today;
      } else {
        // Last X days
        _startDate = today.subtract(Duration(days: days));
        _endDate = today;
      }
      _updateControllers();
    });

    widget.onRangeSelected(DateTimeRange(start: _startDate!, end: _endDate!));
  }

  void _clearRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _startController.clear();
      _endController.clear();
    });
    widget.onRangeSelected(null);
  }

  void _showDateRangePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date Range',
                          style: AppTextStyles.headline3,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Quick selectors
                    if (widget.showQuickSelectors) ...[
                      Text(
                        'Quick Select',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildQuickButton('Today', () {
                            _setQuickRange(0);
                            Navigator.of(context).pop();
                          }),
                          _buildQuickButton('Last 7 days', () {
                            _setQuickRange(7);
                            Navigator.of(context).pop();
                          }),
                          _buildQuickButton('Last 30 days', () {
                            _setQuickRange(30);
                            Navigator.of(context).pop();
                          }),
                          _buildQuickButton('Last 90 days', () {
                            _setQuickRange(90);
                            Navigator.of(context).pop();
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],
                    // Custom range
                    Text(
                      'Custom Range',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Date inputs
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: AppTextStyles.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _startController,
                                readOnly: true,
                                onTap: () => _selectDate(true),
                                style: AppTextStyles.bodyMedium,
                                decoration: InputDecoration(
                                  hintText: 'Select start date',
                                  prefixIcon: const Icon(Icons.calendar_today, size: 18),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: AppTextStyles.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _endController,
                                readOnly: true,
                                onTap: () => _selectDate(false),
                                style: AppTextStyles.bodyMedium,
                                decoration: InputDecoration(
                                  hintText: 'Select end date',
                                  prefixIcon: const Icon(Icons.calendar_today, size: 18),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _clearRange();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: (_startDate != null && _endDate != null)
                              ? () {
                                  widget.onRangeSelected(
                                    DateTimeRange(start: _startDate!, end: _endDate!),
                                  );
                                  Navigator.of(context).pop();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showDateRangePicker,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                Icons.date_range,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _startDate != null ? AppColors.textPrimary : AppColors.textLight,
                  ),
                ),
              ),
              Icon(
                Icons.expand_more,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
      ),
      child: Text(label, style: AppTextStyles.labelMedium),
    );
  }
}