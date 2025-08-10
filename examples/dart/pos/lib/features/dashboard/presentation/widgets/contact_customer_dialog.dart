// lib/features/dashboard/presentation/widgets/contact_customer_dialog.dart
// Customer contact information dialog displaying appointment details with quick contact actions. Shows customer name, phone, email, and appointment specifics for efficient customer communication.
// Usage: ACTIVE - Used from dashboard and appointment management for customer contact operations

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/appointment_model.dart';

/// A dialog widget that displays customer contact information and appointment details.
/// 
/// Features:
/// * Shows customer name, phone, and email
/// * Displays appointment time, date, and services
/// * Shows confirmation status with visual indicators
/// * Provides confirmation action for unconfirmed appointments
/// * Time formatting from 24-hour to 12-hour format
/// 
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ContactCustomerDialog(appointment: appointment),
/// );
/// ```
class ContactCustomerDialog extends StatelessWidget {
  final Appointment appointment;

  const ContactCustomerDialog({
    super.key,
    required this.appointment,
  });

  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConfirmedStatus = appointment.status == 'confirmed';
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Contact Customer',
                    style: AppTextStyles.headline3,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Customer info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.customer?.name ?? 'Customer ID: ${appointment.customerId}',
                    style: AppTextStyles.headline3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (appointment.customer?.phone != null && appointment.customer!.phone!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          appointment.customer!.phone ?? 'No phone',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  if (appointment.customer?.email?.isNotEmpty == true) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          appointment.customer!.email ?? '',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    Text(
                      'Note: Full customer details loaded from repository.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Appointment details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment Details',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Appointment time
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(appointment.appointmentTime),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${appointment.appointmentDate.month}/${appointment.appointmentDate.day}/${appointment.appointmentDate.year}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Confirmation status
                  Row(
                    children: [
                      Icon(
                        hasConfirmedStatus ? Icons.check_circle : Icons.warning_amber_rounded,
                        size: 16,
                        color: hasConfirmedStatus ? AppColors.successGreen : AppColors.warningOrange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasConfirmedStatus ? 'Confirmed' : 'Not Confirmed',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: hasConfirmedStatus ? AppColors.successGreen : AppColors.warningOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  // Services
                  if (appointment.services?.isNotEmpty == true) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Services',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...appointment.services!.map((service) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '• ${service.name} (\$${service.price.toStringAsFixed(2)}, ${service.durationMinutes}min)',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),),
                  ] else if (appointment.serviceIds.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Services',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...appointment.serviceIds.map((serviceId) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '• Service ID: $serviceId',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),),
                  ],
                  
                  // Duration
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Duration: ${appointment.durationMinutes} minutes',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!hasConfirmedStatus) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement confirm appointment
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Confirm Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}