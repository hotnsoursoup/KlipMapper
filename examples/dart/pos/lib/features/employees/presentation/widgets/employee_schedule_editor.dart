// lib/features/employees/presentation/widgets/employee_schedule_editor.dart
// Employee work schedule editor widget with manager authentication and comprehensive time management.
// Allows managers to view and edit employee weekly schedules including work days, hours, and time-off periods.
// Usage: ACTIVE - Used in employee management screens for schedule configuration and display

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/auth/widgets/manager_auth_wrapper.dart';
import '../../../shared/data/repositories/drift_schedule_repository.dart';
import '../../../../utils/error_logger.dart';

class EmployeeScheduleEditor extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final Function(List<WeeklySchedule>)? onScheduleChanged;

  const EmployeeScheduleEditor({
    super.key,
    required this.employeeId,
    required this.employeeName,
    this.onScheduleChanged,
  });

  @override
  State<EmployeeScheduleEditor> createState() => _EmployeeScheduleEditorState();
}

class _EmployeeScheduleEditorState extends State<EmployeeScheduleEditor> {
  final _scheduleRepository = DriftScheduleRepository.instance;
  late List<WeeklySchedule> _weeklySchedule;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _daysOfWeek = [
    'monday',
    'tuesday', 
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaultSchedule();
    _loadEmployeeSchedule();
  }

  void _initializeDefaultSchedule() {
    _weeklySchedule = _daysOfWeek.map((day) {
      // Default: Monday-Friday working, Saturday-Sunday off
      if (day == 'saturday' || day == 'sunday') {
        return WeeklySchedule.dayOff(day);
      }
      return WeeklySchedule.defaultWorkingDay(day);
    }).toList();
  }

  Future<void> _loadEmployeeSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final schedules = await _scheduleRepository.getEmployeeSchedule(widget.employeeId);
      
      if (schedules.isNotEmpty) {
        // Convert database schedules to WeeklySchedule objects
        final scheduleMap = <String, WeeklySchedule>{};
        for (final schedule in schedules) {
          scheduleMap[schedule.dayOfWeek] = WeeklySchedule.fromDb(schedule);
        }
        
        // Merge with default schedule to ensure all days are present
        _weeklySchedule = _daysOfWeek.map((day) {
          return scheduleMap[day] ?? 
                 (day == 'saturday' || day == 'sunday' 
                  ? WeeklySchedule.dayOff(day) 
                  : WeeklySchedule.defaultWorkingDay(day));
        }).toList();
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error loading employee schedule', e, stack);
      setState(() {
        _errorMessage = 'Failed to load schedule.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showEditDialog() async {
    final authenticated = await ManagerAuthWrapper.authenticate(
      context: context,
      title: 'Edit Employee Schedule',
      description: 'Manager authorization is required to modify employee work schedules.',
      requesterEmployeeId: widget.employeeId,
    );

    if (authenticated && mounted) {
      _showScheduleEditDialog();
    }
  }

  void _showScheduleEditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 500,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Edit Schedule - ${widget.employeeName}',
                    style: AppTextStyles.headline2,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Schedule editor
              Expanded(
                child: SingleChildScrollView(
                  child: _buildScheduleEditor(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _saveSchedule(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Schedule'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _scheduleRepository.saveEmployeeSchedule(widget.employeeId, _weeklySchedule);
      widget.onScheduleChanged?.call(_weeklySchedule);
      
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Schedule saved for ${widget.employeeName}'),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error saving employee schedule', e, stack);
      setState(() {
        _errorMessage = 'Failed to save schedule. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateDaySchedule(int dayIndex, WeeklySchedule newSchedule) {
    setState(() {
      _weeklySchedule[dayIndex] = newSchedule;
    });
  }

  String _formatDayName(String day) {
    // Convert internal day names to proper display names
    const dayMap = {
      'monday': 'Monday',
      'tuesday': 'Tuesday', 
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',
    };
    return dayMap[day.toLowerCase()] ?? day[0].toUpperCase() + day.substring(1);
  }

  String _formatScheduleDisplay(WeeklySchedule schedule) {
    if (schedule.isScheduledOff) {
      return 'Off';
    }
    final start = schedule.startTime != null ? DriftScheduleRepository.formatTime(schedule.startTime!) : 'N/A';
    final end = schedule.endTime != null ? DriftScheduleRepository.formatTime(schedule.endTime!) : 'N/A';
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 18,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Work Schedule',
              style: AppTextStyles.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Schedule display
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _weeklySchedule.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: i < _weeklySchedule.length - 1 ? 6 : 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            _formatDayName(_weeklySchedule[i].dayOfWeek),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _formatScheduleDisplay(_weeklySchedule[i]),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _weeklySchedule[i].isScheduledOff 
                                ? AppColors.textSecondary 
                                : AppColors.textPrimary,
                            fontWeight: _weeklySchedule[i].isScheduledOff 
                                ? FontWeight.w400 
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // Edit button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showEditDialog,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Schedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),

        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorRed,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScheduleEditor() {
    return Column(
      children: [
        // Days of the week schedule
        for (int i = 0; i < _weeklySchedule.length; i++)
          _buildDayScheduleRow(i),
        
        // Error message in dialog
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorRed,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDayScheduleRow(int dayIndex) {
    final schedule = _weeklySchedule[dayIndex];
    final dayName = _formatDayName(schedule.dayOfWeek);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name and off switch
          Row(
            children: [
              Text(
                dayName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Day Off',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: schedule.isScheduledOff ? AppColors.primaryBlue : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: schedule.isScheduledOff,
                    onChanged: (isOff) {
                      _updateDaySchedule(
                        dayIndex,
                        schedule.copyWith(
                          isScheduledOff: isOff,
                          startTime: isOff ? null : (schedule.startTime ?? 540),
                          endTime: isOff ? null : (schedule.endTime ?? 1080),
                        ),
                      );
                    },
                    thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
                  ),
                ],
              ),
            ],
          ),
          
          // Time pickers (only shown if not scheduled off)
          if (!schedule.isScheduledOff) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    label: 'Start Time',
                    time: schedule.startTime,
                    onTimeChanged: (newTime) {
                      _updateDaySchedule(
                        dayIndex,
                        schedule.copyWith(startTime: newTime),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimePicker(
                    label: 'End Time',
                    time: schedule.endTime,
                    onTimeChanged: (newTime) {
                      _updateDaySchedule(
                        dayIndex,
                        schedule.copyWith(endTime: newTime),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required int? time,
    required Function(int?) onTimeChanged,
  }) {
    final timeString = time != null ? DriftScheduleRepository.formatTime(time) : 'Not Set';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _showTimePicker(time, onTimeChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  timeString,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker(int? currentTime, Function(int?) onTimeChanged) async {
    // Convert minutes to TimeOfDay
    TimeOfDay initialTime;
    if (currentTime != null) {
      final hour = currentTime ~/ 60;
      final minute = currentTime % 60;
      initialTime = TimeOfDay(hour: hour, minute: minute);
    } else {
      initialTime = const TimeOfDay(hour: 9, minute: 0); // Default to 9:00 AM
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Convert TimeOfDay back to minutes
      final minutes = picked.hour * 60 + picked.minute;
      onTimeChanged(minutes);
    }
  }
}