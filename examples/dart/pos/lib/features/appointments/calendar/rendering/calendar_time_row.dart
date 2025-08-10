// lib/features/appointments/calendar/widgets/calendar_time_row.dart
// Time row widget representing a single horizontal row in the calendar grid with time label and technician slots.
// Handles appointment display within time slots and technician filtering based on service categories.
// Usage: ACTIVE - Core row component for calendar grid displaying appointments across technicians

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../data/models/time_slot.dart';
import 'calendar_tech_cell.dart';

typedef OnAppointmentTap = void Function(Appointment);
typedef OnTimeSlotTap = void Function({DateTime? selectedTime, String? selectedTechnicianId});

class CalendarTimeRow extends StatelessWidget {
  const CalendarTimeRow({
    super.key,
    required this.slot,
    required this.rowExtent,
    required this.timeColumnWidth,
    required this.pageTechnicians,
    required this.selectedDate,
    required this.onTimeSlotTap,
    required this.onAppointmentTap,
    required this.appointmentsByTech,
    required this.showTimeLabel,
    required this.selectedServiceCategories,
    required this.slotMinutes,
  });

  final TimeSlot slot;
  final double rowExtent;
  final double timeColumnWidth;
  final List<Employee> pageTechnicians;
  final DateTime selectedDate;
  final OnTimeSlotTap onTimeSlotTap;
  final OnAppointmentTap onAppointmentTap;
  final Map<String, List<Appointment>> appointmentsByTech;
  final bool showTimeLabel;
  final Set<String> selectedServiceCategories;
  final int slotMinutes;

  @override
  Widget build(BuildContext context) {
    final startMinutes = slot.totalMinutes;
    final endMinutes = startMinutes + slotMinutes;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Time axis (left column)
        SizedBox(
          width: timeColumnWidth,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
              ),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: showTimeLabel
                    ? Text(
                        slot.format12Hour(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),

        // Technician columns
        Expanded(
          child: Row(
            children: pageTechnicians.map((technician) {
              final canPerformServices = _canTechnicianPerformServices(
                technician, 
                selectedServiceCategories,
              );
              final technicianId = technician.id.toString();
              final appointments = appointmentsByTech[technicianId] ?? const <Appointment>[];

              // Find appointments that intersect with this time row
              final appointmentsInRow = <Appointment>[];
              for (final appointment in appointments) {
                final appointmentStartMinutes = appointment.appointmentDate.hour * 60 + 
                                              appointment.appointmentDate.minute;
                final appointmentEndMinutes = appointmentStartMinutes + appointment.durationMinutes;
                
                // Check if appointment overlaps with this time slot
                if (appointmentStartMinutes < endMinutes && appointmentEndMinutes > startMinutes) {
                  appointmentsInRow.add(appointment);
                }
              }
              
              final hasOverlap = appointmentsInRow.length > 1;

              return Expanded(
                child: Opacity(
                  opacity: canPerformServices ? 1.0 : 0.4,
                  child: CalendarTechCell(
                    slot: slot,
                    rowExtent: rowExtent,
                    hasOverlap: hasOverlap,
                    appointmentsInRow: appointmentsInRow,
                    technicianId: technicianId,
                    selectedDate: selectedDate,
                    onTimeSlotTap: onTimeSlotTap,
                    onAppointmentTap: onAppointmentTap,
                    slotMinutes: slotMinutes,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Determines if a technician can perform the selected service categories
  bool _canTechnicianPerformServices(Employee technician, Set<String> selectedCategories) {
    if (selectedCategories.isEmpty) return true;
    
    // Map of service categories to capability requirements
    const categoryToCapabilityMap = {
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
    
    for (final category in selectedCategories) {
      final requiredCapability = categoryToCapabilityMap[category];
      if (requiredCapability == null) continue;
      
      final hasCapability = technician.capabilities.any(
        (capability) => capability.id == requiredCapability,
      );
      
      if (!hasCapability) return false;
    }
    
    return true;
  }
}
