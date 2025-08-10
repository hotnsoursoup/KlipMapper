// lib/features/appointments/presentation/widgets/appointment_week_grid_view.dart
// Optimized: synced header/body scroll, custom-painted grid, single provider reads, no duplicate TimeSlot class.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/providers/appointment_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../utils/calendar_helpers.dart';

class AppointmentWeekGridView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final Function(Appointment) onAppointmentTap;
  final Function({DateTime? selectedTime, String? selectedTechnicianId})
  onTimeSlotTap;
  final Set<String> selectedServiceCategories;
  final bool anchorToToday;

  const AppointmentWeekGridView({
    super.key,
    required this.selectedDate,
    required this.onAppointmentTap,
    required this.onTimeSlotTap,
    this.selectedServiceCategories = const {},
    this.anchorToToday = false,
  });

  @override
  ConsumerState<AppointmentWeekGridView> createState() =>
      _AppointmentWeekGridViewState();
}

class _AppointmentWeekGridViewState
    extends ConsumerState<AppointmentWeekGridView> {
  final ScrollController _hScroll = ScrollController();

  static const double _dayRowHeight = 100;
  static const double _timeColumnWidth = 45; // width per 30m slot
  static const double _leftDayLabelWidth = 120;
  static const double _headerHeight = 60;

  late final List<TimeSlot> _timeSlots;

  @override
  void initState() {
    super.initState();
    // 7:00 → 22:00 (30m)
    _timeSlots = [
      for (int h = 7; h < 22; h++) ...[
        TimeSlot(hour: h, minute: 0),
        TimeSlot(hour: h, minute: 30),
      ],
    ];
  }

  @override
  void dispose() {
    _hScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = widget.anchorToToday
        ? DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )
        : _getWeekStart(widget.selectedDate);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final dateRange = DateTimeRange(start: weekStart, end: weekEnd);

    // Watch once here; don’t watch deep inside rows
    final storeHoursValue = ref.watch(storeHoursSettingProvider).valueOrNull;

    final appointmentsAsync = ref.watch(
      appointmentsByDateRangeForCalendarProvider(dateRange),
    );

    return appointmentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) =>
          Center(child: Text('Error loading appointments: $err')),
      data: (appointments) {
        final weekDays = List.generate(
          7,
          (i) => weekStart.add(Duration(days: i)),
        );

        return DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.background),
          child: Column(
            children: [
              // ---------------- Header ----------------
              SizedBox(
                height: _headerHeight,
                child: Row(
                  children: [
                    // Corner cell
                    SizedBox(
                      width: _leftDayLabelWidth,
                      child: Center(
                        child: Text(
                          'Day / Time',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    // Time headers (scrolls with grid)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _hScroll,
                        physics: const ClampingScrollPhysics(),
                        child: Row(
                          children: _timeSlots.map(_buildTimeHeader).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- Body ----------------
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day labels (fixed)
                    SizedBox(
                      width: _leftDayLabelWidth,
                      child: ListView.builder(
                        itemCount: weekDays.length,
                        itemBuilder: (_, i) => _buildDayLabel(weekDays[i]),
                      ),
                    ),

                    // Grid+appointments (horizontally scrollable, synced)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _hScroll, // same controller as header
                        physics: const ClampingScrollPhysics(),
                        child: SizedBox(
                          width: _timeSlots.length * _timeColumnWidth,
                          child: ListView.builder(
                            itemCount: weekDays.length,
                            itemBuilder: (_, rowIndex) {
                              final day = weekDays[rowIndex];
                              final isFirstRow = rowIndex == 0;
                              final dayAppts = _getAppointmentsForDay(
                                day,
                                appointments,
                              );

                              final dayHours = _getDayHours(
                                storeHoursValue,
                                day,
                              );
                              final isOpen = dayHours?.isOpen ?? false;
                              final openMinutes =
                                  dayHours?.openTime ?? 540; // 9:00 fallback
                              final closeMinutes =
                                  dayHours?.closeTime ?? 1140; // 19:00 fallback

                              return SizedBox(
                                height: _dayRowHeight,
                                width: _timeSlots.length * _timeColumnWidth,
                                child: Stack(
                                  children: [
                                    // Background grid (painted, cheap)
                                    RepaintBoundary(
                                      child: CustomPaint(
                                        size: Size(
                                          _timeSlots.length * _timeColumnWidth,
                                          _dayRowHeight,
                                        ),
                                        painter: _DayRowGridPainter(
                                          slotCount: _timeSlots.length,
                                          slotWidth: _timeColumnWidth,
                                        ),
                                      ),
                                    ),

                                    // Store hours lines (painted)
                                    if (isOpen)
                                      RepaintBoundary(
                                        child: CustomPaint(
                                          size: Size(
                                            _timeSlots.length *
                                                _timeColumnWidth,
                                            _dayRowHeight,
                                          ),
                                          painter: _StoreHoursPainter(
                                            firstSlotMinutes: _slotMinutes(
                                              _timeSlots.first,
                                            ),
                                            openMinutes: openMinutes,
                                            closeMinutes: closeMinutes,
                                            slotWidth: _timeColumnWidth,
                                            showLabels: isFirstRow,
                                          ),
                                        ),
                                      )
                                    else
                                      Positioned.fill(
                                        child: Container(
                                          color: const Color(0xFFE0E0E0),
                                          child: Center(
                                            child: Text(
                                              'CLOSED',
                                              style: AppTextStyles.labelMedium
                                                  .copyWith(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.2,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Appointments overlay
                                    if (isOpen)
                                      ...dayAppts.map(
                                        (a) => _buildAppointmentBlock(a),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- UI bits ----------

  Widget _buildTimeHeader(TimeSlot s) {
    final h12 = s.hour == 0 ? 12 : (s.hour > 12 ? s.hour - 12 : s.hour);
    final ampm = s.hour >= 12 ? 'PM' : 'AM';
    final mm = s.minute.toString().padLeft(2, '0');
    return Container(
      width: _timeColumnWidth,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Center(
        child: Text(
          '$h12:$mm $ampm',
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildDayLabel(DateTime day) {
    final isToday = _isSameDay(day, DateTime.now());
    const weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final weekdayName = weekdayNames[day.weekday - 1];

    return Container(
      height: _dayRowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekdayName,
            style: AppTextStyles.labelMedium.copyWith(
              color: isToday ? AppColors.primaryBlue : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.month}/${day.day}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isToday ? AppColors.primaryBlue : AppColors.textPrimary,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentBlock(Appointment a) {
    // Pick ONE canonical start field. Using appointmentDate for consistency with other files.
    final start = a.appointmentDate;
    final end = start.add(Duration(minutes: a.durationMinutes));

    final firstSlotMinutes = _slotMinutes(_timeSlots.first);
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    final left = ((startMinutes - firstSlotMinutes) / 30) * _timeColumnWidth;
    final width = ((endMinutes - startMinutes) / 30) * _timeColumnWidth;

    return Positioned(
      left: left,
      top: 4,
      bottom: 4,
      width: width.clamp(20, double.infinity),
      child: GestureDetector(
        onTap: () => widget.onAppointmentTap(a),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ---------- helpers ----------

  List<Appointment> _getAppointmentsForDay(
    DateTime day,
    List<Appointment> all,
  ) {
    // Use the same field consistently: appointmentDate
    final list = all.where((a) => _isSameDay(a.appointmentDate, day)).toList();
    list.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    return list;
  }

  DayHours? _getDayHours(StoreHoursSetting? storeHours, DateTime day) {
    if (storeHours == null) return null;
    final name = _getDayName(day.weekday);
    return storeHours.hours[name];
  }

  int _slotMinutes(TimeSlot s) => s.hour * 60 + s.minute;

  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromMonday));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _getDayName(int weekday) {
    const names = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return names[weekday - 1];
  }
}

// ---------------- Painters ----------------

class _DayRowGridPainter extends CustomPainter {
  _DayRowGridPainter({required this.slotCount, required this.slotWidth});

  final int slotCount;
  final double slotWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = AppColors.border.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // vertical slot lines
    for (int i = 0; i < slotCount; i++) {
      final x = i * slotWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), border);
    }
    // right-most border
    canvas.drawLine(
      Offset(size.width - 1, 0),
      Offset(size.width - 1, size.height),
      border,
    );
    // bottom border
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant _DayRowGridPainter old) =>
      old.slotCount != slotCount || old.slotWidth != slotWidth;
}

class _StoreHoursPainter extends CustomPainter {
  _StoreHoursPainter({
    required this.firstSlotMinutes,
    required this.openMinutes,
    required this.closeMinutes,
    required this.slotWidth,
    required this.showLabels,
  });

  final int firstSlotMinutes;
  final int openMinutes;
  final int closeMinutes;
  final double slotWidth;
  final bool showLabels;

  @override
  void paint(Canvas canvas, Size size) {
    double xFor(int minutes) => ((minutes - firstSlotMinutes) / 30) * slotWidth;

    final openX = xFor(openMinutes);
    final closeX = xFor(closeMinutes);

    final openPaint = Paint()..color = AppColors.successGreen.withValues(alpha: 0.8);
    final closePaint = Paint()..color = AppColors.errorRed.withValues(alpha: 0.8);

    // OPEN line
    if (openX >= 0 && openX <= size.width) {
      canvas.drawRect(Rect.fromLTWH(openX, 0, 2, size.height), openPaint);
      if (showLabels) {
        _drawChip(
          canvas,
          Offset(openX + 4, 4),
          'OPEN ${_fmt(openMinutes)}',
          AppColors.successGreen,
        );
      }
    }

    // CLOSE line
    if (closeX >= 0 && closeX <= size.width) {
      canvas.drawRect(Rect.fromLTWH(closeX, 0, 2, size.height), closePaint);
      if (showLabels) {
        _drawChip(
          canvas,
          Offset(closeX + 4, size.height - 18),
          'CLOSE ${_fmt(closeMinutes)}',
          AppColors.errorRed,
        );
      }
    }
  }

  void _drawChip(Canvas canvas, Offset topLeft, String text, Color color) {
    // very lightweight chip: background rect + text painter
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(topLeft.dx, topLeft.dy, 90, 14),
      const Radius.circular(3),
    );
    final bgPaint = Paint()..color = color;

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: 90);

    final contentWidth = tp.width + 8;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(topLeft.dx, topLeft.dy, contentWidth, 14),
      const Radius.circular(3),
    );

    canvas.drawRRect(rect, bgPaint);
    tp.paint(canvas, Offset(topLeft.dx + 4, topLeft.dy + 1));
  }

  String _fmt(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final ampm = h >= 12 ? 'PM' : 'AM';
    return '$h12${m == 0 ? '' : ':${m.toString().padLeft(2, '0')}'}$ampm';
  }

  @override
  bool shouldRepaint(covariant _StoreHoursPainter old) {
    return firstSlotMinutes != old.firstSlotMinutes ||
        openMinutes != old.openMinutes ||
        closeMinutes != old.closeMinutes ||
        slotWidth != old.slotWidth ||
        showLabels != old.showLabels;
  }
}
