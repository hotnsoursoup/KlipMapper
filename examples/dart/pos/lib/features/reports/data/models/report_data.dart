// lib/features/reports/data/models/report_data.dart
// Comprehensive reporting models using Freezed for revenue, performance, and analytics data.
// Includes union types for different report categories with associated metrics and trend analysis.
// Usage: ACTIVE - Business analytics, performance tracking, and comprehensive reporting system

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_data.freezed.dart';
part 'report_data.g.dart';

/// Base class for all report data
@freezed
abstract class ReportData with _$ReportData {
  const factory ReportData.revenue({
    required double totalRevenue,
    required double todayRevenue,
    required double yesterdayRevenue,
    required double weekRevenue,
    required double monthRevenue,
    required List<DailyRevenue> dailyData,
    required List<ServiceRevenue> topServices,
  }) = RevenueReportData;

  const factory ReportData.servicePerformance({
    required List<ServiceMetrics> serviceMetrics,
    required int totalServicesCompleted,
    required double averageServiceValue,
    required List<ServiceTrend> trends,
  }) = ServicePerformanceReportData;

  const factory ReportData.technicianPerformance({
    required List<TechnicianMetrics> technicianMetrics,
    required int totalAppointments,
    required double averageRating,
    required List<TechnicianRevenue> revenueByTechnician,
  }) = TechnicianPerformanceReportData;

  const factory ReportData.customerAnalytics({
    required int totalCustomers,
    required int newCustomersThisMonth,
    required int returningCustomers,
    required double averageVisitValue,
    required List<CustomerSegment> segments,
    required List<CustomerRetention> retentionData,
  }) = CustomerAnalyticsReportData;

  const factory ReportData.appointmentAnalytics({
    required int totalAppointments,
    required int completedAppointments,
    required int cancelledAppointments,
    required double showUpRate,
    required List<HourlyBooking> bookingPatterns,
    required List<AppointmentType> typeDistribution,
  }) = AppointmentAnalyticsReportData;

  const factory ReportData.paymentAnalytics({
    required double totalPayments,
    required Map<String, double> paymentMethodBreakdown,
    required double averageTransactionAmount,
    required List<PaymentTrend> trends,
    required double tipsTotal,
  }) = PaymentAnalyticsReportData;
}

@freezed
class DailyRevenue with _$DailyRevenue {
  const factory DailyRevenue({
    required DateTime date,
    required double revenue,
    required int serviceCount,
  }) = _DailyRevenue;

  factory DailyRevenue.fromJson(Map<String, dynamic> json) => _$DailyRevenueFromJson(json);
}

@freezed
class ServiceRevenue with _$ServiceRevenue {
  const factory ServiceRevenue({
    required String serviceName,
    required double revenue,
    required int count,
    required double percentage,
  }) = _ServiceRevenue;

  factory ServiceRevenue.fromJson(Map<String, dynamic> json) => _$ServiceRevenueFromJson(json);
}

@freezed
class ServiceMetrics with _$ServiceMetrics {
  const factory ServiceMetrics({
    required String serviceName,
    required int timesBooked,
    required double revenue,
    required double averageRating,
    required int durationMinutes,
  }) = _ServiceMetrics;

  factory ServiceMetrics.fromJson(Map<String, dynamic> json) => _$ServiceMetricsFromJson(json);
}

@freezed
class ServiceTrend with _$ServiceTrend {
  const factory ServiceTrend({
    required String serviceName,
    required List<TrendPoint> dataPoints,
    required double growthRate,
  }) = _ServiceTrend;

  factory ServiceTrend.fromJson(Map<String, dynamic> json) => _$ServiceTrendFromJson(json);
}

@freezed
class TechnicianMetrics with _$TechnicianMetrics {
  const factory TechnicianMetrics({
    required String technicianName,
    required int appointmentsCompleted,
    required double totalRevenue,
    required double averageRating,
    required double utilizationRate,
  }) = _TechnicianMetrics;

  factory TechnicianMetrics.fromJson(Map<String, dynamic> json) => _$TechnicianMetricsFromJson(json);
}

@freezed
class TechnicianRevenue with _$TechnicianRevenue {
  const factory TechnicianRevenue({
    required String technicianName,
    required double revenue,
    required List<DailyRevenue> dailyBreakdown,
  }) = _TechnicianRevenue;

  factory TechnicianRevenue.fromJson(Map<String, dynamic> json) => _$TechnicianRevenueFromJson(json);
}

@freezed
class CustomerSegment with _$CustomerSegment {
  const factory CustomerSegment({
    required String segment,
    required int count,
    required double percentage,
    required double averageSpend,
  }) = _CustomerSegment;

  factory CustomerSegment.fromJson(Map<String, dynamic> json) => _$CustomerSegmentFromJson(json);
}

@freezed
class CustomerRetention with _$CustomerRetention {
  const factory CustomerRetention({
    required DateTime month,
    required double retentionRate,
    required int newCustomers,
    required int returningCustomers,
  }) = _CustomerRetention;

  factory CustomerRetention.fromJson(Map<String, dynamic> json) => _$CustomerRetentionFromJson(json);
}

@freezed
class HourlyBooking with _$HourlyBooking {
  const factory HourlyBooking({
    required int hour,
    required int bookingCount,
    required double percentage,
  }) = _HourlyBooking;

  factory HourlyBooking.fromJson(Map<String, dynamic> json) => _$HourlyBookingFromJson(json);
}

@freezed
class AppointmentType with _$AppointmentType {
  const factory AppointmentType({
    required String type,
    required int count,
    required double percentage,
  }) = _AppointmentType;

  factory AppointmentType.fromJson(Map<String, dynamic> json) => _$AppointmentTypeFromJson(json);
}

@freezed
class PaymentTrend with _$PaymentTrend {
  const factory PaymentTrend({
    required DateTime date,
    required double amount,
    required String paymentMethod,
  }) = _PaymentTrend;

  factory PaymentTrend.fromJson(Map<String, dynamic> json) => _$PaymentTrendFromJson(json);
}

@freezed
class TrendPoint with _$TrendPoint {
  const factory TrendPoint({
    required DateTime date,
    required double value,
  }) = _TrendPoint;

  factory TrendPoint.fromJson(Map<String, dynamic> json) => _$TrendPointFromJson(json);
}

/// Report type enumeration
enum ReportType {
  revenue,
  servicePerformance,
  technicianPerformance,
  customerAnalytics,
  appointmentAnalytics,
  paymentAnalytics,
}

/// Report time range enumeration
enum ReportTimeRange {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  thisYear,
  custom,
}