// lib/core/services/auth/employee_context.dart
// Simple global context for the current signed-in employee id.
// Repositories can read this to auto-fill processedBy/createdBy fields.

class EmployeeContext {
  static int? _currentEmployeeId;

  static int? get currentEmployeeId => _currentEmployeeId;

  static void setCurrentEmployeeId(int? id) {
    _currentEmployeeId = id;
  }
}

