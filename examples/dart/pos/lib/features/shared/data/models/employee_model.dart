// lib/features/shared/data/models/employee_model.dart
// Freezed employee data model with role management, capabilities, time tracking, and specializations support.
// Usage: ACTIVE - Core employee data model used throughout staff management and assignment systems
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../employees/data/models/employee_capability.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

/// Employee model
@freezed
class Employee with _$Employee {
  const factory Employee({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    String? socialSecurityNumber, // Secure field - will be encrypted/protected
    required String role,
    @Default('active') String status,
    required String locationId,
    required String username,
    String? pinHash,
    String? displayName,
    @Default(0.0) double commissionRate,
    @Default(false) bool isClockedIn,
    DateTime? lastClockIn,
    DateTime? lastClockOut,
    @Default(0) int hoursThisWeek,
    @Default(0) int hoursThisMonth,
    String? departmentId,
    String? departmentName,
    @Default(true) bool canAcceptWalkins,
    @Default(true) bool canAcceptAppointments,
    String? profileImageUrl,
    Map<String, dynamic>? permissions,
    @Default([]) List<EmployeeCapability> capabilities,
    @Default([]) List<String> specializations, // Service categories this employee specializes in
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
}

/// Employee role enum
enum EmployeeRole {
  admin,
  manager,
  technician,
  receptionist,
  staff,
}

/// Employee status enum
enum EmployeeStatus {
  active,
  inactive,
  onBreak,
  vacation,
  terminated,
}

extension EmployeeRoleX on EmployeeRole {
  String get value {
    switch (this) {
      case EmployeeRole.admin:
        return 'admin';
      case EmployeeRole.manager:
        return 'manager';
      case EmployeeRole.technician:
        return 'technician';
      case EmployeeRole.receptionist:
        return 'receptionist';
      case EmployeeRole.staff:
        return 'staff';
    }
  }

  static EmployeeRole fromString(String value) {
    switch (value) {
      case 'admin':
        return EmployeeRole.admin;
      case 'manager':
        return EmployeeRole.manager;
      case 'technician':
        return EmployeeRole.technician;
      case 'receptionist':
        return EmployeeRole.receptionist;
      case 'staff':
        return EmployeeRole.staff;
      default:
        return EmployeeRole.staff;
    }
  }
}

/// Extension to provide Technician-like properties for compatibility
extension EmployeeTechnicianCompat on Employee {
  /// Check if employee is available (clocked in and active)
  bool get isAvailable => isClockedIn && status == 'active';
  
  /// Get full name (firstName lastName)
  String get fullName => '$firstName $lastName'.trim();
  
  /// Get display name with fallback to full name
  String get displayNameOrFullName => displayName ?? fullName;
  
  /// Get name in "FirstName L." format for compact display
  String get compactName {
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return lastInitial.isNotEmpty ? '$firstName $lastInitial.' : firstName;
  }
  
  /// Get initials (first letter of first and last name)
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }
}
