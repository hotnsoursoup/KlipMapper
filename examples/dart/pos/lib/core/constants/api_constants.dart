// lib/core/constants/api_constants.dart
// API constants and endpoints for external service integration. Defines base URLs, authentication endpoints, and resource paths for potential future API connectivity.
// Usage: ORPHANED - API integration not currently implemented, app uses local database only

/// API constants and endpoints
class ApiConstants {
  ApiConstants._();

  // Base URL - change this based on environment
  static const String baseUrl = 'http://localhost:8096/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Customer endpoints
  static const String customers = '/customers';
  static String customerById(String id) => '/customers/$id';
  static const String customerSearch = '/customers/search';

  // Employee endpoints (was technicians)
  static const String employees = '/employees';
  static String employeeById(String id) => '/employees/$id';
  static const String employeeStatus = '/employee-status';

  // Service endpoints
  static const String services = '/services';
  static String serviceById(String id) => '/services/$id';
  static const String serviceCategories = '/service-categories';

  // Ticket endpoints
  static const String tickets = '/tickets';
  static String ticketById(String id) => '/tickets/$id';
  static const String ticketQueue = '/tickets/queue';
  static String ticketAssign(String id) => '/tickets/$id/assign';
  static String ticketCheckout(String id) => '/tickets/$id/checkout';

  // Payment endpoints
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';

  // Appointment endpoints
  static const String appointments = '/appointments';
  static String appointmentById(String id) => '/appointments/$id';
  static const String appointmentUpcoming = '/appointments/upcoming';
  static String appointmentCheckIn(String id) => '/appointments/$id/check-in';
  static const String appointmentAvailability =
      '/appointments/check-availability';

  // Location endpoints
  static const String locations = '/locations';
  static String locationById(String id) => '/locations/$id';

  // Settings endpoints
  static const String settings = '/settings';
  static const String businessInfo = '/settings/business';

  // Reports endpoints
  static const String reports = '/reports';
  static const String reportsSales = '/reports/sales';
  static const String reportsCustomers = '/reports/customers';
  static const String reportsTechnicians = '/reports/technicians';

  // Sync endpoints
  static const String syncStatus = '/sync/status';
  static const String syncBatch = '/sync/batch';
}
