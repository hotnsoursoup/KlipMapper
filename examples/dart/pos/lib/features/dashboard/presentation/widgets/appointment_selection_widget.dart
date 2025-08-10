/// Appointment selection widget for customer check-in with walk-in/appointment toggle.
/// 
/// **Architecture:**
/// - **State Management**: Local StatefulWidget for selection state
/// - **Data Flow**: Callback-based communication with parent components
/// - **UI Patterns**: Toggle pills and selectable appointment cards
/// 
/// **Key Features:**
/// - Check-in type selection (walk-in vs appointment)
/// - Today's appointment listing with customer details
/// - Service pre-population when appointment selected
/// - Status-based color coding and labels
/// - Interactive appointment card selection
/// - Price calculation display for scheduled services
/// 
/// **Check-in Types:**
/// - **Walk-in**: Direct service selection without pre-existing appointment
/// - **Appointment**: Select from today's scheduled appointments
/// 
/// **Appointment Card Display:**
/// - Customer avatar with first initial
/// - Customer name and scheduled time
/// - Service count and total price
/// - Status badge with color coding
/// - Requested technician information
/// 
/// **Status Colors:**
/// - Scheduled: Primary Blue
/// - Arrived: Success Green  
/// - In Service: Warning Orange
/// - Completed: Success Green
/// 
/// **Usage:**
/// ```dart
/// AppointmentSelectionWidget(
///   todaysAppointments: appointments,
///   selectedAppointment: currentSelection,
///   checkInType: checkInMode,
///   onAppointmentSelected: (appointment) => handleSelection(appointment),
///   onCheckInTypeChanged: (type) => updateMode(type),
///   onServicesPrePopulated: (services) => populateServices(services),
/// )
/// ```
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/service_model.dart';
class AppointmentSelectionWidget extends StatefulWidget {
  final List<Ticket> todaysAppointments;
  final Ticket? selectedAppointment;
  final Function(Ticket?) onAppointmentSelected;
  final String checkInType;
  final Function(String) onCheckInTypeChanged;
  final Function(List<Service>)? onServicesPrePopulated;

  const AppointmentSelectionWidget({
    super.key,
    required this.todaysAppointments,
    required this.selectedAppointment,
    required this.onAppointmentSelected,
    required this.checkInType,
    required this.onCheckInTypeChanged,
    this.onServicesPrePopulated,
  });

  @override
  State<AppointmentSelectionWidget> createState() => _AppointmentSelectionWidgetState();
}

class _AppointmentSelectionWidgetState extends State<AppointmentSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Check-in type selector
        Text(
          'Check-in Type',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: _buildTypePill(
                text: 'Walk-in',
                isSelected: widget.checkInType == 'walk-in',
                onTap: () => widget.onCheckInTypeChanged('walk-in'),
                color: AppColors.successGreen,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTypePill(
                text: 'Appointment',
                isSelected: widget.checkInType == 'appointment',
                onTap: () => widget.onCheckInTypeChanged('appointment'),
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Appointment selection (if appointment type selected)
        if (widget.checkInType == 'appointment') ...[
          Text(
            'Select Appointment',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          if (widget.todaysAppointments.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No appointments scheduled for today',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...widget.todaysAppointments.map((appointment) => 
              _buildAppointmentCard(appointment),),
          ],
        ],
      ],
    );
  }

  Widget _buildTypePill({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Ticket appointment) {
    final isSelected = widget.selectedAppointment?.id == appointment.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () {
          widget.onAppointmentSelected(isSelected ? null : appointment);
          
          // Pre-populate services when appointment is selected
          if (!isSelected && appointment.services.isNotEmpty) {
            widget.onServicesPrePopulated?.call(appointment.services);
          }
        },
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              appointment.customer.name.isNotEmpty 
                  ? appointment.customer.name[0].toUpperCase() 
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          appointment.customer.name,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appointment.appointmentTime != null)
              Text(
                'Scheduled: ${AppDateFormatter.formatTime(appointment.appointmentTime!)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            Text(
              '${appointment.services.length} service${appointment.services.length != 1 ? 's' : ''}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (appointment.requestedTechnicianName?.isNotEmpty == true)
              Text(
                'Requested: ${appointment.requestedTechnicianName}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(appointment.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(appointment.status).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _getStatusLabel(appointment.status),
                style: AppTextStyles.labelSmall.copyWith(
                  color: _getStatusColor(appointment.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (appointment.services.isNotEmpty)
              Text(
                '\$${appointment.services.fold<double>(0, (sum, service) => sum + service.price).toStringAsFixed(2)}',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
          ],
        ),
        selected: isSelected,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppColors.primaryBlue;
      case 'arrived':
        return AppColors.successGreen;
      case 'inservice':
        return AppColors.warningOrange;
      case 'completed':
        return AppColors.successGreen;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';
      case 'arrived':
        return 'Arrived';
      case 'inservice':
        return 'In Service';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }
}