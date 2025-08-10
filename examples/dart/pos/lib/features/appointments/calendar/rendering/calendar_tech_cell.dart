// lib/features/appointments/calendar/widgets/calendar_tech_cell.dart
// Individual technician cell widget for calendar grid displaying time slots and appointment segments.
// Handles hover effects, time slot tapping, appointment display with color coding, and overlap indicators.
// Usage: ACTIVE - Core cell component for technician columns in calendar grid

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../data/models/time_slot.dart';

typedef OnAppointmentTap = void Function(Appointment);
typedef OnTimeSlotTap = void Function({DateTime? selectedTime, String? selectedTechnicianId});

class CalendarTechCell extends StatefulWidget {
  const CalendarTechCell({
    super.key,
    required this.slot,
    required this.rowExtent,
    required this.hasOverlap,
    required this.appointmentsInRow,
    required this.technicianId,
    required this.selectedDate,
    required this.onTimeSlotTap,
    required this.onAppointmentTap,
    required this.slotMinutes,
  });

  final TimeSlot slot;
  final double rowExtent;
  final bool hasOverlap;
  final List<Appointment> appointmentsInRow;
  final String technicianId;
  final DateTime selectedDate;
  final OnTimeSlotTap onTimeSlotTap;
  final OnAppointmentTap onAppointmentTap;
  final int slotMinutes;

  @override
  State<CalendarTechCell> createState() => _CalendarTechCellState();
}

class _CalendarTechCellState extends State<CalendarTechCell> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final startMinutes = widget.slot.totalMinutes;
    final endMinutes = startMinutes + widget.slotMinutes;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () => widget.onTimeSlotTap(
          selectedTime: DateTime(
            widget.selectedDate.year,
            widget.selectedDate.month,
            widget.selectedDate.day,
            widget.slot.hour,
            widget.slot.minute,
          ),
          selectedTechnicianId: widget.technicianId,
        ),
        hoverColor: Colors.transparent,
        child: Container(
          height: widget.rowExtent,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: widget.slot.minute == 0
                    ? AppColors.border.withValues(alpha: 0.5)
                    : AppColors.border.withValues(alpha: 0.2),
                width: widget.slot.minute == 0 ? 1.5 : 1.0,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Overlap indicator (if multiple appointments in this slot)
              if (widget.hasOverlap)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.10),
                      border: Border(
                        left: BorderSide(color: AppColors.warningOrange, width: 3),
                      ),
                    ),
                  ),
                ),

              // Hover effects and time display
              if (_isHovering) ...[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 3,
                  child: Container(color: AppColors.primaryBlue),
                ),
                Positioned(
                  left: 6,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.slot.format24Hour(),
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600, 
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],

              // Appointment segments within this time slot
              ...widget.appointmentsInRow.map((appointment) {
                final appointmentStartMinutes = appointment.appointmentDate.hour * 60 + 
                                              appointment.appointmentDate.minute;
                final appointmentEndMinutes = appointmentStartMinutes + appointment.durationMinutes;
                
                final isStartRow = appointmentStartMinutes >= startMinutes && 
                                 appointmentStartMinutes < endMinutes;
                final isEndRow = appointmentEndMinutes <= endMinutes && 
                               appointmentEndMinutes > startMinutes;
                final isMiddleRow = !isStartRow && !isEndRow;

                final colorIndex = _getAppointmentColorIndex(
                  appointment, 
                  widget.technicianId, 
                  startMinutes,
                );
                final backgroundColor = _getAppointmentBackgroundColor(colorIndex);
                final borderColor = _getAppointmentBorderColor(colorIndex);

                return Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.onAppointmentTap(appointment),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      height: widget.rowExtent - 4,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: borderColor, width: 1.1),
                        borderRadius: BorderRadius.vertical(
                          top: isStartRow ? const Radius.circular(6) : Radius.zero,
                          bottom: isEndRow ? const Radius.circular(6) : Radius.zero,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: isMiddleRow 
                        ? _buildRichAppointmentLabel(appointment, colorIndex)
                        : _buildCompactAppointmentLabel(appointment, colorIndex),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Build compact appointment label for start/end row segments
  Widget _buildCompactAppointmentLabel(Appointment appointment, int colorIndex) {
    final textColor = _getAppointmentTextColor(colorIndex);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        appointment.customerName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor, 
          fontWeight: FontWeight.w600, 
          fontSize: 11,
        ),
      ),
    );
  }

  /// Build rich appointment label for middle row segments (more detail)
  Widget _buildRichAppointmentLabel(Appointment appointment, int colorIndex) {
    final textColor = _getAppointmentTextColor(colorIndex);
    return Row(
      children: [
        Expanded(
          child: Text(
            appointment.customerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor, 
              fontWeight: FontWeight.w700, 
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          appointment.appointmentTime,
          style: TextStyle(
            color: textColor.withValues(alpha: 0.8), 
            fontWeight: FontWeight.w600, 
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  /// Generate color index for appointment based on technician and time
  int _getAppointmentColorIndex(Appointment appointment, String technicianId, int rowStartMinutes) {
    final techId = int.tryParse(technicianId) ?? -1;
    final slotIndex = (rowStartMinutes / widget.slotMinutes).floor();
    return (techId + (slotIndex % 2)) % 8;
  }

  /// Get soft background color for appointment segments
  Color _getAppointmentBackgroundColor(int index) {
    switch (index % 8) {
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

  /// Get border color for appointment segments
  Color _getAppointmentBorderColor(int index) {
    switch (index % 8) {
      case 0: return AppColors.primaryBlue.withValues(alpha: 0.6);
      case 1: return AppColors.successGreen.withValues(alpha: 0.6);
      case 2: return AppColors.servicePurple.withValues(alpha: 0.6);
      case 3: return AppColors.warningOrange.withValues(alpha: 0.6);
      case 4: return const Color(0xFF8BC34A).withValues(alpha: 0.6);
      case 5: return AppColors.servicePink.withValues(alpha: 0.6);
      case 6: return const Color(0xFF26A69A).withValues(alpha: 0.6);
      case 7: return const Color(0xFFFFC107).withValues(alpha: 0.6);
      default: return AppColors.primaryBlue.withValues(alpha: 0.6);
    }
  }

  /// Get text color for appointment segments
  Color _getAppointmentTextColor(int index) {
    switch (index % 8) {
      case 0: return const Color(0xFF1565C0);
      case 1: return const Color(0xFF2E7D32);
      case 2: return const Color(0xFF6A1B9A);
      case 3: return const Color(0xFFE65100);
      case 4: return const Color(0xFF558B2F);
      case 5: return const Color(0xFFC2185B);
      case 6: return const Color(0xFF00695C);
      case 7: return const Color(0xFFF57C00);
      default: return const Color(0xFF1565C0);
    }
  }
}
