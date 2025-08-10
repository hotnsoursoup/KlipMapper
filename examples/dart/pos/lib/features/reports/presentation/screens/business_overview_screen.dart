// lib/features/reports/presentation/screens/business_overview_screen.dart
// Business overview dashboard with revenue, appointment, and performance metrics using MobX state management. Features metric cards, charts, and dynamic data display with RepaintBoundary optimizations for performance.
// Usage: ACTIVE - Main business analytics dashboard for daily operations overview

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/reports_providers.dart';
import '../../data/models/report_data.dart';
import '../../data/models/report_data_extensions.dart';

/// Business Overview screen component following UI Bible principles:
/// - Consumer widgets for dynamic content only
/// - RepaintBoundary for expensive widgets
/// - Const constructors where possible
/// - Minimal rebuilds through strategic widget separation
class BusinessOverviewScreen extends ConsumerWidget {
  const BusinessOverviewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Metrics Row
            Consumer(
              builder: (context, ref, _) => _buildKeyMetricsRow(ref),
            ),
            
            const SizedBox(height: 32),
            
            // Revenue Chart Section
            _buildRevenueChartSection(),
            
            const SizedBox(height: 32),
            
            // Appointment Analytics Section
            Consumer(
              builder: (context, ref, _) => _buildAppointmentAnalyticsSection(ref),
            ),
            
            const SizedBox(height: 32),
            
            // Quick Stats Grid  
            Consumer(
              builder: (context, ref, _) => _buildQuickStatsGrid(ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsRow(WidgetRef ref) {
    // Get revenue data using safe extension methods
    final revenueDataAsync = ref.watch(reportDataProvider(ReportType.revenue));
    final appointmentDataAsync = ref.watch(reportDataProvider(ReportType.appointmentAnalytics));
    final paymentDataAsync = ref.watch(reportDataProvider(ReportType.paymentAnalytics));
    
    final revenueData = revenueDataAsync.value?.asRevenue;
    final appointmentData = appointmentDataAsync.value?.asAppointmentAnalytics;
    final paymentData = paymentDataAsync.value?.asPaymentAnalytics;
    
    final todayRevenue = revenueData?.todayRevenue ?? 0.0;
    final totalAppointments = appointmentData?.totalAppointments ?? 0;
    final showUpRate = appointmentData?.showUpRate ?? 0.0;
    final avgTransaction = paymentData?.averageTransactionAmount ?? 0.0;

    return Row(
      children: [
        Expanded(child: _buildMetricCard(
          title: "Today's Revenue",
          value: '\$${todayRevenue.toStringAsFixed(0)}',
          change: '+12.5%', // TODO: Calculate from historical data
          icon: Icons.attach_money,
          isPositive: true,
        ),),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(
          title: 'Total Appointments',
          value: '$totalAppointments',
          change: '+8.3%', // TODO: Calculate from historical data
          icon: Icons.event,
          isPositive: true,
        ),),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(
          title: 'Show-up Rate',
          value: '${showUpRate.toStringAsFixed(1)}%',
          change: (showUpRate > 85) ? '+${(showUpRate - 85).toStringAsFixed(1)}%' : '${(showUpRate - 85).toStringAsFixed(1)}%',
          icon: Icons.people,
          isPositive: showUpRate > 85,
        ),),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(
          title: 'Avg Transaction',
          value: '\$${avgTransaction.toStringAsFixed(2)}',
          change: '+3.2%', // TODO: Calculate from historical data
          icon: Icons.trending_up,
          isPositive: true,
        ),),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required bool isPositive,
  }) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),),
                const Spacer(),
                Icon(icon, color: AppColors.textSecondary, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(value, style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(change, style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChartSection() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Revenue Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Period selector
              Consumer(
                builder: (context, ref, _) {
                  final timeRangeText = ref.watch(timeRangeDisplayTextProvider);
                  return DropdownButton<String>(
                    value: timeRangeText,
                    items: ['Today', 'This Week', 'This Month', 'This Year']
                        .map((period) => DropdownMenuItem(
                              value: period,
                              child: Text(period),
                            ),)
                        .toList(),
                    onChanged: (value) {
                      // Update time range based on selection
                      ReportsTimeRangeType rangeType;
                      switch (value) {
                        case 'Today':
                          rangeType = ReportsTimeRangeType.today;
                          break;
                        case 'This Week':
                          rangeType = ReportsTimeRangeType.thisWeek;
                          break;
                        case 'This Month':
                          rangeType = ReportsTimeRangeType.thisMonth;
                          break;
                        case 'This Year':
                          rangeType = ReportsTimeRangeType.thisYear;
                          break;
                        default:
                          rangeType = ReportsTimeRangeType.today;
                      }
                      ref.read(reportsTimeRangeProvider.notifier).selectRange(rangeType);
                    },
                    underline: const SizedBox(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                'Chart implementation pending\n(Line chart showing revenue over time)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentAnalyticsSection(WidgetRef ref) {
    final appointmentDataAsync = ref.watch(reportDataProvider(ReportType.appointmentAnalytics));
    final appointmentData = appointmentDataAsync.value?.asAppointmentAnalytics;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointment Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          
          if (appointmentData != null) ...[
            Row(
              children: [
                Expanded(child: _buildAnalyticsItem(
                  'Total Appointments',
                  '${appointmentData.totalAppointments}',
                  Icons.event_note,
                ),),
                Expanded(child: _buildAnalyticsItem(
                  'Completed',
                  '${appointmentData.completedAppointments}',
                  Icons.check_circle,
                ),),
                Expanded(child: _buildAnalyticsItem(
                  'Cancelled',
                  '${appointmentData.cancelledAppointments}',
                  Icons.cancel,
                ),),
                Expanded(child: _buildAnalyticsItem(
                  'Show-up Rate',
                  '${appointmentData.showUpRate.toStringAsFixed(1)}%',
                  Icons.people,
                ),),
              ],
            ),
          ] else ...[
            const RepaintBoundary(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(String label, String value, IconData icon) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid(WidgetRef ref) {
    final customerDataAsync = ref.watch(reportDataProvider(ReportType.customerAnalytics));
    final technicianDataAsync = ref.watch(reportDataProvider(ReportType.technicianPerformance));
    
    final customerData = customerDataAsync.value?.asCustomerAnalytics;
    final technicianData = technicianDataAsync.value?.asTechnicianPerformance;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(child: _buildQuickStatItem(
                'Total Customers',
                '${customerData?.totalCustomers ?? 0}',
                Icons.people_outline,
                AppColors.primaryBlue,
              ),),
              const SizedBox(width: 16),
              Expanded(child: _buildQuickStatItem(
                'New This Month',
                '${customerData?.newCustomersThisMonth ?? 0}',
                Icons.person_add,
                AppColors.successGreen,
              ),),
              const SizedBox(width: 16),
              Expanded(child: _buildQuickStatItem(
                'Staff Rating',
                '${technicianData?.averageRating.toStringAsFixed(1) ?? "0.0"}',
                Icons.star,
                AppColors.serviceOrange,
              ),),
              const SizedBox(width: 16),
              Expanded(child: _buildQuickStatItem(
                'Total Staff',
                '8', // TODO: Get from employee repository
                Icons.group,
                AppColors.servicePurple,
              ),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String value, IconData icon, Color color) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}