// lib/features/appointments/presentation/screens/calendar_screen.dart
// Advanced calendar screen with day/week/chart views, filtering, and full appointment management.
// Usage: ACTIVE - Main calendar interface for appointment scheduling and management

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/service_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../calendar/rendering/appointment_calendar_grid.dart';
import '../../calendar/rendering/week_view/calendar_week_view.dart';
import '../../calendar/widgets/appointment_week_chart_view.dart';
import '../../domain/providers/appointment_providers.dart'; // selectedDate, view mode, streams, repo provider
import '../../data/models/calendar_view_mode.dart';
import '../widgets/appointments_dialog.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final Set<String> _selectedServiceCategories = {};
  bool _showOverlapCount = false;
  bool _anchorToToday = false;
  int _currentTechnicianPage = 0;

  @override
  void initState() {
    super.initState();
    // NOTE: no manual _loadData()/invalidate needed — stream provider reacts to selectedDate changes.
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Watch view state so the filter bar and nav controls rebuild correctly
    final viewMode = ref.watch(appointmentViewModeProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Filter / toolbar row ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildViewModeSelector(), // reads provider internally

                const SizedBox(width: 16),

                // Today
                TextButton(
                  onPressed: _goToToday,
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                  child: const Text('Today'),
                ),

                // Date nav (week vs day)
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: (viewMode == CalendarViewMode.week || viewMode == CalendarViewMode.weekChart)
                      ? _previousWeek
                      : _previousDay,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: (viewMode == CalendarViewMode.week || viewMode == CalendarViewMode.weekChart)
                      ? _nextWeek
                      : _nextDay,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),

                const SizedBox(width: 8),

                // Date picker (clickable label)
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        // Slightly styled dialog — no visual change to content
                        return Theme(
                          data: Theme.of(context).copyWith(
                            dialogTheme: const DialogTheme(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                          child: Transform.scale(scale: 1.2, child: child),
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        ref.read(selectedDateProvider.notifier).setDate(picked);
                        // Disable anchor to today when user picks a date manually
                        if (_anchorToToday) _anchorToToday = false;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      _formatDate(selectedDate),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),

                // Week <-> Chart toggle
                if (viewMode == CalendarViewMode.week) ...[
                  const SizedBox(width: 16),
                  _buildWeekViewModeButton('Chart', CalendarViewMode.weekChart, Icons.bar_chart),
                ] else if (viewMode == CalendarViewMode.weekChart) ...[
                  const SizedBox(width: 16),
                  _buildWeekViewModeButton('Week', CalendarViewMode.week, Icons.calendar_view_week),
                ],

                // Day-only: show service filters
                if (viewMode == CalendarViewMode.day) ...[
                  const Spacer(),
                  ...ServiceCategories.getAllCategories()
                      .where((c) => c.id != 'other')
                      .take(8)
                      .expand((category) => [
                            _buildServiceFilterChip(category.displayName, category.id, category.color),
                            const SizedBox(width: 8),
                          ]),
                ] else ...[
                  const Spacer(),
                ],

                const SizedBox(width: 8),

                // Week view toggles (anchor to today, overlap count)
                if (viewMode == CalendarViewMode.week || viewMode == CalendarViewMode.weekChart) ...[
                  Row(
                    children: [
                      Checkbox(
                        value: _anchorToToday,
                        onChanged: (value) {
                          setState(() {
                            _anchorToToday = value ?? false;
                            if (_anchorToToday) {
                              ref.read(selectedDateProvider.notifier).setDate(DateTime.now());
                            }
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text('Anchor to Today', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _showOverlapCount,
                        onChanged: (value) => setState(() => _showOverlapCount = value ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text('Show Overlap Count', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],

                const SizedBox(width: 16),

                // New appointment button
                ElevatedButton.icon(
                  onPressed: _showNewAppointmentDialog,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: AppColors.border),

          // ── Calendar content (reactive to selectedDate + streams) ───────────
          Expanded(child: _buildCalendarContent(selectedDate, viewMode)),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(DateTime selectedDate, CalendarViewMode viewMode) {
    return AsyncValueWidget.fromProvider(
      provider: selectedDateAppointmentsStreamProvider,
      data: (context, appointments, isRefreshing) {
        if (viewMode == CalendarViewMode.week) {
          return AppointmentWeekView(
            selectedDate: selectedDate,
            onAppointmentTap: _showAppointmentDetails,
            onTimeSlotTap: _showNewAppointmentDialog,
            selectedServiceCategories: _selectedServiceCategories,
            showOverlapCount: _showOverlapCount,
            anchorToToday: _anchorToToday,
          );
        } else if (viewMode == CalendarViewMode.weekChart) {
          return AppointmentWeekChartView(
            selectedDate: selectedDate,
            onAppointmentTap: _showAppointmentDetails,
            anchorToToday: _anchorToToday,
          );
        } else {
          // Day view
          return AppointmentCalendarGrid(
            currentPage: _currentTechnicianPage,
            onAppointmentTap: _showAppointmentDetails,
            onTimeSlotTap: _showNewAppointmentDialog,
            onPageChanged: (newPage) => setState(() => _currentTechnicianPage = newPage),
            selectedServiceCategories: _selectedServiceCategories,
          );
        }
      },
      error: (context, error, stack) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
              const SizedBox(height: 16),
              Text('Failed to load appointments', style: AppTextStyles.headline3),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Trigger a re-listen; since stream is keyed on selectedDate, a quick invalidate is okay:
                  ref.invalidate(selectedDateAppointmentsStreamProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewModeSelector() {
    final viewMode = ref.watch(appointmentViewModeProvider);
    return SegmentedButton<CalendarViewMode>(
      segments: const [
        ButtonSegment(value: CalendarViewMode.day,  label: Text('Day'),  icon: Icon(Icons.calendar_view_day)),
        ButtonSegment(value: CalendarViewMode.week, label: Text('Week'), icon: Icon(Icons.calendar_view_week)),
      ],
      selected: {viewMode},
      onSelectionChanged: (Set<CalendarViewMode> s) {
        ref.read(appointmentViewModeProvider.notifier).setViewMode(s.first);
      },
    );
  }

  Widget _buildWeekViewModeButton(String label, CalendarViewMode targetMode, IconData icon) {
    return TextButton.icon(
      onPressed: () {
        ref.read(appointmentViewModeProvider.notifier).setViewMode(targetMode);
      },
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
    );
  }

  void _goToToday() {
    ref.read(selectedDateProvider.notifier).setDate(DateTime.now());
  }

  void _previousDay() {
    final currentDate = ref.read(selectedDateProvider);
    ref.read(selectedDateProvider.notifier).setDate(currentDate.subtract(const Duration(days: 1)));
  }

  void _nextDay() {
    final currentDate = ref.read(selectedDateProvider);
    ref.read(selectedDateProvider.notifier).setDate(currentDate.add(const Duration(days: 1)));
  }

  void _previousWeek() {
    final currentDate = ref.read(selectedDateProvider);
    ref.read(selectedDateProvider.notifier).setDate(currentDate.subtract(const Duration(days: 7)));
    if (_anchorToToday) setState(() => _anchorToToday = false);
  }

  void _nextWeek() {
    final currentDate = ref.read(selectedDateProvider);
    ref.read(selectedDateProvider.notifier).setDate(currentDate.add(const Duration(days: 7)));
    if (_anchorToToday) setState(() => _anchorToToday = false);
  }

  Widget _buildServiceFilterChip(String label, String category, Color categoryColor) {
    final isSelected = _selectedServiceCategories.contains(category);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : categoryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedServiceCategories.add(category);
          } else {
            _selectedServiceCategories.remove(category);
          }
        });
      },
      backgroundColor: categoryColor.withValues(alpha: 0.1),
      selectedColor: categoryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(color: categoryColor.withValues(alpha: 0.3)),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AppointmentDialog.edit(
        appointment: appointment,
        onSave: (updated) async => _saveUpdatedAppointment(updated),
        onCancel: (reason) async => _cancelAppointment(appointment, reason),
      ),
    );
  }

  void _showNewAppointmentDialog({
    DateTime? selectedTime,
    String? selectedTechnicianId,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final selectedDate = ref.read(selectedDateProvider);
        return AppointmentDialog.fromCalendar(
          selectedDate: selectedTime ?? selectedDate,
          selectedTime: TimeOfDay.fromDateTime(selectedTime ?? DateTime.now()),
          technicianId: selectedTechnicianId ?? '',
          onSave: (appointment) async => _saveNewAppointment(appointment),
        );
      },
    );
  }

  Future<void> _saveNewAppointment(Appointment appointment) async {
    try {
      final repo = ref.read(appointmentRepositoryProvider);
      await repo.initialize();
      await repo.createAppointment(appointment);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment scheduled for ${appointment.customer?.name ?? "customer"}'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      // Stream will emit; no manual invalidate necessary.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scheduling appointment: $e'), backgroundColor: AppColors.errorRed),
      );
    }
  }

  Future<void> _saveUpdatedAppointment(Appointment appointment) async {
    try {
      if (appointment.services == null || appointment.services!.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment must have at least one service'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      final repo = ref.read(appointmentRepositoryProvider);
      await repo.initialize();
      await repo.updateAppointment(appointment);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment updated for ${appointment.customer?.name ?? "customer"}'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      // Stream will emit; no manual invalidate necessary.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating appointment: $e'), backgroundColor: AppColors.errorRed),
      );
    }
  }

  Future<void> _cancelAppointment(Appointment appointment, String reason) async {
    try {
      final repo = ref.read(appointmentRepositoryProvider);
      await repo.initialize();
      final cancelled = appointment.copyWith(
        status: 'cancelled',
        notes: appointment.notes != null
            ? '${appointment.notes}\n\nCancellation reason: $reason'
            : 'Cancellation reason: $reason',
      );
      await repo.updateAppointment(cancelled);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment cancelled for ${appointment.customer?.name ?? "customer"}'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      // Stream will emit; no manual invalidate necessary.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling appointment: $e'), backgroundColor: AppColors.errorRed),
      );
    }
  }
}
