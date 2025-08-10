// lib/core/database/tables/appointment_services.dart
// Normalized join table linking appointments to services with per-line pricing and optional technician assignment.

import 'package:drift/drift.dart';
import 'appointments.dart';
import '../../../services/data/tables/services.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('AppointmentService')
class AppointmentServices extends Table {
  TextColumn get id => text()(); // UUID/unique id for the service line

  // Foreign keys
  TextColumn get appointmentId => text().named('appointment_id')
      .references(Appointments, #id, onDelete: KeyAction.cascade)();

  IntColumn get serviceId => integer().named('service_id')
      .references(Services, #id, onDelete: KeyAction.cascade)();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  // Pricing in integer cents
  IntColumn get unitPriceCents => integer().named('unit_price_cents')();
  IntColumn get totalPriceCents => integer().named('total_price_cents')();

  // Line status
  TextColumn get status => text().withDefault(const Constant('scheduled'))();

  // Optional: assigned technician
  IntColumn get assignedTechnicianId => integer().named('assigned_technician_id').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (quantity > 0)',
    'CHECK (unit_price_cents >= 0)',
    'CHECK (total_price_cents >= 0)',
    "CHECK (status IN ('scheduled','confirmed','in-progress','completed','cancelled'))",
  ];
}

