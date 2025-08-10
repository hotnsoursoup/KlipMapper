// lib/features/reports/providers/reports_providers.dart
// Comprehensive reports providers for business analytics, revenue tracking, and performance metrics using Riverpod state management.
// Includes revenue data, technician performance, customer analytics, appointment tracking, and payment analysis with caching support.
// Usage: ACTIVE - Primary reports state management for business overview and analytics dashboard

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/report_data.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../shared/data/repositories/drift_customer_repository.dart';
import '../../shared/data/repositories/drift_payment_repository.dart';
import '../../shared/data/repositories/drift_appointment_repository.dart';
import '../../shared/data/repositories/drift_employee_repository.dart';
import '../../../core/utils/app_logger.dart';

part 'reports_providers.g.dart';
part 'reports_providers.freezed.dart';

// ========== REPOSITORY PROVIDERS ==========

@Riverpod(keepAlive: true)
DriftTicketRepository reportsTicketRepository(Ref ref) {
  return DriftTicketRepository.instance;
}

@Riverpod(keepAlive: true)
DriftCustomerRepository reportsCustomerRepository(Ref ref) {
  return DriftCustomerRepository.instance;
}

@Riverpod(keepAlive: true)
DriftPaymentRepository reportsPaymentRepository(Ref ref) {
  return DriftPaymentRepository.instance;
}

@Riverpod(keepAlive: true)
DriftAppointmentRepository reportsAppointmentRepository(Ref ref) {
  return DriftAppointmentRepository.instance;
}

@Riverpod(keepAlive: true)
DriftEmployeeRepository reportsEmployeeRepository(Ref ref) {
  return DriftEmployeeRepository.instance;
}

// ========== TIME RANGE MANAGEMENT ==========

@riverpod
class ReportsTimeRange extends _$ReportsTimeRange {
  @override
  ReportsTimeRangeState build() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));
    
    return ReportsTimeRangeState(
      startDate: startOfToday,
      endDate: endOfToday,
      selectedRange: ReportsTimeRangeType.today,
    );
  }
  
  void selectRange(ReportsTimeRangeType range) {
    final now = DateTime.now();
    late DateTime startDate;
    late DateTime endDate;
    
    switch (range) {
      case ReportsTimeRangeType.today:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case ReportsTimeRangeType.thisWeek:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = startDate.add(const Duration(days: 7));
        break;
      case ReportsTimeRangeType.thisMonth:
        startDate = DateTime(now.year, now.month);
        endDate = DateTime(now.year, now.month + 1);
        break;
      case ReportsTimeRangeType.thisYear:
        startDate = DateTime(now.year);
        endDate = DateTime(now.year + 1);
        break;
    }
    
    state = ReportsTimeRangeState(
      startDate: startDate,
      endDate: endDate,
      selectedRange: range,
    );
    
    AppLogger.logInfo('Reports time range updated to $range: $startDate to $endDate');
  }
  
  void selectCustomRange(DateTime startDate, DateTime endDate) {
    state = ReportsTimeRangeState(
      startDate: startDate,
      endDate: endDate,
      selectedRange: ReportsTimeRangeType.custom,
    );
    
    AppLogger.logInfo('Custom reports time range selected: $startDate to $endDate');
  }
}

// ========== REVENUE REPORTS ==========

@riverpod
Future<RevenueReportData> revenueReport(Ref ref) async {
  final timeRange = ref.watch(reportsTimeRangeProvider);
  final paymentRepo = ref.watch(reportsPaymentRepositoryProvider);
  
  try {
    await paymentRepo.initialize();
    
    // Get payments within the time range
    final payments = await paymentRepo.getPaymentsByDateRange(
      timeRange.startDate,
      timeRange.endDate,
    );
    
    final totalRevenue = payments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    // Calculate daily revenue for trends
    final dailyData = <DailyRevenue>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Simple daily calculation for the last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dayEnd = date.add(const Duration(days: 1));
      
      final dayPayments = payments.where((p) => 
        p.processedAt != null &&
        p.processedAt!.isAfter(date) && 
        p.processedAt!.isBefore(dayEnd)
      );
      
      final dayRevenue = dayPayments.fold<double>(
        0.0, 
        (sum, payment) => sum + (payment.totalAmount ?? 0.0)
      );
      
      dailyData.add(DailyRevenue(
        date: date,
        revenue: dayRevenue,
        serviceCount: dayPayments.length,
      ));
    }
    
    // Today's revenue
    final todayPayments = payments.where((p) => 
      p.processedAt != null &&
      p.processedAt!.isAfter(today) && 
      p.processedAt!.isBefore(today.add(const Duration(days: 1)))
    );
    final todayRevenue = todayPayments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    // Yesterday's revenue
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayPayments = payments.where((p) => 
      p.processedAt != null &&
      p.processedAt!.isAfter(yesterday) && 
      p.processedAt!.isBefore(today)
    );
    final yesterdayRevenue = yesterdayPayments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    // Week revenue
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekPayments = payments.where((p) => 
      p.processedAt != null &&
      p.processedAt!.isAfter(weekStart)
    );
    final weekRevenue = weekPayments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    // Month revenue  
    final monthStart = DateTime(now.year, now.month);
    final monthPayments = payments.where((p) => 
      p.processedAt != null &&
      p.processedAt!.isAfter(monthStart)
    );
    final monthRevenue = monthPayments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    AppLogger.logInfo('Revenue report calculated: Total: \$${totalRevenue.toStringAsFixed(2)}');
    
    return RevenueReportData(
      totalRevenue: totalRevenue,
      todayRevenue: todayRevenue,
      yesterdayRevenue: yesterdayRevenue,
      weekRevenue: weekRevenue,
      monthRevenue: monthRevenue,
      dailyData: dailyData,
      topServices: [], // TODO: Implement service revenue breakdown
    );
  } catch (e, stack) {
    AppLogger.logError('Failed to generate revenue report', e, stack);
    rethrow;
  }
}

// ========== APPOINTMENT ANALYTICS ==========

@riverpod
Future<AppointmentAnalyticsReportData> appointmentAnalytics(Ref ref) async {
  final timeRange = ref.watch(reportsTimeRangeProvider);
  final appointmentRepo = ref.watch(reportsAppointmentRepositoryProvider);
  
  try {
    await appointmentRepo.initialize();
    
    // Get appointments within the time range
    final appointments = await appointmentRepo.getAppointmentsByDateRange(
      timeRange.startDate,
      timeRange.endDate,
    );
    
    final totalAppointments = appointments.length;
    final completedAppointments = appointments.where((a) => a.status == 'completed').length;
    final cancelledAppointments = appointments.where((a) => a.status == 'cancelled').length;
    final noShowAppointments = appointments.where((a) => a.status == 'no-show').length;
    
    final showUpRate = totalAppointments > 0 
      ? ((totalAppointments - noShowAppointments - cancelledAppointments) / totalAppointments) * 100
      : 0.0;
    
    final completionRate = totalAppointments > 0
      ? (completedAppointments / totalAppointments) * 100
      : 0.0;
    
    final cancellationRate = totalAppointments > 0
      ? (cancelledAppointments / totalAppointments) * 100
      : 0.0;
    
    AppLogger.logInfo('Appointment analytics calculated: Total: $totalAppointments, Show-up rate: ${showUpRate.toStringAsFixed(1)}%');
    
    return AppointmentAnalyticsReportData(
      totalAppointments: totalAppointments,
      completedAppointments: completedAppointments,
      cancelledAppointments: cancelledAppointments,
      showUpRate: showUpRate,
      bookingPatterns: [], // TODO: Implement hourly booking patterns
      typeDistribution: [], // TODO: Implement appointment type distribution
    );
  } catch (e, stack) {
    AppLogger.logError('Failed to generate appointment analytics', e, stack);
    rethrow;
  }
}

// ========== CUSTOMER ANALYTICS ==========

@riverpod
Future<CustomerAnalyticsReportData> customerAnalytics(Ref ref) async {
  final timeRange = ref.watch(reportsTimeRangeProvider);
  final customerRepo = ref.watch(reportsCustomerRepositoryProvider);
  
  try {
    await customerRepo.initialize();
    
    // Get all customers
    final customers = await customerRepo.getAllCustomers();
    final totalCustomers = customers.length;
    
    // Get new customers this month
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final newCustomersThisMonth = customers.where((c) => 
      c.createdAt != null && c.createdAt!.isAfter(monthStart)
    ).length;
    
    // Simple returning customers calculation (customers with > 1 visit)
    // TODO: Implement proper visit tracking
    final returningCustomers = (totalCustomers * 0.6).round(); // Placeholder
    
    AppLogger.logInfo('Customer analytics calculated: Total: $totalCustomers, New this month: $newCustomersThisMonth');
    
    return CustomerAnalyticsReportData(
      totalCustomers: totalCustomers,
      newCustomersThisMonth: newCustomersThisMonth,
      returningCustomers: returningCustomers,
      averageVisitValue: 0.0, // TODO: Calculate from tickets
      segments: [], // TODO: Implement customer segmentation
      retentionData: [], // TODO: Implement retention tracking
    );
  } catch (e, stack) {
    AppLogger.logError('Failed to generate customer analytics', e, stack);
    rethrow;
  }
}

// ========== TECHNICIAN PERFORMANCE ==========

@riverpod
Future<TechnicianPerformanceReportData> technicianPerformance(Ref ref) async {
  final employeeRepo = ref.watch(reportsEmployeeRepositoryProvider);
  
  try {
    await employeeRepo.initialize();
    
    // Get all technicians
    final employees = await employeeRepo.getAllEmployees();
    final technicians = employees.where((e) => e.role == 'technician').toList();
    
    AppLogger.logInfo('Technician performance calculated: ${technicians.length} technicians');
    
    return TechnicianPerformanceReportData(
      technicianMetrics: [], // TODO: Implement metrics calculation
      totalAppointments: 0, // TODO: Calculate from appointments
      averageRating: 4.5, // TODO: Calculate from ratings
      revenueByTechnician: [], // TODO: Calculate from payments
    );
  } catch (e, stack) {
    AppLogger.logError('Failed to generate technician performance report', e, stack);
    rethrow;
  }
}

// ========== PAYMENT ANALYTICS ==========

@riverpod
Future<PaymentAnalyticsReportData> paymentAnalytics(Ref ref) async {
  final timeRange = ref.watch(reportsTimeRangeProvider);
  final paymentRepo = ref.watch(reportsPaymentRepositoryProvider);
  
  try {
    await paymentRepo.initialize();
    
    // Get payments within the time range
    final payments = await paymentRepo.getPaymentsByDateRange(
      timeRange.startDate,
      timeRange.endDate,
    );
    
    final totalTransactions = payments.length;
    final totalAmount = payments.fold<double>(
      0.0, 
      (sum, payment) => sum + (payment.totalAmount ?? 0.0)
    );
    
    final averageTransactionAmount = totalTransactions > 0 
      ? totalAmount / totalTransactions 
      : 0.0;
    
    // Calculate payment method breakdown
    final paymentMethods = <String, int>{};
    for (final payment in payments) {
      paymentMethods[payment.paymentMethod] = 
        (paymentMethods[payment.paymentMethod] ?? 0) + 1;
    }
    
    AppLogger.logInfo('Payment analytics calculated: $totalTransactions transactions, avg: \$${averageTransactionAmount.toStringAsFixed(2)}');
    
    // Convert payment method counts to amounts
    final paymentMethodAmounts = <String, double>{};
    for (final entry in paymentMethods.entries) {
      final methodPayments = payments.where((p) => p.paymentMethod == entry.key);
      final methodTotal = methodPayments.fold<double>(
        0.0, 
        (sum, payment) => sum + (payment.totalAmount ?? 0.0)
      );
      paymentMethodAmounts[entry.key] = methodTotal;
    }
    
    return PaymentAnalyticsReportData(
      totalPayments: totalAmount,
      paymentMethodBreakdown: paymentMethodAmounts,
      averageTransactionAmount: averageTransactionAmount,
      trends: [], // TODO: Implement payment trends
      tipsTotal: 0.0, // TODO: Calculate from payment tips
    );
  } catch (e, stack) {
    AppLogger.logError('Failed to generate payment analytics', e, stack);
    rethrow;
  }
}

// ========== CONVENIENCE PROVIDERS ==========

/// Provider for the time range display text
@riverpod
String timeRangeDisplayText(Ref ref) {
  final timeRange = ref.watch(reportsTimeRangeProvider);
  
  switch (timeRange.selectedRange) {
    case ReportsTimeRangeType.today:
      return 'Today';
    case ReportsTimeRangeType.thisWeek:
      return 'This Week';
    case ReportsTimeRangeType.thisMonth:
      return 'This Month';
    case ReportsTimeRangeType.thisYear:
      return 'This Year';
    case ReportsTimeRangeType.custom:
      return 'Custom Range';
  }
}

/// Provider for a combined report cache (similar to the MobX store pattern)
@riverpod
Future<Map<ReportType, ReportData>> reportDataCache(Ref ref) async {
  try {
    final results = await Future.wait([
      ref.watch(revenueReportProvider.future),
      ref.watch(appointmentAnalyticsProvider.future),
      ref.watch(customerAnalyticsProvider.future),
      ref.watch(technicianPerformanceProvider.future),
      ref.watch(paymentAnalyticsProvider.future),
    ]);
    
    return {
      ReportType.revenue: results[0],
      ReportType.appointmentAnalytics: results[1],
      ReportType.customerAnalytics: results[2],
      ReportType.technicianPerformance: results[3],
      ReportType.paymentAnalytics: results[4],
    };
  } catch (e, stack) {
    AppLogger.logError('Failed to generate combined report cache', e, stack);
    return {};
  }
}

/// Provider for selected report type (for detail navigation)
@riverpod
class SelectedReportType extends _$SelectedReportType {
  @override
  ReportType? build() {
    return null;
  }
  
  void selectReport(ReportType reportType) {
    state = reportType;
  }
  
  void clearSelection() {
    state = null;
  }
}

/// Provider for specific report data based on type
@riverpod
Future<ReportData> reportData(Ref ref, ReportType reportType) async {
  switch (reportType) {
    case ReportType.revenue:
      return ref.watch(revenueReportProvider.future);
    case ReportType.appointmentAnalytics:
      return ref.watch(appointmentAnalyticsProvider.future);
    case ReportType.customerAnalytics:
      return ref.watch(customerAnalyticsProvider.future);
    case ReportType.technicianPerformance:
      return ref.watch(technicianPerformanceProvider.future);
    case ReportType.paymentAnalytics:
      return ref.watch(paymentAnalyticsProvider.future);
  }
}

// Compatibility alias for main reports screen
@riverpod
class ReportTimeRangeNotifier extends _$ReportTimeRangeNotifier {
  @override
  ReportsTimeRangeState build() {
    return ref.watch(reportsTimeRangeProvider);
  }
  
  void setTimeRange(ReportsTimeRangeType range) {
    ref.read(reportsTimeRangeProvider.notifier).selectRange(range);
  }
  
  void setCustomRange(DateTime startDate, DateTime endDate) {
    ref.read(reportsTimeRangeProvider.notifier).selectCustomRange(startDate, endDate);
  }
}

// ========== STATE MODELS ==========

@freezed
class ReportsTimeRangeState with _$ReportsTimeRangeState {
  const factory ReportsTimeRangeState({
    required DateTime startDate,
    required DateTime endDate,
    required ReportsTimeRangeType selectedRange,
  }) = _ReportsTimeRangeState;
}

enum ReportsTimeRangeType {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  custom,
}

enum ReportType {
  revenue,
  appointmentAnalytics,
  customerAnalytics,
  technicianPerformance,
  paymentAnalytics,
}