// lib/features/reports/presentation/widgets/report_detail_view.dart
// Detailed report view widget providing comprehensive data visualization and metrics for specific report types.
// Displays full-screen report layouts with metric grids, chart placeholders, and interactive refresh functionality.
// Usage: ACTIVE - Used when drilling down into specific report details from report cards

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/report_data.dart';

/// Detailed view for individual reports with full data visualization
/// Follows UI Bible principles: const constructors, RepaintBoundary
class ReportDetailView extends StatelessWidget {
  final ReportType reportType;
  final ReportData? reportData;
  final bool isLoading;
  final String? error;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const ReportDetailView({
    super.key,
    required this.reportType,
    required this.reportData,
    required this.isLoading,
    required this.error,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with back button
          RepaintBoundary(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back to Reports',
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getReportTitle(),
                          style: AppTextStyles.headline2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getReportSubtitle(),
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: isLoading ? null : onRefresh,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    tooltip: 'Refresh Report',
                  ),
                ],
              ),
            ),
          ),

          // Content area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading report data...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.errorRed,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load report',
                style: AppTextStyles.headline3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (reportData == null) {
      return const Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                color: AppColors.textLight,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No data available',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildReportContent();
  }

  Widget _buildReportContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: reportData!.when(
        revenue: (totalRevenue, todayRevenue, yesterdayRevenue, weekRevenue, monthRevenue, dailyData, topServices) {
          return _buildRevenueReport(
            totalRevenue: totalRevenue,
            todayRevenue: todayRevenue,
            yesterdayRevenue: yesterdayRevenue,
            weekRevenue: weekRevenue,
            monthRevenue: monthRevenue,
          );
        },
        servicePerformance: (serviceMetrics, totalServicesCompleted, averageServiceValue, trends) {
          return _buildServicePerformanceReport(
            totalServicesCompleted: totalServicesCompleted,
            averageServiceValue: averageServiceValue,
          );
        },
        technicianPerformance: (technicianMetrics, totalAppointments, averageRating, revenueByTechnician) {
          return _buildTechnicianPerformanceReport(
            totalAppointments: totalAppointments,
            averageRating: averageRating,
          );
        },
        customerAnalytics: (totalCustomers, newCustomersThisMonth, returningCustomers, averageVisitValue, segments, retentionData) {
          return _buildCustomerAnalyticsReport(
            totalCustomers: totalCustomers,
            newCustomersThisMonth: newCustomersThisMonth,
            returningCustomers: returningCustomers,
            averageVisitValue: averageVisitValue,
          );
        },
        appointmentAnalytics: (totalAppointments, completedAppointments, cancelledAppointments, showUpRate, bookingPatterns, typeDistribution) {
          return _buildAppointmentAnalyticsReport(
            totalAppointments: totalAppointments,
            completedAppointments: completedAppointments,
            cancelledAppointments: cancelledAppointments,
            showUpRate: showUpRate,
          );
        },
        paymentAnalytics: (totalPayments, paymentMethodBreakdown, averageTransactionAmount, trends, tipsTotal) {
          return _buildPaymentAnalyticsReport(
            totalPayments: totalPayments,
            paymentMethodBreakdown: paymentMethodBreakdown,
            averageTransactionAmount: averageTransactionAmount,
            tipsTotal: tipsTotal,
          );
        },
      ),
    );
  }

  Widget _buildRevenueReport({
    required double totalRevenue,
    required double todayRevenue,
    required double yesterdayRevenue,
    required double weekRevenue,
    required double monthRevenue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary cards
        _buildMetricsGrid([
          _MetricCard(
            title: 'Total Revenue',
            value: '\$${totalRevenue.toStringAsFixed(2)}',
            color: AppColors.successGreen,
            icon: Icons.attach_money,
          ),
          _MetricCard(
            title: 'Today\'s Revenue',
            value: '\$${todayRevenue.toStringAsFixed(2)}',
            color: AppColors.primaryBlue,
            icon: Icons.today,
          ),
          _MetricCard(
            title: 'This Week',
            value: '\$${weekRevenue.toStringAsFixed(2)}',
            color: AppColors.serviceTeal,
            icon: Icons.date_range,
          ),
          _MetricCard(
            title: 'This Month',
            value: '\$${monthRevenue.toStringAsFixed(2)}',
            color: AppColors.servicePurple,
            icon: Icons.calendar_month,
          ),
        ]),

        const SizedBox(height: 32),

        // Revenue trend chart placeholder
        _buildChartSection(
          title: 'Revenue Trend',
          description: 'Daily revenue over the selected period',
          child: _buildChartPlaceholder('Revenue trend chart will be displayed here'),
        ),

        const SizedBox(height: 32),

        // Top services section
        _buildChartSection(
          title: 'Top Revenue-Generating Services',
          description: 'Services contributing most to total revenue',
          child: _buildChartPlaceholder('Top services chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildServicePerformanceReport({
    required int totalServicesCompleted,
    required double averageServiceValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsGrid([
          _MetricCard(
            title: 'Services Completed',
            value: totalServicesCompleted.toString(),
            color: AppColors.primaryBlue,
            icon: Icons.check_circle,
          ),
          _MetricCard(
            title: 'Average Service Value',
            value: '\$${averageServiceValue.toStringAsFixed(2)}',
            color: AppColors.successGreen,
            icon: Icons.trending_up,
          ),
          _MetricCard(
            title: 'Growth Rate',
            value: '+12.5%',
            color: AppColors.serviceTeal,
            icon: Icons.show_chart,
          ),
        ]),
        const SizedBox(height: 32),
        _buildChartSection(
          title: 'Service Performance Metrics',
          description: 'Popularity and revenue metrics for each service',
          child: _buildChartPlaceholder('Service performance chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildTechnicianPerformanceReport({
    required int totalAppointments,
    required double averageRating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsGrid([
          _MetricCard(
            title: 'Total Appointments',
            value: totalAppointments.toString(),
            color: AppColors.servicePurple,
            icon: Icons.event,
          ),
          _MetricCard(
            title: 'Average Rating',
            value: '${averageRating.toStringAsFixed(1)} ★',
            color: AppColors.warningOrange,
            icon: Icons.star,
          ),
          _MetricCard(
            title: 'Performance Growth',
            value: '+8.3%',
            color: AppColors.successGreen,
            icon: Icons.trending_up,
          ),
        ]),
        const SizedBox(height: 32),
        _buildChartSection(
          title: 'Staff Performance Overview',
          description: 'Individual technician metrics and productivity',
          child: _buildChartPlaceholder('Staff performance chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildCustomerAnalyticsReport({
    required int totalCustomers,
    required int newCustomersThisMonth,
    required int returningCustomers,
    required double averageVisitValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsGrid([
          _MetricCard(
            title: 'Total Customers',
            value: totalCustomers.toString(),
            color: AppColors.serviceOrange,
            icon: Icons.people,
          ),
          _MetricCard(
            title: 'New This Month',
            value: newCustomersThisMonth.toString(),
            color: AppColors.successGreen,
            icon: Icons.person_add,
          ),
          _MetricCard(
            title: 'Returning Customers',
            value: returningCustomers.toString(),
            color: AppColors.primaryBlue,
            icon: Icons.repeat,
          ),
          _MetricCard(
            title: 'Avg Visit Value',
            value: '\$${averageVisitValue.toStringAsFixed(2)}',
            color: AppColors.serviceTeal,
            icon: Icons.attach_money,
          ),
        ]),
        const SizedBox(height: 32),
        _buildChartSection(
          title: 'Customer Insights',
          description: 'Customer behavior patterns and segmentation',
          child: _buildChartPlaceholder('Customer analytics chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildAppointmentAnalyticsReport({
    required int totalAppointments,
    required int completedAppointments,
    required int cancelledAppointments,
    required double showUpRate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsGrid([
          _MetricCard(
            title: 'Total Appointments',
            value: totalAppointments.toString(),
            color: AppColors.serviceTeal,
            icon: Icons.event,
          ),
          _MetricCard(
            title: 'Completed',
            value: completedAppointments.toString(),
            color: AppColors.successGreen,
            icon: Icons.check,
          ),
          _MetricCard(
            title: 'Cancelled',
            value: cancelledAppointments.toString(),
            color: AppColors.errorRed,
            icon: Icons.cancel,
          ),
          _MetricCard(
            title: 'Show-up Rate',
            value: '${showUpRate.toStringAsFixed(1)}%',
            color: AppColors.primaryBlue,
            icon: Icons.trending_up,
          ),
        ]),
        const SizedBox(height: 32),
        _buildChartSection(
          title: 'Appointment Patterns',
          description: 'Booking trends and scheduling insights',
          child: _buildChartPlaceholder('Appointment analytics chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildPaymentAnalyticsReport({
    required double totalPayments,
    required Map<String, double> paymentMethodBreakdown,
    required double averageTransactionAmount,
    required double tipsTotal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsGrid([
          _MetricCard(
            title: 'Total Payments',
            value: '\$${totalPayments.toStringAsFixed(2)}',
            color: AppColors.warningOrange,
            icon: Icons.payment,
          ),
          _MetricCard(
            title: 'Avg Transaction',
            value: '\$${averageTransactionAmount.toStringAsFixed(2)}',
            color: AppColors.primaryBlue,
            icon: Icons.receipt,
          ),
          _MetricCard(
            title: 'Total Tips',
            value: '\$${tipsTotal.toStringAsFixed(2)}',
            color: AppColors.successGreen,
            icon: Icons.volunteer_activism,
          ),
        ]),
        const SizedBox(height: 32),
        _buildChartSection(
          title: 'Payment Method Breakdown',
          description: 'Distribution of payment methods used',
          child: _buildChartPlaceholder('Payment method chart will be displayed here'),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(List<_MetricCard> metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const minCardWidth = 200.0;
        const cardSpacing = 16.0;
        final availableWidth = constraints.maxWidth - cardSpacing;
        final columns = (availableWidth / (minCardWidth + cardSpacing)).floor().clamp(1, 4);
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: cardSpacing,
            mainAxisSpacing: cardSpacing,
            childAspectRatio: 2.5,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) => metrics[index],
        );
      },
    );
  }

  Widget _buildChartSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder(String message) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_chart_outlined,
              size: 48,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getReportTitle() {
    switch (reportType) {
      case ReportType.revenue:
        return 'Revenue Report';
      case ReportType.servicePerformance:
        return 'Service Performance';
      case ReportType.technicianPerformance:
        return 'Staff Performance';
      case ReportType.customerAnalytics:
        return 'Customer Analytics';
      case ReportType.appointmentAnalytics:
        return 'Appointment Analytics';
      case ReportType.paymentAnalytics:
        return 'Payment Analytics';
    }
  }

  String _getReportSubtitle() {
    switch (reportType) {
      case ReportType.revenue:
        return 'Detailed revenue breakdown and trends';
      case ReportType.servicePerformance:
        return 'Service popularity and performance metrics';
      case ReportType.technicianPerformance:
        return 'Staff productivity and performance analysis';
      case ReportType.customerAnalytics:
        return 'Customer behavior and retention insights';
      case ReportType.appointmentAnalytics:
        return 'Booking patterns and appointment insights';
      case ReportType.paymentAnalytics:
        return 'Payment processing and method analysis';
    }
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}