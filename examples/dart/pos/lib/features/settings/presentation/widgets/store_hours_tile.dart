// lib/features/settings/presentation/widgets/store_hours_tile.dart
// Store hours configuration tile that opens the store hours dialog when tapped
// Usage: ACTIVE - Provides store hours configuration functionality from original settings screen
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StoreHoursTile extends StatelessWidget {
  final String summary;
  final Function(String) onSaveJson;

  const StoreHoursTile({
    super.key,
    required this.summary,
    required this.onSaveJson,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        'Store Hours',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        summary,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () => _showStoreHoursDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Configure'),
      ),
    );
  }

  void _showStoreHoursDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _StoreHoursConfigDialog(
        // TODO: Parse store hours from settings JSON
        initialStoreHours: const StoreHours(),
        onSave: (storeHours) {
          // TODO: Convert to JSON and save
          onSaveJson(storeHours.toJson());
        },
      ),
    );
  }
}

// Store Hours Models (extracted from original implementation)
class StoreHours {
  final Map<String, DayHours> hours;

  const StoreHours({this.hours = const {}});

  String toJson() {
    // TODO: Implement JSON serialization
    return '{}';
  }
}

class DayHours {
  final bool isOpen;
  final int? openTime; // Minutes since midnight
  final int? closeTime; // Minutes since midnight

  const DayHours({
    this.isOpen = false,
    this.openTime,
    this.closeTime,
  });

  DayHours copyWith({
    bool? isOpen,
    int? openTime,
    int? closeTime,
  }) {
    return DayHours(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  String? get openTimeDisplay => openTime != null ? minutesToDisplay(openTime!) : null;
  String? get closeTimeDisplay => closeTime != null ? minutesToDisplay(closeTime!) : null;

  static String minutesToDisplay(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  static int displayToMinutes(String display) {
    final parts = display.split(' ');
    final isPM = parts[1] == 'PM';
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return hour * 60 + minute;
  }
}

// Store Hours Configuration Dialog (extracted from original implementation)
class _StoreHoursConfigDialog extends StatefulWidget {
  final StoreHours initialStoreHours;
  final Function(StoreHours) onSave;

  const _StoreHoursConfigDialog({
    required this.initialStoreHours,
    required this.onSave,
  });

  @override
  State<_StoreHoursConfigDialog> createState() => _StoreHoursConfigDialogState();
}

class _StoreHoursConfigDialogState extends State<_StoreHoursConfigDialog> {
  late Map<String, DayHours> _hours;
  String _selectedOpenTime = '9:00 AM';
  String _selectedCloseTime = '6:00 PM';
  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  // Generate time options dynamically
  List<String> get _timeOptions {
    final options = <String>[];
    // From 6:00 AM to 10:00 PM in 30-minute intervals
    for (int hour = 6; hour <= 22; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final totalMinutes = hour * 60 + minute;
        options.add(DayHours.minutesToDisplay(totalMinutes));
      }
    }
    return options;
  }

  @override
  void initState() {
    super.initState();
    _hours = Map.from(widget.initialStoreHours.hours);

    // Initialize selected times from the first open day
    for (final day in _days) {
      final dayLower = day.toLowerCase();
      final dayHours = _hours[dayLower];
      if (dayHours != null && dayHours.isOpen && dayHours.openTime != null && dayHours.closeTime != null) {
        _selectedOpenTime = DayHours.minutesToDisplay(dayHours.openTime!);
        _selectedCloseTime = DayHours.minutesToDisplay(dayHours.closeTime!);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Configure Store Hours',
        style: AppTextStyles.headline2.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: 650,
        height: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Apply to all days section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Setup',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Open Time',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              initialValue: _selectedOpenTime,
                              items: _timeOptions.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedOpenTime = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Close Time',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              initialValue: _selectedCloseTime,
                              items: _timeOptions.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCloseTime = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Empty space to match the label height
                          SizedBox(
                            height: AppTextStyles.bodySmall.fontSize! + 4,
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _applyToAllDays(_selectedOpenTime, _selectedCloseTime),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Apply to All'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Individual Day Settings',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index].toLowerCase();
                  final dayHours = _hours[day] ?? const DayHours();
                  return _buildDayRow(day, dayHours);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final storeHours = StoreHours(hours: _hours);
            widget.onSave(storeHours);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildDayRow(String day, DayHours dayHours) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day.substring(0, 1).toUpperCase() + day.substring(1),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: dayHours.isOpen,
            onChanged: (value) {
              setState(() {
                _hours[day] = dayHours.copyWith(isOpen: value);
              });
            },
            thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          if (dayHours.isOpen) ...[
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  isDense: true,
                ),
                initialValue: dayHours.openTimeDisplay ?? '9:00 AM',
                items: _timeOptions.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _hours[day] = dayHours.copyWith(
                        openTime: DayHours.displayToMinutes(value),
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('to', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  isDense: true,
                ),
                initialValue: dayHours.closeTimeDisplay ?? '6:00 PM',
                items: _timeOptions.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _hours[day] = dayHours.copyWith(
                        closeTime: DayHours.displayToMinutes(value),
                      );
                    });
                  }
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: Text(
                'Closed',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _applyToAllDays(String openTime, String closeTime) {
    setState(() {
      for (final day in _days.map((d) => d.toLowerCase())) {
        _hours[day] = DayHours(
          isOpen: true,
          openTime: DayHours.displayToMinutes(openTime),
          closeTime: DayHours.displayToMinutes(closeTime),
        );
      }
    });
  }
}
