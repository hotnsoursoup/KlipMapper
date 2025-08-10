// lib/features/appointments/presentation/widgets/appointments_timeline.dart
// Dashboard "day at a glance" timeline that stays in sync with calendar data/providers.
// - Dynamic store hours (7am .. max(close+1h, 10pm))
// - Pulls appointments for the selected day via Riverpod
// - Colors aligned with status; soft fallback palette
// - Current time indicator only when selected day is today
// - Public API preserved: isExpanded, onToggleExpand, appointments (optional override)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../providers/appointment_providers.dart';

class AppointmentsTimeline extends ConsumerWidget {
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  /// Optional override: if provided, we use this list instead of pulling from providers.
  /// Useful for previews or custom filters.
  final List<TimelineAppointment> appointments;

  const AppointmentsTimeline({
    super.key,
    this.isExpanded = false,
    this.onToggleExpand,
    this.appointments = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final storeHours = ref.watch(storeHoursSettingProvider);

    // If caller passed appointments explicitly, we use them and just compute hours
    if (appointments.isNotEmpty) {
      final startEnd = _computeStartEndFromSettings(storeHours);
      return _TimelineShell(
        isExpanded: isExpanded,
        onToggleExpand: onToggleExpand,
        startHour: startEnd.$1,
        endHour: startEnd.$2,
        selectedDate: selectedDate,
        appointments: appointments,
      );
    }

    // Otherwise, load from the canonical provider
    final apptsAsync = ref.watch(appointmentsMasterProvider);
    return apptsAsync.when(
      loading: () => _Skeleton(isExpanded: isExpanded, onToggleExpand: onToggleExpand),
      error: (_, __) => _Skeleton(isExpanded: isExpanded, onToggleExpand: onToggleExpand),
      data: (all) {
        // Filter appointments to selected day
        final dayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        final dayEnd = dayStart.add(const Duration(days: 1));

        final dayAppts = all
            .where((a) => a.appointmentDate.isAfter(dayStart.subtract(const Duration(milliseconds: 1))) &&
                          a.appointmentDate.isBefore(dayEnd))
            .toList();

        // Map to timeline items with status-based color
        final items = dayAppts.map(_toTimelineAppointment).toList();

        final startEnd = _computeStartEndFromSettings(storeHours);
        return _TimelineShell(
          isExpanded: isExpanded,
          onToggleExpand: onToggleExpand,
          startHour: startEnd.$1,
          endHour: startEnd.$2,
          selectedDate: selectedDate,
          appointments: items,
        );
      },
    );
  }

  /// Compute visible start/end hours based on settings (same approach as calendar grid).
  /// Minimum 7am start, minimum 10pm end, or (store close + 1h) if later.
  (int, int) _computeStartEndFromSettings(StoreHoursSetting storeHoursConfig) {
    const minStart = 7;
    const minEnd = 22; // 10 PM
    final dayName = _dayName(DateTime.now().weekday); // Only used as fallback when overrides are passed in
    final hours = storeHoursConfig.hours[dayName] ?? const DayHours();
    final closeMins = hours.closeTime ?? 1140; // 19:00 default
    final endHour = (closeMins / 60).ceil() + 1;
    final finalEndHour = endHour > minEnd ? endHour : minEnd;
    return (minStart, finalEndHour.clamp(0, 24));
  }

  String _dayName(int weekday) {
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }
}

/// Layout wrapper: header row with optional expand/collapse button + painted timeline + dynamic labels.
class _TimelineShell extends StatelessWidget {
  const _TimelineShell({
    required this.isExpanded,
    required this.onToggleExpand,
    required this.startHour,
    required this.endHour,
    required this.selectedDate,
    required this.appointments,
  });

  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final int startHour;
  final int endHour;
  final DateTime selectedDate;
  final List<TimelineAppointment> appointments;

  @override
  Widget build(BuildContext context) {
    final height = isExpanded ? 92.0 : 60.0;

    final labels = _buildLabels(startHour, endHour);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Optional header button (keeps public API consistent; no visual change if not used)
        if (onToggleExpand != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onToggleExpand,
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 18),
              label: Text(isExpanded ? 'Collapse' : 'Expand'),
            ),
          ),

        // Timeline canvas
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: TimelinePainter(
              appointments: appointments,
              startHour: startHour,
              endHour: endHour,
              selectedDate: selectedDate,
            ),
          ),
        ),

        // Time labels
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map((t) => Text(t, style: AppTextStyles.labelSmall))
                .toList(),
          ),
        ),
      ],
    );
  }

  List<String> _buildLabels(int start, int end) {
    final total = end - start;
    if (total <= 0) return const <String>[];
    // 4 ticks: start, 1/3, 2/3, end (ish)
    final ticks = <int>{start, end};
    ticks.add(start + (total / 3).round());
    ticks.add(start + (2 * total / 3).round());
    final sorted = ticks.toList()..sort();
    return sorted.map((h) => _fmtHour(h)).toList();
  }

  String _fmtHour(int hour24) {
    final h = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final ampm = hour24 >= 12 ? 'PM' : 'AM';
    return '$h $ampm';
  }
}

/// Data model for timeline items (kept for external overrides and painter interop)
class TimelineAppointment {
  final DateTime startTime;
  final DateTime endTime;
  final String customerName;
  final String? technicianName;
  final Color color;

  const TimelineAppointment({
    required this.startTime,
    required this.endTime,
    required this.customerName,
    this.technicianName,
    required this.color,
  });
}

/// Painter that draws the day bar, appointment spans, and current-time indicator.
class TimelinePainter extends CustomPainter {
  TimelinePainter({
    required this.appointments,
    required this.startHour,
    required this.endHour,
    required this.selectedDate,
  });

  final List<TimelineAppointment> appointments;
  final int startHour;
  final int endHour;
  final DateTime selectedDate;

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.fill;

    final track = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(track, bgPaint);

    final totalHours = (endHour - startHour).clamp(1, 24);
    double xFor(DateTime dt) {
      final hours = dt.hour + dt.minute / 60.0;
      final t = ((hours - startHour) / totalHours).clamp(0.0, 1.0);
      return size.width * t;
    }

    // Appointments as rounded bars
    for (final a in appointments) {
      final left = xFor(a.startTime);
      final right = xFor(a.endTime);
      final width = (right - left).clamp(2.0, size.width);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 8, width, size.height - 16),
        const Radius.circular(4),
      );
      final paint = Paint()..color = a.color;
      canvas.drawRRect(rect, paint);
    }

    // Current time indicator (only when viewing today)
    final now = DateTime.now();
    final isToday = now.year == selectedDate.year &&
        now.month == selectedDate.month &&
        now.day == selectedDate.day;

    if (isToday && now.hour >= startHour && now.hour < endHour) {
      final x = xFor(now);
      final indicator = Paint()
        ..color = AppColors.errorRed
        ..strokeWidth = 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), indicator);
    }
  }

  @override
  bool shouldRepaint(TimelinePainter old) {
    return appointments != old.appointments ||
        startHour != old.startHour ||
        endHour != old.endHour ||
        selectedDate != old.selectedDate;
  }
}

// ------------------------- helpers -------------------------

TimelineAppointment _toTimelineAppointment(Appointment a) {
  // If your Appointment has status, we align color to status. Otherwise use a soft alternating palette.
  final color = _statusColor(a.status) ?? _softColorFromString(a.assignedTechnicianId ?? a.requestedTechnicianId ?? 'any');
  final end = a.appointmentDate.add(Duration(minutes: a.durationMinutes));
  return TimelineAppointment(
    startTime: a.appointmentDate,
    endTime: end,
    customerName: a.customerName,
    technicianName: a.assignedTechnicianId ?? a.requestedTechnicianId,
    color: color,
  );
}

Color? _statusColor(String? status) {
  switch ((status ?? '').toLowerCase()) {
    case 'confirmed':
      return AppColors.successGreen.withValues(alpha: 0.8);
    case 'completed':
      return AppColors.successGreen.withValues(alpha: 0.6);
    case 'no-show':
    case 'noshow':
    case 'noShow':
      return AppColors.errorRed.withValues(alpha: 0.8);
    case 'scheduled':
    case 'unconfirmed':
      return AppColors.warningOrange.withValues(alpha: 0.7);
    default:
      return null;
  }
}

Color _softColorFromString(String seed) {
  // simple stable hash -> 8 soft colors aligned with your grid palette
  final hash = seed.codeUnits.fold<int>(0, (acc, c) => (acc + c) & 0x7fffffff);
  switch (hash % 8) {
    case 0: return const Color(0xFFE3F2FD);
    case 1: return const Color(0xFFE8F5E8);
    case 2: return const Color(0xFFF3E5F5);
    case 3: return const Color(0xFFFFF3E0);
    case 4: return const Color(0xFFF1F8E9);
    case 5: return const Color(0xFFFCE4EC);
    case 6: return const Color(0xFFE0F2F1);
    case 7: return const Color(0xFFFFF8E1);
    default: return const Color(0xFFE3F2FD);
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.isExpanded, this.onToggleExpand});
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  @override
  Widget build(BuildContext context) {
    final height = isExpanded ? 92.0 : 60.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onToggleExpand != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onToggleExpand,
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 18),
              label: Text(isExpanded ? 'Collapse' : 'Expand'),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _Pulse(width: 36), _Pulse(width: 42), _Pulse(width: 36), _Pulse(width: 40),
          ],
        ),
      ],
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.width});
  final double width;
  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: Container(height: 10, width: widget.width, color: AppColors.surfaceLight),
    );
  }
}
