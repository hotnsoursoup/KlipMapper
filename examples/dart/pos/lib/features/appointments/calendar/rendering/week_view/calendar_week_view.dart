import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../settings/providers/settings_provider.dart';
import '../../../../shared/data/models/appointment_model.dart' show Appointment;
import '../../../../shared/data/models/setting_model.dart';
import '../../../domain/providers/appointment_providers.dart';
import 'calendar_day_column.dart';
import 'calendar_time_column.dart';
import 'calendar_week_constants.dart';
import 'calendar_week_view_header.dart';

class AppointmentWeekView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final void Function(Appointment) onAppointmentTap;
  final void Function({
    DateTime? selectedTime,
    String? selectedTechnicianId,
  }) onTimeSlotTap;
  final Set<String> selectedServiceCategories;
  final bool showOverlapCount;
  final bool anchorToToday;

  const AppointmentWeekView({
    super.key,
    required this.selectedDate,
    required this.onAppointmentTap,
    required this.onTimeSlotTap,
    this.selectedServiceCategories = const {},
    this.showOverlapCount = false,
    this.anchorToToday = false,
  });

  @override
  ConsumerState<AppointmentWeekView> createState() =>
      _AppointmentWeekViewState();
}

class _AppointmentWeekViewState
    extends ConsumerState<AppointmentWeekView> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(storeHoursSettingProvider);

    final weekStart = widget.anchorToToday
        ? DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )
        : getWeekStart(widget.selectedDate);

    final weekAsync = ref.watch(
      weekAppointmentsForCalendarStreamProvider(weekStart),
    );
    final week = weekAsync.value ?? <Appointment>[];

    final endHour = endHourFromSettings(settings);
    final timeSlots = buildQuarterHourSlots(7, endHour);
    final weekDays =
        List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final dayW = (c.maxWidth - kTimeColWidth) / 7;
                return Column(
                  children: [
                    WeekHeader(
                      weekDays: weekDays,
                      dayWidth: dayW,
                      timeColWidth: kTimeColWidth,
                      headerHeight: kHeaderHeight,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scroll,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TimeColumn(
                              timeSlots: timeSlots,
                              width: kTimeColWidth,
                              slotHeight: kSlotH,
                            ),
                            for (var i = 0; i < weekDays.length; i++)
                              DayColumn(
                                day: weekDays[i],
                                timeSlots: timeSlots,
                                slotHeight: kSlotH,
                                width: dayW,
                                isLastDay: i == weekDays.length - 1,
                                isFirstColumn: i == 0,
                                storeHours: settings,
                                appointments: dayAppointments(
                                  weekDays[i],
                                  week,
                                ),
                                showOverlapCount: widget.showOverlapCount,
                                onTimeSlotTap: widget.onTimeSlotTap,
                                onAppointmentTap: widget.onAppointmentTap,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
