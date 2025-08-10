// lib/core/database/daos/employee_dao.dart
// Data Access Object for employee operations with business logic methods, PIN authentication, and time tracking integration. Provides secure employee management with proper constraint handling.
// Usage: ACTIVE - Primary data access layer for employee operations with security features

import 'package:drift/drift.dart';
import '../database.dart';
import '../../../features/employees/data/tables/employees.dart';
import '../../../features/employees/data/tables/employee_service_categories.dart';
import '../../../features/services/data/tables/service_categories.dart';
import '../../../features/employees/data/tables/time_entries.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [Employees, EmployeeServiceCategories, ServiceCategories, TimeEntries])
class EmployeeDao extends DatabaseAccessor<PosDatabase> with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  /// Get all active employees
  Future<List<Employee>> getActiveEmployees() {
    return (select(employees)
      ..where((e) => e.isActive.equals(true))
      ..orderBy([(e) => OrderingTerm.asc(e.lastName), (e) => OrderingTerm.asc(e.firstName)]))
    .get();
  }

  /// Get employee by ID with service categories
  Future<EmployeeWithCategories?> getEmployeeWithCategories(int employeeId) async {
    final employee = await (select(employees)..where((e) => e.id.equals(employeeId))).getSingleOrNull();
    if (employee == null) return null;

    final categories = await (select(employeeServiceCategories)
      .join([
        innerJoin(serviceCategories, serviceCategories.id.equalsExp(employeeServiceCategories.categoryId))
      ])
      ..where(employeeServiceCategories.employeeId.equals(employeeId) & 
              employeeServiceCategories.isActive.equals(true)))
    .map((row) => row.readTable(serviceCategories)).get();

    return EmployeeWithCategories(employee: employee, categories: categories);
  }

  /// Get employees by service category
  Future<List<Employee>> getEmployeesByCategory(int categoryId) {
    return (select(employees)
      .join([
        innerJoin(employeeServiceCategories, 
          employeeServiceCategories.employeeId.equalsExp(employees.id))
      ])
      ..where(employeeServiceCategories.categoryId.equals(categoryId) &
              employeeServiceCategories.isActive.equals(true) &
              employees.isActive.equals(true))
      ..orderBy([OrderingTerm.asc(employees.lastName)]))
    .map((row) => row.readTable(employees)).get();
  }

  /// Clock in employee
  Future<String> clockIn(int employeeId) async {
    return await transaction(() async {
      final now = DateTime.now();
      
      // Check if already clocked in
      final existing = await (select(timeEntries)
        ..where((te) => te.employeeId.equals(employeeId) & 
                       te.clockOut.isNull() & 
                       te.status.equals('active')))
      .getSingleOrNull();

      if (existing != null) {
        throw Exception('Employee is already clocked in');
      }

      // Create time entry
      final timeEntryId = now.millisecondsSinceEpoch.toString();
      await into(timeEntries).insert(TimeEntriesCompanion.insert(
        id: timeEntryId,
        employeeId: employeeId,
        clockIn: now,
        createdAt: now,
        updatedAt: now,
      ));

      // Update employee clock status
      await (update(employees)..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(
            isClockedIn: const Value(true),
            clockedInAt: Value(now),
            clockedOutAt: const Value(null),
          ));

      return timeEntryId;
    });
  }

  /// Clock out employee
  Future<void> clockOut(int employeeId, {int breakMinutes = 0}) async {
    await transaction(() async {
      final now = DateTime.now();
      
      // Find active time entry
      final timeEntry = await (select(timeEntries)
        ..where((te) => te.employeeId.equals(employeeId) & 
                       te.clockOut.isNull() & 
                       te.status.equals('active')))
      .getSingleOrNull();

      if (timeEntry == null) {
        throw Exception('Employee is not clocked in');
      }

      // Calculate total hours
      final clockInTime = timeEntry.clockIn;
      final totalMinutes = now.difference(clockInTime).inMinutes - breakMinutes;
      final totalHours = totalMinutes / 60.0;

      // Update time entry
      await (update(timeEntries)..where((te) => te.id.equals(timeEntry.id)))
          .write(TimeEntriesCompanion(
            clockOut: Value(now),
            breakMinutes: Value(breakMinutes),
            totalHours: Value(totalHours),
            status: const Value('completed'),
            updatedAt: Value(now),
          ));

      // Update employee clock status
      await (update(employees)..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(
            isClockedIn: const Value(false),
            clockedOutAt: Value(now),
          ));
    });
  }

  /// Set employee PIN with secure hashing
  Future<void> setPin(int employeeId, String pin) async {
    if (pin.length < 4 || pin.length > 6) {
      throw ArgumentError('PIN must be 4-6 digits');
    }

    // Generate salt
    final salt = _generateSalt();
    final pinHash = _hashPin(pin, salt);
    final now = DateTime.now();

    await (update(employees)..where((e) => e.id.equals(employeeId)))
        .write(EmployeesCompanion(
          pinHash: Value(pinHash),
          pinSalt: Value(salt),
          pinCreatedAt: Value(now),
        ));
  }

  /// Verify employee PIN
  Future<bool> verifyPin(int employeeId, String pin) async {
    final employee = await (select(employees)..where((e) => e.id.equals(employeeId))).getSingleOrNull();
    
    if (employee?.pinHash == null || employee?.pinSalt == null) {
      return false;
    }

    final expectedHash = _hashPin(pin, employee!.pinSalt!);
    final isValid = expectedHash == employee.pinHash;

    if (isValid) {
      // Update last used timestamp
      await (update(employees)..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(pinLastUsedAt: Value(DateTime.now())));
    }

    return isValid;
  }

  /// Add service category specialization
  Future<void> addServiceCategory(int employeeId, int categoryId) async {
    final now = DateTime.now();
    
    await into(employeeServiceCategories).insert(
      EmployeeServiceCategoriesCompanion.insert(
        employeeId: employeeId,
        categoryId: categoryId,
        certifiedAt: Value(now),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Remove service category specialization
  Future<void> removeServiceCategory(int employeeId, int categoryId) async {
    await (delete(employeeServiceCategories)
      ..where((esc) => esc.employeeId.equals(employeeId) & 
                      esc.categoryId.equals(categoryId))
    ).go();
  }

  /// Get employee work hours for date range
  Future<List<TimeEntry>> getWorkHours(int employeeId, DateTime startDate, DateTime endDate) {
    return (select(timeEntries)
      ..where((te) => te.employeeId.equals(employeeId) &
                     te.clockIn.isBiggerOrEqualValue(startDate) &
                     te.clockIn.isSmallerOrEqualValue(endDate))
      ..orderBy([(te) => OrderingTerm.desc(te.clockIn)]))
    .get();
  }

  /// Generate secure salt for PIN hashing
  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  /// Hash PIN with salt using SHA-256
  String _hashPin(String pin, String salt) {
    final saltBytes = base64.decode(salt);
    final pinBytes = utf8.encode(pin);
    final combined = [...pinBytes, ...saltBytes];
    
    final digest = sha256.convert(combined);
    return base64.encode(digest.bytes);
  }
}

// Helper classes
class EmployeeWithCategories {
  final Employee employee;
  final List<ServiceCategory> categories;

  EmployeeWithCategories({
    required this.employee,
    required this.categories,
  });
}
