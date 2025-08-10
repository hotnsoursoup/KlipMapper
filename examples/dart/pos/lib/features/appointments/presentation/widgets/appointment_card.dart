// lib/features/appointments/presentation/widgets/appointment_card.dart
// Appointment card widget for displaying upcoming appointments with check-in and contact functionality.
// Features time formatting, status indicators, service display modes, and responsive design with opacity settings.
// Usage: ACTIVE - Used in dashboard upcoming appointments section and appointment lists

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/presentation/widgets/service_category_icon.dart';
import '../../../shared/presentation/widgets/service_pill.dart';
import '../../../settings/providers/settings_provider.dart';

// TODO: Apply widgetOpacity from SettingsStore universally across all screens
// This would require passing the opacity value through a theme or context provider
// to all widgets that should respect the translucency setting

/// Appointment card for the upcoming appointments section
class AppointmentCard extends ConsumerWidget {
  final Appointment appointment;
  final VoidCallback? onCheckIn;
  final VoidCallback? onContact;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCheckIn,
    this.onContact,
  });

  String _formatTime(String timeString) {
    try {
      // Parse time string in HH:mm format
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasConfirmedStatus = appointment.status == 'confirmed';
    final now = DateTime.now();
    
    // Use the appointment's scheduled start time
    final appointmentDateTime = appointment.scheduledStartTime;
    
    final isLate = appointmentDateTime.isBefore(now);
    final minutesLate = isLate ? now.difference(appointmentDateTime).inMinutes : 0;
    
    final settingsAsync = ref.watch(settingsMasterProvider);
    final widgetOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_widget_opacity']?.parsedValue as double? ?? 1.0,
      orElse: () => 1.0,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA).withValues(alpha: widgetOpacity),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLate ? AppColors.errorRed.withValues(alpha: 0.5) : AppColors.textSecondary.withValues(alpha: 0.4),
          width: isLate ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onCheckIn,
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time row (moved above customer info)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: isLate ? AppColors.errorRed : AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(appointment.appointmentTime),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isLate ? AppColors.errorRed : AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isLate) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.errorRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${minutesLate}m late',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.errorRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                      // Add some space for buttons
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Customer info row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.customerName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Services - respects user display setting
                  Builder(
                    builder: (context) {
                      final serviceDisplayMode = settingsAsync.maybeWhen(
                        data: (settings) => settings['dashboard_service_display_mode']?.parsedValue as String? ?? 'inline',
                        orElse: () => 'inline',
                      );
                      return Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (appointment.services?.isNotEmpty == true)
                            ? appointment.services!
                                .map((service) => serviceDisplayMode == 'pills'
                                    ? ServicePill(
                                        serviceName: service.name,
                                        categoryId: service.categoryId.toString(),
                                        isSmall: true,
                                      )
                                    : ServiceCategoryIcon(
                                        categoryId: service.categoryId.toString(),
                                        serviceName: service.name,
                                        size: 34,
                                      ),)
                                .toList()
                        : appointment.serviceIds
                            .map((serviceId) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Service $serviceId',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),)
                            .toList(),
                      );
                    },
                  ),
                  // Technician and confirmation status row
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Technician name (smaller font) - formatted as "First L."
                      if (appointment.requestedTechnicianName != null)
                        Text(
                          'Tech: ${NameFormatter.formatTechnicianDisplayName(appointment.requestedTechnicianName)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (appointment.requestedTechnicianId != null)
                        Text(
                          'Tech ID: ${appointment.requestedTechnicianId}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      // Confirmation status (bottom right)
                      if (!hasConfirmedStatus) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 12,
                                color: AppColors.warningOrange,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Unconfirmed',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.warningOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: AppColors.successGreen,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Confirmed',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons positioned vertically at top right
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Check In button at top right
                  SizedBox(
                    height: 28,
                    child: OutlinedButton.icon(
                      onPressed: onCheckIn,
                      icon: const Icon(Icons.login, size: 14),
                      label: const Text('Check In'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: const BorderSide(color: AppColors.primaryBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Contact button below Check In
                  SizedBox(
                    height: 28,
                    child: OutlinedButton.icon(
                      onPressed: onContact,
                      icon: const Icon(Icons.phone_outlined, size: 14),
                      label: const Text('Contact'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}