// lib/features/shared/data/repositories/drift_employee_repository.dart
// Drift-based employee repository providing CRUD operations and business logic for employee management.
// Manages employee records, capabilities, clock in/out operations, and role-based queries with type-safe ORM.
// Usage: ACTIVE - Primary repository for all employee data operations

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../models/employee_model.dart';
import '../../../../utils/error_logger.dart';
import '../../../employees/data/models/employee_capability.dart';
import 'base_drift_repository.dart';

/// Drift-based Employee Repository using EmployeeDao
/// This replaces direct database queries with proper DAO abstraction
class DriftEmployeeRepository extends BaseDriftRepository {
  static DriftEmployeeRepository? _instance;
  static DriftEmployeeRepository get instance => _instance ??= DriftEmployeeRepository._();
  
  DriftEmployeeRepository._();
  
  db.EmployeeDao? _employeeDao;
  bool _initialized = false;
  
  /// Initialize the repository with the EmployeeDao
  Future<void> initialize() async {
    if (_initialized && _employeeDao != null) return;
    
    try {
      final db = await database;
      _employeeDao = db.employeeDao;
      _initialized = true;
      ErrorLogger.logInfo('DriftEmployeeRepository initialized successfully with DAO');
    } catch (e, stack) {
      ErrorLogger.logError('DriftEmployeeRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Get all active employees
  Future<List<Employee>> getEmployees() async {
    try {
      await initialize();
      if (_employeeDao == null) {
        throw Exception('EmployeeDao not initialized');
      }
      
      final employees = await _employeeDao!.getActiveEmployees();
      
      // Convert to model format with capabilities
      final result = <Employee>[];
      for (final emp in employees) {
        final empWithCategories = await _employeeDao!.getEmployeeWithCategories(emp.id);
        result.add(_convertToModel(emp, empWithCategories?.categories ?? []));
      }
      
      return result;
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  /// Get employees by role (technicians, managers, etc.)
  Future<List<Employee>> getEmployeesByRole(String role) async {
    try {
      // Ensure database is initialized
      await initialize();
      
      // Debug: Check all employees first
      final allEmployees = await _database!.select(_database!.employees).get();
      debugPrint('🏢 Total employees in database: ${allEmployees.length}');
      debugPrint('🏢 Roles found: ${allEmployees.map((e) => e.role).toSet().toList()}');
      debugPrint('🏢 Active employees: ${allEmployees.where((e) => e.isActive == true).length}');
      debugPrint('🏢 Looking for role: $role');
      
      final employees = await (_database!.select(_database!.employees)
            ..where((e) => e.role.equals(role) & e.isActive.equals(true)) // Now a proper boolean
            ..orderBy([
              (e) => OrderingTerm(expression: e.firstName),
              (e) => OrderingTerm(expression: e.lastName),
            ]))
          .get();
          
      debugPrint('🏢 Employees found with role "$role" and active=1: ${employees.length}');

      // If no employees found, return empty list gracefully
      if (employees.isEmpty) {
        return [];
      }

      // Get capabilities for all employees
      final allCapabilities = await _database!.select(_database!.employeeServiceCategories).get();
      
      return employees.map((emp) => _convertToModel(emp, 
          allCapabilities.where((cap) => cap.employeeId == emp.id).toList(),),).toList();
    } catch (e, stack) {
      // Handle database errors gracefully (table not exists, etc.)
      if (e.toString().contains('no such table') || e.toString().contains('employees')) {
        ErrorLogger.logInfo('Employee table not populated yet - returning empty list');
        return [];
      }
      ErrorLogger.logError('Error fetching employees by role', e, stack);
      // Return empty list instead of throwing to prevent app crash
      return [];
    }
  }

  /// Get all technicians (most common use case)
  Future<List<Employee>> getTechnicians() async {
    return getEmployeesByRole('technician');
  }

  /// Get employee by ID
  Future<Employee?> getEmployeeById(int id) async {
    try {
      await initialize();
      final employee = await (_database!.select(_database!.employees)
            ..where((e) => e.id.equals(id)))
          .getSingleOrNull();

      if (employee == null) return null;
      
      // Get capabilities for this employee
      final capabilities = await (_database!.select(_database!.employeeServiceCategories)
        ..where((c) => c.employeeId.equals(id)))
        .get();
      
      return _convertToModel(employee, capabilities);
    } catch (e) {
      throw Exception('Failed to fetch employee by ID: $e');
    }
  }

  /// Insert new employee
  Future<int> insertEmployee(Employee employee) async {
    try {
      await initialize();
      // Use the firstName and lastName from the employee model
      final id = await _database!.into(_database!.employees).insert(
        db.EmployeesCompanion(
          // Don't set id for new employees - let it auto-increment
          firstName: Value(employee.firstName),
          lastName: Value(employee.lastName),
          email: Value(employee.email),
          phone: Value(employee.phone),
          role: Value(employee.role),
          commissionRate: Value(employee.commissionRate),
          hourlyRate: const Value(0.0), // Not in our model
          hireDate: Value(DateTime.now().toIso8601String().split('T')[0]), // DATE format
          isActive: Value(employee.status == 'active'), // Now a proper boolean
        ),
      );
      return id;
    } catch (e) {
      throw Exception('Failed to insert employee: $e');
    }
  }

  /// Update existing employee
  Future<void> updateEmployee(Employee employee) async {
    try {
      await initialize();
      // Use the firstName and lastName from the employee model
      await (_database!.update(_database!.employees)
            ..where((e) => e.id.equals(employee.id)))
          .write(db.EmployeesCompanion(
            firstName: Value(employee.firstName),
            lastName: Value(employee.lastName),
            email: Value(employee.email),
            phone: Value(employee.phone),
            role: Value(employee.role),
            commissionRate: Value(employee.commissionRate),
            isActive: Value(employee.status == 'active'), // Now a proper boolean
            updatedAt: Value(DateTime.now().toIso8601String()), // TEXT datetime format
          ),);
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  /// Soft delete employee (set isActive to false)
  Future<void> deleteEmployee(int id) async {
    try {
      await initialize();
      await (_database!.update(_database!.employees)
            ..where((e) => e.id.equals(id)))
          .write(const db.EmployeesCompanion(
            isActive: const Value(false), // Set as inactive
          ),);
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }

  /// Search employees by name
  Future<List<Employee>> searchEmployees(String searchTerm) async {
    try {
      await initialize();
      final term = '%$searchTerm%';
      final employees = await (_database!.select(_database!.employees)
            ..where((e) => 
                e.isActive.equals(true) & 
                (e.firstName.like(term) | e.lastName.like(term)),)
            ..orderBy([
              (e) => OrderingTerm(expression: e.firstName),
              (e) => OrderingTerm(expression: e.lastName),
            ]))
          .get();

      // Get capabilities for all employees
      final allCapabilities = await _database!.select(_database!.employeeServiceCategories).get();
      
      return employees.map((emp) => _convertToModel(emp, 
          allCapabilities.where((cap) => cap.employeeId == emp.id).toList(),),).toList();
    } catch (e) {
      throw Exception('Failed to search employees: $e');
    }
  }

  /// Get active employee count
  Future<int> getActiveEmployeeCount() async {
    try {
      await initialize();
      final query = _database!.selectOnly(_database!.employees)
        ..addColumns([_database!.employees.id.count()])
        ..where(_database!.employees.isActive.equals(true));
      
      final result = await query.getSingle();
      return result.read(_database!.employees.id.count()) ?? 0;
    } catch (e) {
      throw Exception('Failed to get employee count: $e');
    }
  }

  /// Stream of active employees (for reactive UI)
  Stream<List<Employee>> watchActiveEmployees() {
    initialize(); // Initialize synchronously for streams
    
    // Stream both employees and capabilities
    final employeesStream = (_database!.select(_database!.employees)
          ..where((e) => e.isActive.equals(true))
          ..orderBy([
            (e) => OrderingTerm(expression: e.firstName),
            (e) => OrderingTerm(expression: e.lastName),
          ]))
        .watch();
    
    final capabilitiesStream = _database!.select(_database!.employeeServiceCategories).watch();
    
    // Combine both streams
    return employeesStream.asyncMap((employees) async {
      final capabilities = await capabilitiesStream.first;
      return employees.map((emp) => _convertToModel(emp,
          capabilities.where((cap) => cap.employeeId == emp.id).toList(),),).toList();
    });
  }

  /// Stream of technicians (for reactive UI)
  Stream<List<Employee>> watchTechnicians() {
    initialize(); // Initialize synchronously for streams
    
    // Stream both employees and capabilities
    final employeesStream = (_database!.select(_database!.employees)
          ..where((e) => e.role.equals('technician') & e.isActive.equals(true))
          ..orderBy([
            (e) => OrderingTerm(expression: e.firstName),
            (e) => OrderingTerm(expression: e.lastName),
          ]))
        .watch();
    
    final capabilitiesStream = _database!.select(_database!.employeeServiceCategories).watch();
    
    // Combine both streams
    return employeesStream.asyncMap((employees) async {
      final capabilities = await capabilitiesStream.first;
      return employees.map((emp) => _convertToModel(emp,
          capabilities.where((cap) => cap.employeeId == emp.id).toList(),),).toList();
    });
  }

  /// Update employee capabilities
  Future<void> updateEmployeeCapabilities(int employeeId, List<String> capabilities) async {
    try {
      await initialize();
      await _database!.transaction(() async {
        // Delete existing capabilities
        await (_database!.delete(_database!.employeeServiceCategories)
          ..where((c) => c.employeeId.equals(employeeId)))
          .go();
        
        // Insert new capabilities (skip if empty)
        if (capabilities.isNotEmpty) {
          for (int i = 0; i < capabilities.length; i++) {
            final capability = capabilities[i];
            // Skip empty or null capability names
            if (capability.trim().isEmpty) continue;
            
            // Generate unique ID with index to avoid duplicates
            final id = '${DateTime.now().millisecondsSinceEpoch}_${employeeId}_$i';
            await _database!.into(_database!.employeeServiceCategories).insert(
              db.EmployeeServiceCategoriesCompanion(
                id: Value(id),
                employeeId: Value(employeeId),
                categoryName: Value(capability),
              ),
            );
          }
        }
      });
      
      ErrorLogger.logInfo('Updated capabilities for employee $employeeId: $capabilities');
    } catch (e, stack) {
      ErrorLogger.logError('Error updating employee capabilities', e, stack);
      rethrow;
    }
  }

  /// Get employees by capability
  Future<List<Employee>> getEmployeesByCapability(String capability) async {
    try {
      await initialize();
      // Get employee IDs with this capability
      final capabilityEntries = await (_database!.select(_database!.employeeServiceCategories)
        ..where((c) => c.categoryName.equals(capability)))
        .get();
      
      final employeeIds = capabilityEntries
          .map((c) => c.employeeId)
          .cast<int>()
          .toSet();
      
      if (employeeIds.isEmpty) return [];
      
      // Get employees with those IDs
      final employees = await (_database!.select(_database!.employees)
        ..where((e) => e.id.isIn(employeeIds.toList()) & e.isActive.equals(true)))
        .get();
      
      // Get all capabilities for these employees
      final allCapabilities = await (_database!.select(_database!.employeeServiceCategories)
        ..where((c) => c.employeeId.isIn(employeeIds.toList())))
        .get();
      
      return employees.map((emp) => _convertToModel(emp,
          allCapabilities.where((cap) => cap.employeeId == emp.id).toList(),),).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error getting employees by capability: $capability', e, stack);
      return [];
    }
  }

  /// Convert Drift Employee to Model Employee
  Employee _convertToModel(db.Employee driftEmployee, [List<db.EmployeeServiceCategory>? capabilities]) {
    // Build display name from first and last name with null safety
    final firstName = driftEmployee.firstName;
    final lastName = driftEmployee.lastName;
    final fullName = '$firstName $lastName'.trim();
    
    DateTime? createdAt;
    if (driftEmployee.createdAt.isNotEmpty) {
      try {
        createdAt = DateTime.parse(driftEmployee.createdAt);
      } catch (e) {
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }
    
    DateTime? updatedAt;
    if (driftEmployee.updatedAt.isNotEmpty) {
      try {
        updatedAt = DateTime.parse(driftEmployee.updatedAt);
      } catch (e) {
        updatedAt = DateTime.now();
      }
    } else {
      updatedAt = DateTime.now();
    }
    
    // Map capability names to EmployeeCapability objects
    final employeeCapabilities = capabilities?.where((cap) => cap.categoryName != null && cap.categoryName!.isNotEmpty).map((cap) {
      final categoryName = cap.categoryName ?? '';
      // Find matching standard capability
      final standardCap = EmployeeCapability.standardCapabilities.firstWhere(
        (sc) => sc.name.toLowerCase() == categoryName.toLowerCase() || 
                sc.id == categoryName.toLowerCase(),
        orElse: () => EmployeeCapability(
          id: categoryName,
          name: categoryName,
          displayName: categoryName,
          color: '#808080',
        ),
      );
      return standardCap;
    }).toList() ?? [];
    
    // Get clock in/out times (now proper DateTime fields)
    final DateTime? lastClockIn = driftEmployee.clockedInAt;
    final DateTime? lastClockOut = driftEmployee.clockedOutAt;
    
    return Employee(
      id: driftEmployee.id,
      firstName: firstName,
      lastName: lastName,
      email: driftEmployee.email ?? '',
      phone: driftEmployee.phone ?? '',
      role: driftEmployee.role,
      status: (driftEmployee.isActive == true) ? 'active' : 'inactive',
      locationId: '',
      username: driftEmployee.email ?? '', // Use email as username
      displayName: fullName.isNotEmpty ? fullName : null,
      commissionRate: driftEmployee.commissionRate ?? 0.0,
      isClockedIn: driftEmployee.isClockedIn ?? false, // Now a proper boolean
      lastClockIn: lastClockIn,
      lastClockOut: lastClockOut,
      capabilities: employeeCapabilities,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Clock in an employee
  Future<void> clockInEmployee(int employeeId) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.employees)
        ..where((e) => e.id.equals(employeeId)))
        .write(db.EmployeesCompanion(
          clockedInAt: Value(DateTime.now()),
          isClockedIn: const Value(true), // Set as clocked in
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),);
        
      ErrorLogger.logInfo('Employee $employeeId clocked in successfully');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to clock in employee $employeeId', e, stack);
      throw Exception('Failed to clock in employee: $e');
    }
  }

  /// Clock out an employee
  Future<void> clockOutEmployee(int employeeId) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.employees)
        ..where((e) => e.id.equals(employeeId)))
        .write(db.EmployeesCompanion(
          clockedOutAt: Value(DateTime.now()),
          isClockedIn: const Value(false), // Set as clocked out
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),);
        
      ErrorLogger.logInfo('Employee $employeeId clocked out successfully');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to clock out employee $employeeId', e, stack);
      throw Exception('Failed to clock out employee: $e');
    }
  }

  /// Close database connection
  Future<void> close() async {
    // Don't close the shared database instance
  }
}