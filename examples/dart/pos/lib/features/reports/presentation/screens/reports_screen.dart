// lib/features/reports/presentation/screens/reports_screen.dart
// Comprehensive reports dashboard with tabbed navigation between Business Overview and Sales Reports. Manages MobX ReportsStore initialization, date range selection, and data loading with error handling and refresh capabilities.
// Usage: ACTIVE - Main reports hub providing access to all business analytics and sales data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../data/models/report_data.dart';
import '../../data/models/report_data_extensions.dart';
import '../../providers/reports_providers.dart';
import '../widgets/report_time_range_selector.dart';
import '../widgets/report_detail_view.dart';
import 'business_overview_screen.dart';
import 'sales_reports_screen.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  
  // Section state management
  String? _selectedSection; // 'business', 'sales', 'employee', 'customer'
  String _selectedTab = '';  // Current tab within selected section

  // Define tabs for each section
  final Map<String, List<String>> _sectionTabs = {
    'business': [], // No tabs - shows overview directly
    'sales': ['Sales Summary', 'By Category', 'By Service', 'Ticket Details', 'Refunds', 'Discounts'],
    'employee': ['Overview', 'Sales Summary', 'Service Details', 'Tips Report', 'Commission', 'Performance'],
    'customer': ['Overview', 'Demographics', 'Loyalty & Retention', 'Preferences', 'Satisfaction'],
  };

  @override
  void initState() {
    super.initState();
    // Riverpod providers handle initialization automatically
  }
  
  void _selectSection(String section) {
    setState(() {
      _selectedSection = section;
      // Set default tab for the section
      final tabs = _sectionTabs[section] ?? [];
      _selectedTab = tabs.isNotEmpty ? tabs.first : '';
    });
  }
  
  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const StandardAppHeader(
        title: 'Reports',
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final selectedReportType = ref.watch(selectedReportTypeProvider);
          
          // If a report is selected, show detail view
          if (selectedReportType != null) {
            final reportDataAsync = ref.watch(reportDataProvider(selectedReportType));
            
            return ReportDetailView(
              reportType: selectedReportType,
              reportData: reportDataAsync.value,
              isLoading: reportDataAsync.isLoading,
              error: reportDataAsync.error?.toString(),
              onBack: () => ref.read(selectedReportTypeProvider.notifier).clearSelection(),
              onRefresh: () => ref.invalidate(reportDataProvider(selectedReportType)),
            );
          }

          // Show reports overview
          return Column(
            children: [
              // Time range selector
              RepaintBoundary(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final selectedTimeRange = ref.watch(reportTimeRangeNotifierProvider);
                      return ReportTimeRangeSelector(
                        selectedRange: selectedTimeRange,
                        onRangeChanged: (range) => ref.read(reportTimeRangeNotifierProvider.notifier).setTimeRange(range),
                        onCustomRangeSelected: (start, end) => ref.read(reportTimeRangeNotifierProvider.notifier).setCustomRange(start, end),
                      );
                    },
                  ),
                ),
              ),

              // KPI Cards Row
              Consumer(
                builder: (context, ref, _) => _buildKpiCards(ref),
              ),

              // Main Reports Section
              Expanded(
                child: _buildMainReportsSection(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKpiCards(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.surface,
      child: Consumer(
        builder: (context, ref, _) {
          // Get revenue data from provider
          final revenueDataAsync = ref.watch(reportDataProvider(ReportType.revenue));
          final revenueData = revenueDataAsync.value?.asRevenue;
          final todayRevenue = revenueData?.todayRevenue ?? 0.0;
          final yesterdayRevenue = revenueData?.yesterdayRevenue ?? 0.0;
          
          // Calculate revenue change percentage
          final revenueChange = yesterdayRevenue > 0 
              ? ((todayRevenue - yesterdayRevenue) / yesterdayRevenue * 100)
              : 0.0;
          
          // Get payment analytics for ticket count
          final paymentDataAsync = ref.watch(reportDataProvider(ReportType.paymentAnalytics));
          final paymentData = paymentDataAsync.value?.asPaymentAnalytics;
          final todayTransactions = paymentData?.totalPayments.toInt() ?? 0;
          
          // Calculate average ticket value
          final avgTicketValue = todayTransactions > 0 
              ? todayRevenue / todayTransactions
              : 0.0;
          
          return Row(
            children: [
              Expanded(child: _buildKpiCard(
                title: "Today's Revenue",
                value: '\$${todayRevenue.toStringAsFixed(0)}',
                change: "${revenueChange >= 0 ? '+' : ''}${revenueChange.toStringAsFixed(1)}%",
                icon: Icons.attach_money,
                isPositive: revenueChange >= 0,
              ),),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard(
                title: 'Tickets Today',
                value: '${todayTransactions.toInt()}',
                change: '+8.3%', // TODO: Calculate from historical data
                icon: Icons.receipt,
                isPositive: true,
              ),),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard(
                title: 'Avg Ticket Value',
                value: '\$${avgTicketValue.toStringAsFixed(2)}',
                change: '+3.2%', // TODO: Calculate from historical data
                icon: Icons.trending_up,
                isPositive: true,
              ),),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard(
                title: 'Active Employees',
                value: '8', // TODO: Get from employee repository
                change: '0%',
                icon: Icons.people,
                isPositive: true,
              ),),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                fontSize: 12,
              ),),
              const Spacer(),
              Icon(icon, color: AppColors.textSecondary, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(value, style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(change, style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainReportsSection() {
    return Container(
      color: AppColors.background,
      child: Row(
        children: [
          // Left side - Report section buttons
          Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildReportSectionButton(
                  title: 'Business Overview',
                  description: 'Key metrics and performance dashboards',
                  subtitle: 'Active Metrics: 12',
                  icon: Icons.dashboard,
                  isSelected: _selectedSection == 'business',
                  onTap: () => _selectSection('business'),
                ),
                const SizedBox(height: 16),
                _buildReportSectionButton(
                  title: 'Sales Reports',
                  description: 'Revenue, transactions, and sales analytics',
                  subtitle: "Today's Sales: \$3,245",
                  icon: Icons.trending_up,
                  isSelected: _selectedSection == 'sales',
                  onTap: () => _selectSection('sales'),
                ),
                const SizedBox(height: 16),
                _buildReportSectionButton(
                  title: 'Employee Reports',
                  description: 'Staff performance, commissions, and productivity',
                  subtitle: 'Active Staff: 8',
                  icon: Icons.people,
                  isSelected: _selectedSection == 'employee',
                  onTap: () => _selectSection('employee'),
                ),
                const SizedBox(height: 16),
                _buildReportSectionButton(
                  title: 'Customer Reports',
                  description: 'Client analytics, retention, and preferences',
                  subtitle: 'Total Clients: 1,234',
                  icon: Icons.person,
                  isSelected: _selectedSection == 'customer',
                  onTap: () => _selectSection('customer'),
                ),
              ],
            ),
          ),
          
          // Right side - Selected report content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedReportContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSectionButton({
    required String title,
    required String description,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          subtitle.split(':')[0] + ':',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subtitle.split(':')[1].trim(),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedReportContent() {
    if (_selectedSection == null) {
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
            Text(
              'Current View:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'overview',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            const Expanded(
              child: Center(
                child: Text(
                  'Select a report section to view details',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with section title and actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current View:',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedSection!,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 16),
                      label: const Text('Filter'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Export'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sub-navigation tabs (if any)
          if (_sectionTabs[_selectedSection]?.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sectionTabs[_selectedSection]!
                      .map((tab) => _buildTabButton(tab))
                      .toList(),
                ),
              ),
            ),

          // Content area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _buildSectionContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab) {
    final isSelected = _selectedTab == tab;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: () => _selectTab(tab),
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
          backgroundColor: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          tab,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 'business':
        return _buildBusinessOverviewContent();
      case 'sales':
        return _buildSalesReportsContent();
      case 'employee':
        return _buildEmployeeReportsContent();
      case 'customer':
        return _buildCustomerReportsContent();
      default:
        return const Center(
          child: Text(
            'Content not implemented yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        );
    }
  }

  Widget _buildBusinessOverviewContent() {
    // Use the separate Business Overview screen widget
    // TODO: Convert BusinessOverviewScreen to Riverpod
    return const Center(
      child: Text(
        'Business Overview\nConversion to Riverpod pending',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSalesReportsContent() {
    // Use the separate Sales Reports screen widget  
    // TODO: Convert SalesReportsScreen to Riverpod
    return Center(
      child: Text(
        'Sales Reports: $_selectedTab\nConversion to Riverpod pending',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _buildEmployeeReportsContent() {
    return Center(
      child: Text(
        'Employee Reports: $_selectedTab\nContent for this tab would go here',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCustomerReportsContent() {
    switch (_selectedTab) {
      case 'Overview':
        return _buildCustomerOverviewTab();
      case 'Demographics':
        return _buildCustomerDemographicsTab();
      case 'Loyalty & Retention':
        return _buildCustomerRetentionTab();
      default:
        return Center(
          child: Text(
            'Customer Reports: $_selectedTab\nContent for this tab would go here',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        );
    }
  }

  Widget _buildCustomerOverviewTab() {
    return Consumer(
      builder: (context, ref, _) {
        final customerDataAsync = ref.watch(reportDataProvider(ReportType.customerAnalytics));
        final customerData = customerDataAsync.value?.asCustomerAnalytics;
        
        if (customerData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Customer Metrics Cards
              Row(
                children: [
                  Expanded(child: _buildKpiCard(
                    title: 'Total Customers',
                    value: '${customerData.totalCustomers}',
                    change: '+5.2%', // TODO: Calculate from historical data
                    icon: Icons.people,
                    isPositive: true,
                  ),),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard(
                    title: 'New This Month',
                    value: '${customerData.newCustomersThisMonth}',
                    change: '+12.3%', // TODO: Calculate from historical data
                    icon: Icons.person_add,
                    isPositive: true,
                  ),),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard(
                    title: 'Returning Customers',
                    value: '${customerData.returningCustomers}',
                    change: '+8.1%', // TODO: Calculate from historical data
                    icon: Icons.repeat,
                    isPositive: true,
                  ),),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildKpiCard(
                    title: 'Retention Rate',
                    value: '${((customerData.returningCustomers / customerData.totalCustomers) * 100).toStringAsFixed(1)}%',
                    change: '+2.5%', // TODO: Calculate from historical data
                    icon: Icons.trending_up,
                    isPositive: true,
                  ),),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard(
                    title: 'Avg Visit Value',
                    value: '\$${customerData.averageVisitValue.toStringAsFixed(2)}',
                    change: '+15.3%', // TODO: Calculate from historical data
                    icon: Icons.attach_money,
                    isPositive: true,
                  ),),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard(
                    title: 'Active Customers',
                    value: '${(customerData.totalCustomers * 0.6).toInt()}', // Estimate
                    change: '+7.8%', // TODO: Calculate from historical data
                    icon: Icons.person,
                    isPositive: true,
                  ),),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Customer Growth Trend Chart Placeholder
              Container(
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
                    Text(
                      'Customer Growth Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Chart implementation pending\n(Line chart showing customer growth over time)',
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerDemographicsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Age Distribution Chart
          Container(
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
                Text(
                  'Customer Age Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Mock age distribution data
                ..._buildAgeDistributionBars(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Visit Frequency Distribution
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visit Frequency Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildFrequencyItem('Weekly', 156, 12.6),
                _buildFrequencyItem('Bi-weekly', 312, 25.3),
                _buildFrequencyItem('Monthly', 468, 37.9),
                _buildFrequencyItem('Quarterly', 234, 19.0),
                _buildFrequencyItem('Rarely', 64, 5.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAgeDistributionBars() {
    final ageGroups = [
      ('18-24', 85, 65.0),
      ('25-34', 156, 85.0),
      ('35-44', 234, 95.0),
      ('45-54', 189, 110.0),
      ('55+', 98, 125.0),
    ];

    return ageGroups.map((group) {
      final label = group.$1;
      final customers = group.$2;
      final avgSpend = group.$3;
      final percentage = (customers / 762) * 100; // Total customers estimate
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$customers customers (${percentage.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: percentage / 100,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Avg spend: \$${avgSpend.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFrequencyItem(String frequency, int count, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              frequency,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$count',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                widthFactor: percentage / 100,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRetentionTab() {
    return const Center(
      child: Text(
        'Customer Loyalty & Retention\nShowing retention metrics and loyalty program data',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }


}