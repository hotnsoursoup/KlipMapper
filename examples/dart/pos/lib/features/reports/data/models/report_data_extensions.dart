// lib/features/reports/data/models/report_data_extensions.dart
// Extension methods providing type-safe access to Freezed union report data types.
// Enables safe casting to specific report data variants without runtime errors.
// Usage: ACTIVE - Type-safe report data access, UI component data binding, and analytics processing

import 'report_data.dart';

/// Extension methods to safely access Freezed union types
/// These provide compile-time safe access to specific report data types
extension ReportDataExtensions on ReportData {
  /// Safely cast to RevenueReportData or return null
  RevenueReportData? get asRevenue => 
      this is RevenueReportData ? this as RevenueReportData : null;

  /// Safely cast to ServicePerformanceReportData or return null
  ServicePerformanceReportData? get asServicePerformance => 
      this is ServicePerformanceReportData ? this as ServicePerformanceReportData : null;

  /// Safely cast to TechnicianPerformanceReportData or return null
  TechnicianPerformanceReportData? get asTechnicianPerformance => 
      this is TechnicianPerformanceReportData ? this as TechnicianPerformanceReportData : null;

  /// Safely cast to CustomerAnalyticsReportData or return null
  CustomerAnalyticsReportData? get asCustomerAnalytics => 
      this is CustomerAnalyticsReportData ? this as CustomerAnalyticsReportData : null;

  /// Safely cast to AppointmentAnalyticsReportData or return null
  AppointmentAnalyticsReportData? get asAppointmentAnalytics => 
      this is AppointmentAnalyticsReportData ? this as AppointmentAnalyticsReportData : null;

  /// Safely cast to PaymentAnalyticsReportData or return null
  PaymentAnalyticsReportData? get asPaymentAnalytics => 
      this is PaymentAnalyticsReportData ? this as PaymentAnalyticsReportData : null;
}