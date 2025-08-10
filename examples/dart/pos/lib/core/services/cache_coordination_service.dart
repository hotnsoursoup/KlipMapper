// lib/core/services/cache_coordination_service.dart
// Riverpod version of cache coordination, invalidating relevant providers when data changes.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/tickets/providers/live_tickets_provider.dart';
import '../../features/appointments/providers/appointment_providers.dart';
import '../../features/customers/providers/customers_provider.dart';
import '../../features/employees/providers/employees_provider.dart';
import '../../features/services/providers/services_provider.dart';
import '../../utils/error_logger.dart';

part 'cache_coordination_service.g.dart';

@Riverpod(keepAlive: true)
class CacheCoordinator extends _$CacheCoordinator {
  @override
  void build() {}

  void ticketCreated() =>
      _invalidate(() => ref.invalidate(liveTicketsTodayProvider), 'New ticket created');
  void ticketModified(String id) =>
      _invalidate(() => ref.invalidate(liveTicketsTodayProvider), 'Ticket $id modified');
  void appointmentCreated() {
    _invalidate(() => ref.invalidate(todaysAppointmentsProvider), 'New appointment created (today)');
    _invalidate(() => ref.invalidate(selectedDateAppointmentsProvider), 'New appointment created (selected date)');
  }
  void appointmentModified(String id) {
    _invalidate(() => ref.invalidate(todaysAppointmentsProvider), 'Appointment $id modified (today)');
    _invalidate(() => ref.invalidate(selectedDateAppointmentsProvider), 'Appointment $id modified (selected date)');
  }
  void appointmentCheckIn(String id) {
    _invalidate(
      () => ref.invalidate(liveTicketsTodayProvider),
      'Ticket created from check-in',
    );
    _invalidate(() => ref.invalidate(todaysAppointmentsProvider), 'Appointment $id checked in (today)');
    _invalidate(() => ref.invalidate(selectedDateAppointmentsProvider), 'Appointment $id checked in (selected date)');
  }

  void paymentProcessed(String id) => _invalidate(
    () => ref.invalidate(liveTicketsTodayProvider),
    'Payment processed for ticket $id',
  );
  void customerCreated() => _invalidate(
    () => ref.invalidate(customersMasterProvider),
    'New customer created',
  );
  void customerModified(String id) => _invalidate(
    () => ref.invalidate(customersMasterProvider),
    'Customer $id modified',
  );
  void employeeCreated() => _invalidate(
    () => ref.invalidate(employeesMasterProvider),
    'New employee created',
  );
  void employeeModified(String id) => _invalidate(
    () => ref.invalidate(employeesMasterProvider),
    'Employee $id modified',
  );
  void serviceCategoryCreated() => _invalidate(
    () => ref.invalidate(serviceCategoriesMasterProvider),
    'New service category created',
  );
  void serviceCategoryModified(String id) => _invalidate(
    () => ref.invalidate(serviceCategoriesMasterProvider),
    'Service category $id modified',
  );
  void serviceModified(String id) => _invalidate(
    () => ref.invalidate(serviceCategoriesMasterProvider),
    'Service $id modified',
  );

  void refreshAll() {
    _invalidate(() => ref.invalidate(liveTicketsTodayProvider), 'Tickets refreshed');
    _invalidate(() => ref.invalidate(todaysAppointmentsProvider), 'Appointments refreshed (today)');
    _invalidate(() => ref.invalidate(selectedDateAppointmentsProvider), 'Appointments refreshed (selected date)');
    _invalidate(() => ref.invalidate(customersMasterProvider), 'Customers refreshed');
    _invalidate(
      () => ref.invalidate(employeesMasterProvider),
      'Employees refreshed',
    );
    _invalidate(
      () => ref.invalidate(serviceCategoriesMasterProvider),
      'Service categories refreshed',
    );
  }

  void _invalidate(void Function() action, String log) {
    try {
      action();
      ErrorLogger.logInfo('Cache invalidated: $log');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to invalidate cache: $log', e, stack);
    }
  }
}
