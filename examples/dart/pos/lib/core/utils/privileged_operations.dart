// lib/core/utils/privileged_operations.dart
// Comprehensive privileged operations system with PIN protection for management functions and time tracking. Handles role-based authorization with manager PIN requirements and employee self-authentication.
// Usage: ACTIVE - Core security system used throughout app for void tickets, refunds, price modifications, time tracking, and all management functions
import 'package:flutter/material.dart';
import '../auth/widgets/pin_protected_wrapper.dart';
import '../database/database.dart';
import '../../utils/error_logger.dart';
import '../../features/shared/data/models/employee_model.dart' as model;

/// Defines privileged operations that require PIN verification
enum PrivilegedOperation {
  // Management functions (require manager/admin PIN)
  voidTicket('Void Ticket'),
  refundPayment('Process Refund'),
  deleteCustomer('Delete Customer'),
  modifyPrice('Modify Price'),
  overrideDiscount('Override Discount'),
  viewReports('View Reports'),
  editEmployeeData('Edit Employee Data'),
  modifyInventory('Modify Inventory'),
  accessSettings('Access Settings'),
  cancelAppointment('Cancel Appointment'),
  
  // Time tracking functions (require employee's own PIN)
  clockIn('Clock In'),
  clockOut('Clock Out');

  final String displayName;
  const PrivilegedOperation(this.displayName);
}

/// Configuration for privileged operations
class PrivilegedOperationConfig {
  final bool requiresPin;
  final bool requiresManagerPin;
  final String? customMessage;
  final int? specificEmployeeId; // For manager-only operations

  const PrivilegedOperationConfig({
    this.requiresPin = true,
    this.requiresManagerPin = false,
    this.customMessage,
    this.specificEmployeeId,
  });
}

/// Helper class for handling privileged operations
class PrivilegedOperations {

  /// Default configurations for each operation
  static const Map<PrivilegedOperation, PrivilegedOperationConfig>
      _defaultConfigs = {
    // Management functions - require manager/admin PIN
    PrivilegedOperation.voidTicket: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to void this ticket',
    ),
    PrivilegedOperation.refundPayment: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to process refund',
    ),
    PrivilegedOperation.deleteCustomer: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to delete customer data',
    ),
    PrivilegedOperation.modifyPrice: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to modify price',
    ),
    PrivilegedOperation.overrideDiscount: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to override discount',
    ),
    PrivilegedOperation.viewReports: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to access reports',
    ),
    PrivilegedOperation.editEmployeeData: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to edit employee data',
    ),
    PrivilegedOperation.modifyInventory: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to modify inventory',
    ),
    PrivilegedOperation.accessSettings: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to access settings',
    ),
    PrivilegedOperation.cancelAppointment: PrivilegedOperationConfig(
      requiresManagerPin: true,
      customMessage: 'Manager authorization required to cancel appointment',
    ),
    
    // Time tracking functions - employees use their own PIN
    PrivilegedOperation.clockIn: PrivilegedOperationConfig(
      customMessage: 'Enter your PIN to clock in',
    ),
    PrivilegedOperation.clockOut: PrivilegedOperationConfig(
      customMessage: 'Enter your PIN to clock out',
    ),
  };

  /// Request authorization for a privileged operation
  /// Returns true if authorized, false otherwise
  static Future<bool> requestAuthorization({
    required BuildContext context,
    required PrivilegedOperation operation,
    required int currentEmployeeId,
    PrivilegedOperationConfig? customConfig,
  }) async {
    try {
      final config = customConfig ??
          _defaultConfigs[operation] ??
          const PrivilegedOperationConfig();

      ErrorLogger.logInfo(
          'Requesting authorization for: ${operation.displayName}',);

      if (!config.requiresPin) {
        // No PIN required
        return true;
      }

      // For management functions, check if we need a manager's PIN
      if (config.requiresManagerPin) {
        return await _requestManagerAuthorization(context, operation, currentEmployeeId, config);
      } else {
        // Regular employee PIN required (for time tracking)
        return await PinProtection.verify(
          context: context,
          employeeId: currentEmployeeId,
          authMessage: config.customMessage ?? 'Enter your PIN to ${operation.displayName.toLowerCase()}',
        );
      }
      
    } catch (e, stack) {
      ErrorLogger.logError(
          'Error during privileged operation authorization', e, stack,);
      if (context.mounted) {
        _showErrorDialog(context, 'Authorization failed. Please try again.');
      }
      return false;
    }
  }

  /// Request manager authorization for management functions
  static Future<bool> _requestManagerAuthorization(
    BuildContext context,
    PrivilegedOperation operation,
    int currentEmployeeId,
    PrivilegedOperationConfig config,
  ) async {
    try {
      // First check if current user is already a manager/admin
      final currentEmployee = await _getEmployee(currentEmployeeId);
      if (currentEmployee != null && _isManagerOrAdmin(currentEmployee.role)) {
        // Current user is manager, use their PIN
        return await PinProtection.verify(
          context: context,
          employeeId: currentEmployeeId,
          authMessage: config.customMessage ?? 'Enter your PIN to ${operation.displayName.toLowerCase()}',
        );
      }

      // Current user is not a manager, need to find and authenticate a manager
      return await _requestAnyManagerPin(context, operation, config);
      
    } catch (e, stack) {
      ErrorLogger.logError('Error during manager authorization', e, stack);
      return false;
    }
  }

  /// Request PIN from any available manager
  static Future<bool> _requestAnyManagerPin(
    BuildContext context,
    PrivilegedOperation operation,
    PrivilegedOperationConfig config,
  ) async {
    try {
      // Get all active managers
      final managers = await _getActiveManagers();
      
      if (managers.isEmpty) {
        if (context.mounted) {
          _showErrorDialog(context, 'No managers available to authorize this operation.');
        }
        return false;
      }

      // For now, use the first manager. In future, we could show a list to choose from
      final managerId = managers.first.id;
      
      return await PinProtection.verify(
        context: context,
        employeeId: managerId,
        authMessage: config.customMessage ?? 'Manager PIN required to ${operation.displayName.toLowerCase()}',
      );
      
    } catch (e, stack) {
      ErrorLogger.logError('Error requesting manager PIN', e, stack);
      return false;
    }
  }

  /// Get employee by ID
  static Future<model.Employee?> _getEmployee(int employeeId) async {
    try {
      final database = PosDatabase.instance;
      final employeeData = await (database.select(database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
      
      if (employeeData == null) return null;
      
      // Convert Drift Employee to our Employee model
      return model.Employee(
        id: employeeData.id,
        firstName: employeeData.firstName,
        lastName: employeeData.lastName,
        email: employeeData.email ?? '',
        phone: employeeData.phone ?? '',
        role: employeeData.role,
        locationId: '1', // Default location
        username: employeeData.email ?? 'user${employeeData.id}',
        createdAt: employeeData.createdAt,
        updatedAt: employeeData.updatedAt,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error getting employee $employeeId', e, stack);
      return null;
    }
  }

  /// Get all active managers and admins
  static Future<List<model.Employee>> _getActiveManagers() async {
    try {
      final database = PosDatabase.instance;
      final managersData = await (database.select(database.employees)
            ..where((e) => e.isActive.equals(true))
            ..where((e) => e.role.isIn(['manager', 'admin'])))
          .get();
      
      return managersData.map((employeeData) => model.Employee(
        id: employeeData.id,
        firstName: employeeData.firstName,
        lastName: employeeData.lastName,
        email: employeeData.email ?? '',
        phone: employeeData.phone ?? '',
        role: employeeData.role,
        locationId: '1', // Default location
        username: employeeData.email ?? 'user${employeeData.id}',
        createdAt: employeeData.createdAt,
        updatedAt: employeeData.updatedAt,
      ),).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Error getting active managers', e, stack);
      return [];
    }
  }

  /// Check if role is manager or admin
  static bool _isManagerOrAdmin(String role) {
    return role.toLowerCase() == 'manager' || role.toLowerCase() == 'admin';
  }

  /// Execute a privileged operation with authorization
  /// The operation will only execute if authorization is successful
  static Future<T?> executeWithAuthorization<T>({
    required BuildContext context,
    required PrivilegedOperation operation,
    required int currentEmployeeId,
    required Future<T> Function() action,
    PrivilegedOperationConfig? customConfig,
    Function(T result)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    try {
      // Request authorization
      final authorized = await requestAuthorization(
        context: context,
        operation: operation,
        currentEmployeeId: currentEmployeeId,
        customConfig: customConfig,
      );

      if (!authorized) {
        ErrorLogger.logWarning(
            'Authorization denied for: ${operation.displayName}',);
        return null;
      }

      // Execute the action
      ErrorLogger.logInfo(
          'Executing authorized operation: ${operation.displayName}',);
      final result = await action();

      if (onSuccess != null) {
        onSuccess(result);
      }

      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Error executing privileged operation', e, stack);

      if (onError != null) {
        onError(e);
      } else if (context.mounted) {
        _showErrorDialog(context, 'Operation failed: ${e.toString()}');
      }

      return null;
    }
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Extension method for easy access
extension PrivilegedOperationContext on BuildContext {
  /// Request authorization for a privileged operation
  Future<bool> requestPrivilegedAuthorization(
    PrivilegedOperation operation,
    int currentEmployeeId, {
    PrivilegedOperationConfig? config,
  }) {
    return PrivilegedOperations.requestAuthorization(
      context: this,
      operation: operation,
      currentEmployeeId: currentEmployeeId,
      customConfig: config,
    );
  }

  /// Execute a privileged operation with authorization
  Future<T?> executePrivilegedOperation<T>(
    PrivilegedOperation operation,
    int currentEmployeeId,
    Future<T> Function() action, {
    PrivilegedOperationConfig? config,
    Function(T result)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    return PrivilegedOperations.executeWithAuthorization<T>(
      context: this,
      operation: operation,
      currentEmployeeId: currentEmployeeId,
      action: action,
      customConfig: config,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
