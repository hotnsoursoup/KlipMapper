// lib/features/appointments/presentation/widgets/technician_column.dart
// Refactor: CustomPaint grid, correct selected date on tap, scoped Riverpod rebuilds.
// Visuals unchanged; API preserved (new optional selectedDate, showCurrentTimeLine).

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../providers/appointments_provider.dart';
import 'current_time_line.dart';
import 'appointment_calendar_grid.dart' show TimeSlot;

class TechnicianColumn extends ConsumerStatefulWidget {
  final Employee technician;
  final List<TimeSlot> timeSlots;
  final int openTime;
  final int closeTime;
  final Function(Appointment) onAppointmentTap;
  final Function({DateTime? selectedTime, String? selectedTechnicianId})
  onTimeSlotTap;
  final double timeSlotHeight;
  final Set<String> selectedServiceCategories;

  /// Optional: pass the day being viewed so taps use that date (not today).
  final DateTime? selectedDate;

  /// Optional: disable if your grid draws a global time line overlay already.
  final bool showCurrentTimeLine;

  const TechnicianColumn({
    super.key,
    required this.technician,
    required this.timeSlots,
    required this.openTime,
    required this.closeTime,
    required this.onAppointmentTap,
    required this.onTimeSlotTap,
    required this.timeSlotHeight,
    this.selectedServiceCategories = const {},
    this.selectedDate,
    this.showCurrentTimeLine = true,
  });

  @override
  ConsumerState<TechnicianColumn> createState() => _TechnicianColumnState();
}

class _TechnicianColumnState extends ConsumerState<TechnicianColumn> {
  static const _slotMinutes = 15;

  // Hover state
  int? _hoveredIndex;

  // ---- capability filter ----
  bool _canTechnicianPerformServices(Employee tech, Set<String> selected) {
    if (selected.isEmpty) return true;
    const map = {
      'gel': 'gels',
      'acrylic': 'acrylics',
      'sns': 'dip_powder',
      'waxing': 'waxing',
      'facials': 'facials',
      'massage': 'massage',
      'nails': null,
      'mani_pedi': null,
      'manicure': null,
      'pedicure': null,
      'other': null,
    };
    for (final cat in selected) {
      final req = map[cat];
      if (req == null) continue;
      final has = tech.capabilities.any((c) => c.id == req);
      if (!has) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final canPerform = _canTechnicianPerformServices(
      widget.technician,
      widget.selectedServiceCategories,
    );
    final totalHeight = widget.timeSlots.length * widget.timeSlotHeight;

    // Scope to this tech to cut rebuild noise.
    final techIdStr = widget.technician.id.toString();
    final appointmentsAsync = ref.watch(
      appointmentsMasterProvider.select(
        (list) => list.when(
          data: (all) => all
              .where(
                (a) =>
                    a.assignedTechnicianId == techIdStr ||
                    a.requestedTechnicianId == techIdStr,
              )
              .toList(),
          loading: () => const _LoadingSentinel(),
          error: (_, __) => const <Appointment>[],
        ),
      ),
    );

    final appointments = appointmentsAsync is _LoadingSentinel
        ? const <Appointment>[]
        : (appointmentsAsync as List<Appointment>);

    // Overlap zones calculated only for this tech’s visible day
    final overlapZones = appointments.isEmpty
        ? const <OverlapZone>[]
        : _detectOverlapZones(appointments, widget.timeSlots.first);

    return Opacity(
      opacity: canPerform ? 1.0 : 0.4,
      child: Stack(
        children: [
          // GRID (one painter instead of hundreds of containers)
          MouseRegion(
            onHover: (e) => _updateHover(e.localPosition),
            onExit: (_) => setState(() => _hoveredIndex = null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) => _handleTap(d.localPosition),
              child: CustomPaint(
                size: Size.infinite,
                painter: _GridPainter(
                  timeSlots: widget.timeSlots,
                  slotHeight: widget.timeSlotHeight,
                  hoverIndex: _hoveredIndex,
                ),
              ),
            ),
          ),

          // Overlap indicators (behind appts)
          ...overlapZones.map(
            (z) => _buildOverlapZoneIndicator(z, widget.timeSlots.first),
          ),

          // Appointments
          ...appointments.map(
            (a) => _buildAppointmentBlock(a, widget.timeSlots.first),
          ),

          // Current time line (optional; keep if grid doesn't draw its own)
          if (widget.showCurrentTimeLine)
            CurrentTimeLine(
              firstSlot: widget.timeSlots.first,
              timeSlotHeight: widget.timeSlotHeight,
            ),
        ],
      ),
    );
  }

  // ---------- interactions ----------

  void _updateHover(Offset pos) {
    final index = (pos.dy / widget.timeSlotHeight).floor();
    if (index < 0 || index >= widget.timeSlots.length) {
      if (_hoveredIndex != null) setState(() => _hoveredIndex = null);
      return;
    }
    if (_hoveredIndex != index) setState(() => _hoveredIndex = index);
  }

  void _handleTap(Offset pos) {
    final index = (pos.dy / widget.timeSlotHeight).floor();
    if (index < 0 || index >= widget.timeSlots.length) return;

    final slot = widget.timeSlots[index];
    final base = widget.selectedDate ?? DateTime.now();
    final selected = DateTime(
      base.year,
      base.month,
      base.day,
      slot.hour,
      slot.minute,
    );

    widget.onTimeSlotTap(
      selectedTime: selected,
      selectedTechnicianId: widget.technician.id.toString(),
    );
  }

  // ---------- appointments ----------

  Widget _buildAppointmentBlock(Appointment appointment, TimeSlot firstSlot) {
    final startMinutes =
        appointment.appointmentDate.hour * 60 +
        appointment.appointmentDate.minute;
    final firstSlotMinutes = firstSlot.hour * 60 + firstSlot.minute;
    final topOffset =
        ((startMinutes - firstSlotMinutes) / _slotMinutes) *
        widget.timeSlotHeight;
    final calcHeight =
        (appointment.durationMinutes / _slotMinutes) * widget.timeSlotHeight;

    final height = math.max(calcHeight, 30.0);

    final colorIndex = _getAlternatingColorIndex(appointment, startMinutes);

    return Positioned(
      top: topOffset + 2,
      left: 4,
      right: 4,
      height: height - 4,
      child: GestureDetector(
        onTap: () => widget.onAppointmentTap(appointment),
        child: Container(
          decoration: BoxDecoration(
            color: _getAppointmentSoftColor(colorIndex),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _getAppointmentBorderColor(colorIndex),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => widget.onAppointmentTap(appointment),
              child: _buildAppointmentContent(
                appointment,
                calcHeight,
                colorIndex,
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getAlternatingColorIndex(Appointment appointment, int startMinutes) {
    final techStr =
        appointment.assignedTechnicianId ?? appointment.requestedTechnicianId;
    final techId = (techStr != null && techStr.isNotEmpty)
        ? int.tryParse(techStr) ?? -1
        : -1;
    final timeSlot = (startMinutes / _slotMinutes).floor();
    return (techId + (timeSlot % 2)) % 8;
  }

  Color _getAppointmentSoftColor(int idx) {
    switch (idx % 8) {
      case 0:
        return const Color(0xFFE3F2FD);
      case 1:
        return const Color(0xFFE8F5E8);
      case 2:
        return const Color(0xFFF3E5F5);
      case 3:
        return const Color(0xFFFFF3E0);
      case 4:
        return const Color(0xFFF1F8E9);
      case 5:
        return const Color(0xFFFCE4EC);
      case 6:
        return const Color(0xFFE0F2F1);
      case 7:
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFE3F2FD);
    }
  }

  Color _getAppointmentBorderColor(int idx) {
    switch (idx % 8) {
      case 0:
        return AppColors.primaryBlue.withValues(alpha: 0.6);
      case 1:
        return AppColors.successGreen.withValues(alpha: 0.6);
      case 2:
        return AppColors.servicePurple.withValues(alpha: 0.6);
      case 3:
        return AppColors.warningOrange.withValues(alpha: 0.6);
      case 4:
        return const Color(0xFF8BC34A).withValues(alpha: 0.6);
      case 5:
        return AppColors.servicePink.withValues(alpha: 0.6);
      case 6:
        return const Color(0xFF26A69A).withValues(alpha: 0.6);
      case 7:
        return const Color(0xFFFFC107).withValues(alpha: 0.6);
      default:
        return AppColors.primaryBlue.withValues(alpha: 0.6);
    }
  }

  Color _getAppointmentTextColor(int idx) {
    switch (idx % 8) {
      case 0:
        return const Color(0xFF1565C0);
      case 1:
        return const Color(0xFF2E7D32);
      case 2:
        return const Color(0xFF6A1B9A);
      case 3:
        return const Color(0xFFE65100);
      case 4:
        return const Color(0xFF558B2F);
      case 5:
        return const Color(0xFFC2185B);
      case 6:
        return const Color(0xFF00695C);
      case 7:
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF1565C0);
    }
  }

  Widget _buildAppointmentContent(
    Appointment apt,
    double availableHeight,
    int colorIndex,
  ) {
    final textColor = _getAppointmentTextColor(colorIndex);

    const veryShort = 35.0;
    const short = 55.0;
    const medium = 80.0;

    if (availableHeight < veryShort) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                apt.customerName,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              apt.appointmentTime,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    } else if (availableHeight < short) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            apt.customerName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (availableHeight < medium) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              apt.customerName,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              apt.appointmentTime,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    apt.customerName,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusIcon(apt),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              apt.appointmentTime,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (availableHeight > 100 && apt.services?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                apt.services!.take(2).map((s) => s.name).join(', '),
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 9,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildStatusIcon(Appointment a) {
    switch (a.status) {
      case 'confirmed':
        return Icon(
          Icons.check_circle,
          size: 12,
          color: AppColors.successGreen,
        );
      case 'completed':
        return Icon(
          Icons.check_circle,
          size: 12,
          color: AppColors.successGreen.withValues(alpha: 0.8),
        );
      case 'noShow':
      case 'no-show':
        return Icon(Icons.cancel, size: 12, color: AppColors.errorRed);
      case 'scheduled':
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------- overlap detection ----------

  List<OverlapZone> _detectOverlapZones(
    List<Appointment> appts,
    TimeSlot firstSlot,
  ) {
    final zones = <OverlapZone>[];
    final list = List<Appointment>.from(appts)
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    for (int i = 0; i < list.length; i++) {
      final cur = list[i];
      final curStart =
          cur.appointmentDate.hour * 60 + cur.appointmentDate.minute;
      final curEnd = curStart + cur.durationMinutes;

      final overlapping = <Appointment>[cur];
      for (int j = i + 1; j < list.length; j++) {
        final other = list[j];
        final oStart =
            other.appointmentDate.hour * 60 + other.appointmentDate.minute;
        final oEnd = oStart + other.durationMinutes;
        if (curStart < oEnd && oStart < curEnd) overlapping.add(other);
      }

      if (overlapping.length > 1) {
        final zoneStart = overlapping
            .map((a) => a.appointmentDate.hour * 60 + a.appointmentDate.minute)
            .reduce((a, b) => a < b ? a : b);
        final zoneEnd = overlapping
            .map(
              (a) =>
                  a.appointmentDate.hour * 60 +
                  a.appointmentDate.minute +
                  a.durationMinutes,
            )
            .reduce((a, b) => a > b ? a : b);

        final exists = zones.any(
          (z) => z.startMinutes <= zoneStart && z.endMinutes >= zoneEnd,
        );
        if (!exists) {
          zones.add(
            OverlapZone(
              startMinutes: zoneStart,
              endMinutes: zoneEnd,
              overlapCount: overlapping.length,
              appointments: overlapping,
            ),
          );
        }
      }
    }
    return zones;
  }

  Widget _buildOverlapZoneIndicator(OverlapZone zone, TimeSlot firstSlot) {
    final firstMinutes = firstSlot.hour * 60 + firstSlot.minute;
    final top =
        ((zone.startMinutes - firstMinutes) / _slotMinutes) *
        widget.timeSlotHeight;
    final height =
        ((zone.endMinutes - zone.startMinutes) / _slotMinutes) *
        widget.timeSlotHeight;

    final severe = zone.overlapCount >= 3;
    final overlay = severe ? AppColors.errorRed : AppColors.warningOrange;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: overlay.withValues(alpha: 0.12),
          border: Border(left: BorderSide(color: overlay, width: 3)),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _OverlapPatternPainter(color: overlay),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  severe ? Icons.error : Icons.warning,
                  size: 12,
                  color: overlay,
                ),
              ),
            ),
            if (zone.overlapCount > 2)
              Positioned(
                top: 20,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '3+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---- tiny helpers / types ----

class OverlapZone {
  final int startMinutes;
  final int endMinutes;
  final int overlapCount;
  final List<Appointment> appointments;
  const OverlapZone({
    required this.startMinutes,
    required this.endMinutes,
    required this.overlapCount,
    required this.appointments,
  });
}

class _LoadingSentinel {
  const _LoadingSentinel();
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.timeSlots,
    required this.slotHeight,
    required this.hoverIndex,
  });

  final List<TimeSlot> timeSlots;
  final double slotHeight;
  final int? hoverIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final thin = Paint()
      ..color = AppColors.border.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    final thick = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    // background
    final bg = Paint()..color = AppColors.background;
    canvas.drawRect(Offset.zero & size, bg);

    // hover background + left bar
    if (hoverIndex != null &&
        hoverIndex! >= 0 &&
        hoverIndex! < timeSlots.length) {
      final top = hoverIndex! * slotHeight;
      final rect = Rect.fromLTWH(0, top, size.width, slotHeight);
      final hoverPaint = Paint()
        ..color = AppColors.primaryBlue.withValues(alpha: 0.1);
      canvas.drawRect(rect, hoverPaint);

      final bar = Paint()..color = AppColors.primaryBlue;
      canvas.drawRect(Rect.fromLTWH(0, top, 3, slotHeight), bar);
    }

    // horizontal lines
    double y = 0;
    for (final slot in timeSlots) {
      final isHour = slot.minute == 0;
      final p = isHour ? thick : thin;
      canvas.drawLine(
        Offset(0, y + slotHeight),
        Offset(size.width, y + slotHeight),
        p,
      );
      y += slotHeight;
    }

    // right border
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      thin,
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.slotHeight != slotHeight ||
      old.timeSlots.length != timeSlots.length ||
      old.hoverIndex != hoverIndex;
}

class _OverlapPatternPainter extends CustomPainter {
  final Color color;
  const _OverlapPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    const spacing = 8.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
