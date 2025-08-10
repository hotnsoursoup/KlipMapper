// lib/features/appointments/presentation/widgets/appointment_summary_card.dart
// Dashboard summary card showing daily appointment metrics, revenue calculations, and service category breakdowns.
// Converted to Riverpod from MobX for reactive state management and displays today's appointment statistics with visual service indicators.
// Usage: ACTIVE - Featured in dashboard for daily appointment overview

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/config/service_categories.dart';
import '../../providers/appointments_provider.dart';

class AppointmentSummaryCard extends ConsumerWidget {
  const AppointmentSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsMasterProvider);
    
    return appointmentsAsync.when(
      data: (appointments) {
        final today = DateTime.now();
        final todaysAppointments = appointments.where((apt) {
          final startDate = DateTime.parse(apt.startDateTime);
          return startDate.year == today.year &&
                 startDate.month == today.month &&
                 startDate.day == today.day;
        }).toList();
        final confirmedAppointments = todaysAppointments.where((apt) => apt.status == 'confirmed').toList();
        final upcomingAppointments = todaysAppointments.where((apt) => apt.status == 'scheduled' || apt.status == 'confirmed').toList();
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with date and icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.today,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Summary',
                          style: AppTextStyles.headline3.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDate(DateTime.now()),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Metrics row
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Total',
                      '${todaysAppointments.length}',
                      AppColors.primaryBlue,
                      Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Confirmed',
                      '${confirmedAppointments.length}',
                      AppColors.successGreen,
                      Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Upcoming',
                      '${upcomingAppointments.length}',
                      AppColors.warningOrange,
                      Icons.schedule,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Revenue',
                      '\$${_calculateTodaysRevenue(todaysAppointments)}',
                      AppColors.successGreen,
                      Icons.attach_money,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Service breakdown
              _buildServiceBreakdown(todaysAppointments),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: const Center(child: Text('Error loading appointments')),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headline2.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBreakdown(List<dynamic> appointments) {
    final serviceBreakdown = _calculateServiceBreakdown(appointments);
    
    if (serviceBreakdown.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'No services scheduled for today',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pie_chart_outline,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Service Breakdown',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: serviceBreakdown.entries.map((entry) {
            final categoryId = entry.key;
            final count = entry.value;
            final categoryColor = _getCategoryColor(categoryId);
            final categoryName = _getCategoryName(categoryId);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoryName,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Map<int, int> _calculateServiceBreakdown(List<dynamic> appointments) {
    final breakdown = <int, int>{};
    
    for (final appointment in appointments) {
      final services = appointment.services;
      if (services != null) {
        for (final service in services) {
          final categoryIdInt = service.categoryId;
          breakdown[categoryIdInt] = (breakdown[categoryIdInt] ?? 0) + 1;
        }
      }
    }
    
    return breakdown;
  }

  String _calculateTodaysRevenue(List<dynamic> appointments) {
    double total = 0.0;
    
    for (final appointment in appointments) {
      if (appointment.status == 'completed' || appointment.status == 'confirmed') {
        final services = appointment.services;
        if (services != null) {
          for (final service in services) {
            total += service.price;
          }
        }
      }
    }
    
    return total.toStringAsFixed(0);
  }

  Color _getCategoryColor(int categoryId) {
    try {
      return ServiceCategories.getCategoryColorById(categoryId) ?? AppColors.primaryBlue;
    } catch (e) {
      return AppColors.primaryBlue;
    }
  }

  String _getCategoryName(int categoryId) {
    try {
      // Map numeric IDs to category names (matching ServiceCategories pattern)
      final Map<int, String> idToCategoryMap = {
        1: 'Nails',
        2: 'Gel',
        3: 'Acrylic',
        4: 'Waxing',
        5: 'Facials',
        6: 'SNS',
        7: 'Massage',
        8: 'Hair',
      };
      
      return idToCategoryMap[categoryId] ?? 'Category $categoryId';
    } catch (e) {
      return 'Category $categoryId';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, $month ${date.day}, ${date.year}';
  }
}