// lib/features/reports/presentation/widgets/report_card.dart
// Report preview card widget displaying summary metrics for different report types with performance optimizations.
// Shows key metrics, loading states, and error handling for revenue, service, staff, customer, appointment, and payment reports.
// Usage: ACTIVE - Used in reports dashboard for displaying report type previews with navigation

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/report_data.dart';

/// A preview card for each report type that shows summary metrics
/// Follows UI Bible principles: const constructors, RepaintBoundary
class ReportCard extends StatelessWidget {
  final ReportType reportType;
  final ReportData? reportData;
  final bool isLoading;
  final String? error;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.reportType,
    required this.reportData,
    required this.isLoading,
    required this.error,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                RepaintBoundary(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getReportColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getReportIcon(),
                          color: _getReportColor(),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getReportTitle(),
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getReportSubtitle(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Content area
                Expanded(
                  child: _buildContent(),
                ),
                
                const SizedBox(height: 12),
                
                // Footer with view details
                RepaintBoundary(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Details',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getReportColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: _getReportColor(),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: RepaintBoundary(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorRed,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorRed,
              ),
            ),
          ],
        ),
      );
    }

    if (reportData == null) {
      return Center(
        child: Text(
          'No data available',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return _buildSummaryContent();
  }

  Widget _buildSummaryContent() {
    return reportData!.when(
      revenue: (totalRevenue, todayRevenue, yesterdayRevenue, weekRevenue, monthRevenue, dailyData, topServices) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Total Revenue', '\$${totalRevenue.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildMetricRow('Today', '\$${todayRevenue.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildMetricRow('This Week', '\$${weekRevenue.toStringAsFixed(2)}'),
          ],
        );
      },
      servicePerformance: (serviceMetrics, totalServicesCompleted, averageServiceValue, trends) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Services Completed', totalServicesCompleted.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('Average Value', '\$${averageServiceValue.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildTrendIndicator(12.5), // Mock trend percentage
          ],
        );
      },
      technicianPerformance: (technicianMetrics, totalAppointments, averageRating, revenueByTechnician) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Total Appointments', totalAppointments.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('Average Rating', '${averageRating.toStringAsFixed(1)} ★'),
            const SizedBox(height: 8),
            _buildTrendIndicator(8.3), // Mock trend percentage
          ],
        );
      },
      customerAnalytics: (totalCustomers, newCustomersThisMonth, returningCustomers, averageVisitValue, segments, retentionData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Total Customers', totalCustomers.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('New This Month', newCustomersThisMonth.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('Avg Visit Value', '\$${averageVisitValue.toStringAsFixed(2)}'),
          ],
        );
      },
      appointmentAnalytics: (totalAppointments, completedAppointments, cancelledAppointments, showUpRate, bookingPatterns, typeDistribution) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Total Appointments', totalAppointments.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('Completed', completedAppointments.toString()),
            const SizedBox(height: 8),
            _buildMetricRow('Show-up Rate', '${showUpRate.toStringAsFixed(1)}%'),
          ],
        );
      },
      paymentAnalytics: (totalPayments, paymentMethodBreakdown, averageTransactionAmount, trends, tipsTotal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricRow('Total Payments', '\$${totalPayments.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildMetricRow('Avg Transaction', '\$${averageTransactionAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildMetricRow('Total Tips', '\$${tipsTotal.toStringAsFixed(2)}'),
          ],
        );
      },
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(double percentage) {
    final isPositive = percentage >= 0;
    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppColors.successGreen : AppColors.errorRed,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${percentage.toStringAsFixed(1)}%',
          style: AppTextStyles.bodySmall.copyWith(
            color: isPositive ? AppColors.successGreen : AppColors.errorRed,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'vs last period',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getReportTitle() {
    switch (reportType) {
      case ReportType.revenue:
        return 'Revenue';
      case ReportType.servicePerformance:
        return 'Services';
      case ReportType.technicianPerformance:
        return 'Staff';
      case ReportType.customerAnalytics:
        return 'Customers';
      case ReportType.appointmentAnalytics:
        return 'Appointments';
      case ReportType.paymentAnalytics:
        return 'Payments';
    }
  }

  String _getReportSubtitle() {
    switch (reportType) {
      case ReportType.revenue:
        return 'Sales & earnings overview';
      case ReportType.servicePerformance:
        return 'Popular services & trends';
      case ReportType.technicianPerformance:
        return 'Staff productivity metrics';
      case ReportType.customerAnalytics:
        return 'Customer insights & behavior';
      case ReportType.appointmentAnalytics:
        return 'Booking patterns & trends';
      case ReportType.paymentAnalytics:
        return 'Payment methods & processing';
    }
  }

  IconData _getReportIcon() {
    switch (reportType) {
      case ReportType.revenue:
        return Icons.attach_money;
      case ReportType.servicePerformance:
        return Icons.trending_up;
      case ReportType.technicianPerformance:
        return Icons.people;
      case ReportType.customerAnalytics:
        return Icons.groups;
      case ReportType.appointmentAnalytics:
        return Icons.event;
      case ReportType.paymentAnalytics:
        return Icons.payment;
    }
  }

  Color _getReportColor() {
    switch (reportType) {
      case ReportType.revenue:
        return AppColors.successGreen;
      case ReportType.servicePerformance:
        return AppColors.primaryBlue;
      case ReportType.technicianPerformance:
        return AppColors.servicePurple;
      case ReportType.customerAnalytics:
        return AppColors.serviceOrange;
      case ReportType.appointmentAnalytics:
        return AppColors.serviceTeal;
      case ReportType.paymentAnalytics:
        return AppColors.warningOrange;
    }
  }
}