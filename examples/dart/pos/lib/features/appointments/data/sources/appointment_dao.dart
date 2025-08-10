// lib/features/appointments/data/sources/appointment_dao.dart
// Data Access Object for appointment operations with scheduling logic, conflict detection, and comprehensive appointment management. Provides business logic for calendar operations with proper relationships.
// Usage: ACTIVE - Primary data access layer for appointment scheduling system with conflict prevention

import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../tables/appointments.dart';
import '../../../customers/data/tables/customers.dart';
import '../../../employees/data/tables/employees.dart';
import '../tables/appointment_services.dart';
import '../../../services/data/tables/services.dart';

part 'appointment_dao.g.dart';

@DriftAccessor(tables: [Appointments, Customers, Employees, AppointmentServices, Services])
class AppointmentDao extends DatabaseAccessor<PosDatabase> with _$AppointmentDaoMixin {
  AppointmentDao(super.db);

  /// Get appointments for a specific date range
  Future<List<AppointmentWithDetails>> getAppointmentsByDateRange(
    DateTime startDate, 
    DateTime endDate
  ) {
    return (select(appointments)
      .join([
        innerJoin(customers, customers.id.equalsExp(appointments.customerId)),
        innerJoin(employees, employees.id.equalsExp(appointments.employeeId)),
      ])
      ..where(appointments.startDateTime.isBiggerOrEqualValue(startDate) &
              appointments.startDateTime.isSmallerThanValue(endDate))
      ..orderBy([OrderingTerm.asc(appointments.startDateTime)]))
    .map((row) => AppointmentWithDetails(
      appointment: row.readTable(appointments),
      customer: row.readTable(customers),
      employee: row.readTable(employees),
    )).get();
  }

  /// Get full appointment details with itemized services (normalized join)
  Future<AppointmentWithServices?> getAppointmentDetails(String appointmentId) async {
    final appt = await (select(appointments)
      ..where((a) => a.id.equals(appointmentId)))
        .getSingleOrNull();
    if (appt == null) return null;

    final query = select(appointmentServices).join([
      innerJoin(services, services.id.equalsExp(appointmentServices.serviceId)),
    ])
      ..where(appointmentServices.appointmentId.equals(appointmentId));

    final svcList = await query.map((row) => row.readTable(services)).get();
    return AppointmentWithServices(appointment: appt, services: svcList);
  }

  /// Watch appointments for a specific date range (real-time updates)
  Stream<List<AppointmentWithDetails>> watchAppointmentsByDateRange(
    DateTime startDate, 
    DateTime endDate
  ) {
    return (select(appointments)
      .join([
        innerJoin(customers, customers.id.equalsExp(appointments.customerId)),
        innerJoin(employees, employees.id.equalsExp(appointments.employeeId)),
      ])
      ..where(appointments.startDateTime.isBiggerOrEqualValue(startDate) &
              appointments.startDateTime.isSmallerThanValue(endDate))
      ..orderBy([OrderingTerm.asc(appointments.startDateTime)]))
    .map((row) => AppointmentWithDetails(
      appointment: row.readTable(appointments),
      customer: row.readTable(customers),
      employee: row.readTable(employees),
    )).watch();
  }

  /// Watch today's appointments (real-time updates)
  Stream<List<AppointmentWithDetails>> watchTodaysAppointments() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return watchAppointmentsByDateRange(startOfDay, endOfDay);
  }

  /// Get appointments for a specific employee and date
  Future<List<AppointmentWithDetails>> getEmployeeAppointments(
    int employeeId, 
    DateTime date
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(appointments)
      .join([
        innerJoin(customers, customers.id.equalsExp(appointments.customerId)),
        innerJoin(employees, employees.id.equalsExp(appointments.employeeId)),
      ])
      ..where(appointments.employeeId.equals(employeeId) &
              appointments.startDateTime.isBiggerOrEqualValue(startOfDay) &
              appointments.startDateTime.isSmallerThanValue(endOfDay))
      ..orderBy([OrderingTerm.asc(appointments.startDateTime)]))
    .map((row) => AppointmentWithDetails(
      appointment: row.readTable(appointments),
      customer: row.readTable(customers),
      employee: row.readTable(employees),
    )).get();
  }

  /// Check for appointment conflicts
  Future<bool> hasConflict({
    required int employeeId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? excludeAppointmentId,
  }) async {
    var query = select(appointments)
      ..where((a) => 
        a.employeeId.equals(employeeId) &
        a.status.isNotIn(['cancelled', 'no-show']) &
        (
          // New appointment starts during existing appointment
          (a.startDateTime.isSmallerThanValue(startDateTime) & 
           a.endDateTime.isBiggerThanValue(startDateTime)) |
          // New appointment ends during existing appointment
          (a.startDateTime.isSmallerThanValue(endDateTime) & 
           a.endDateTime.isBiggerThanValue(endDateTime)) |
          // New appointment completely contains existing appointment
          (a.startDateTime.isBiggerOrEqualValue(startDateTime) & 
           a.endDateTime.isSmallerOrEqualValue(endDateTime)) |
          // Existing appointment completely contains new appointment
          (a.startDateTime.isSmallerOrEqualValue(startDateTime) & 
           a.endDateTime.isBiggerOrEqualValue(endDateTime))
        )
      );

    // Exclude current appointment if editing
    if (excludeAppointmentId != null) {
      query = query..where((a) => a.id.isNotValue(excludeAppointmentId));
    }

    final conflicts = await query.get();
    return conflicts.isNotEmpty;
  }

  /// Create new appointment with conflict checking
  Future<String> createAppointment({
    required String customerId,
    required int employeeId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required List<Map<String, dynamic>> services,
    String? notes,
    bool isGroupBooking = false,
    int? groupSize,
    bool checkConflicts = true,
  }) async {
    if (checkConflicts) {
      final hasConflictResult = await hasConflict(
        employeeId: employeeId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

      if (hasConflictResult) {
        throw Exception('Appointment conflicts with existing booking');
      }
    }

    if (startDateTime.isAfter(endDateTime) || startDateTime.isAtSameMomentAs(endDateTime)) {
      throw ArgumentError('Start time must be before end time');
    }

    final appointmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    await into(appointments).insert(AppointmentsCompanion.insert(
      id: appointmentId,
      customerId: customerId,
      employeeId: employeeId,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      services: services,
      notes: Value(notes),
      isGroupBooking: Value(isGroupBooking),
      groupSize: Value(groupSize),
      createdAt: now,
      updatedAt: now,
    ));

    return appointmentId;
  }

  /// Update appointment status
  Future<void> updateStatus(String appointmentId, String status) {
    return (update(appointments)..where((a) => a.id.equals(appointmentId)))
        .write(AppointmentsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Confirm appointment
  Future<void> confirmAppointment(String appointmentId, String confirmationType) {
    final now = DateTime.now();
    
    return (update(appointments)..where((a) => a.id.equals(appointmentId)))
        .write(AppointmentsCompanion(
          status: const Value('confirmed'),
          confirmedAt: Value(now),
          confirmationType: Value(confirmationType),
          updatedAt: Value(now),
        ));
  }

  /// Reschedule appointment
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newStartDateTime,
    required DateTime newEndDateTime,
    int? newEmployeeId,
    bool checkConflicts = true,
  }) async {
    return await transaction(() async {
      final appointment = await (select(appointments)
        ..where((a) => a.id.equals(appointmentId))
      ).getSingle();

      final employeeId = newEmployeeId ?? appointment.employeeId;

      if (checkConflicts) {
        final hasConflictResult = await hasConflict(
          employeeId: employeeId,
          startDateTime: newStartDateTime,
          endDateTime: newEndDateTime,
          excludeAppointmentId: appointmentId,
        );

        if (hasConflictResult) {
          throw Exception('New appointment time conflicts with existing booking');
        }
      }

      await (update(appointments)..where((a) => a.id.equals(appointmentId)))
          .write(AppointmentsCompanion(
            employeeId: Value(employeeId),
            startDateTime: Value(newStartDateTime),
            endDateTime: Value(newEndDateTime),
            status: const Value('scheduled'), // Reset to scheduled after reschedule
            confirmedAt: const Value(null), // Clear confirmation
            confirmationType: const Value(null),
            updatedAt: Value(DateTime.now()),
          ));
    });
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId, String reason) {
    return (update(appointments)..where((a) => a.id.equals(appointmentId)))
        .write(AppointmentsCompanion(
          status: const Value('cancelled'),
          notes: Value(reason),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Get upcoming appointments for reminders
  Future<List<AppointmentWithDetails>> getUpcomingAppointments(
    DateTime fromDateTime, 
    int hoursAhead
  ) {
    final toDateTime = fromDateTime.add(Duration(hours: hoursAhead));
    
    return (select(appointments)
      .join([
        innerJoin(customers, customers.id.equalsExp(appointments.customerId)),
        innerJoin(employees, employees.id.equalsExp(appointments.employeeId)),
      ])
      ..where(appointments.startDateTime.isBiggerOrEqualValue(fromDateTime) &
              appointments.startDateTime.isSmallerOrEqualValue(toDateTime) &
              appointments.status.equals('scheduled'))
      ..orderBy([OrderingTerm.asc(appointments.startDateTime)]))
    .map((row) => AppointmentWithDetails(
      appointment: row.readTable(appointments),
      customer: row.readTable(customers),
      employee: row.readTable(employees),
    )).get();
  }

  /// Get appointment statistics for date range
  Future<AppointmentStatistics> getAppointmentStatistics(
    DateTime startDate, 
    DateTime endDate
  ) async {
    final appointments = await (select(this.appointments)
      ..where((a) => a.startDateTime.isBiggerOrEqualValue(startDate) &
                    a.startDateTime.isSmallerOrEqualValue(endDate)))
    .get();

    final totalAppointments = appointments.length;
    final confirmedAppointments = appointments.where((a) => a.status == 'confirmed').length;
    final completedAppointments = appointments.where((a) => a.status == 'completed').length;
    final cancelledAppointments = appointments.where((a) => a.status == 'cancelled').length;
    final noShowAppointments = appointments.where((a) => a.status == 'no-show').length;

    return AppointmentStatistics(
      totalAppointments: totalAppointments,
      confirmedAppointments: confirmedAppointments,
      completedAppointments: completedAppointments,
      cancelledAppointments: cancelledAppointments,
      noShowAppointments: noShowAppointments,
      confirmationRate: totalAppointments > 0 ? confirmedAppointments / totalAppointments : 0.0,
      completionRate: totalAppointments > 0 ? completedAppointments / totalAppointments : 0.0,
    );
  }

  /// Search appointments by customer name or phone
  Future<List<AppointmentWithDetails>> searchAppointments(String query) {
    if (query.isEmpty) return Future.value([]);
    
    final searchPattern = '%${query.toLowerCase()}%';
    
    return (select(appointments)
      .join([
        innerJoin(customers, customers.id.equalsExp(appointments.customerId)),
        innerJoin(employees, employees.id.equalsExp(appointments.employeeId)),
      ])
      ..where(customers.firstName.lower().like(searchPattern) |
              customers.lastName.lower().like(searchPattern) |
              customers.phone.like(searchPattern))
      ..orderBy([OrderingTerm.desc(appointments.startDateTime)]))
    .map((row) => AppointmentWithDetails(
      appointment: row.readTable(appointments),
      customer: row.readTable(customers),
      employee: row.readTable(employees),
    )).get();
  }
}

// Helper classes
class AppointmentWithDetails {
  final Appointment appointment;
  final Customer customer;
  final Employee employee;

  AppointmentWithDetails({
    required this.appointment,
    required this.customer,
    required this.employee,
  });
}

class AppointmentStatistics {
  final int totalAppointments;
  final int confirmedAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final int noShowAppointments;
  final double confirmationRate;
  final double completionRate;

  AppointmentStatistics({
    required this.totalAppointments,
    required this.confirmedAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.noShowAppointments,
    required this.confirmationRate,
    required this.completionRate,
  });
}

/// Helper class returning appointment with its normalized services
class AppointmentWithServices {
  final Appointment appointment;
  final List<Service> services;

  AppointmentWithServices({
    required this.appointment,
    required this.services,
  });
}
