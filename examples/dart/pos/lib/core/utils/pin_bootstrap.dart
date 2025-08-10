// lib/core/utils/pin_bootstrap.dart
// Bootstrap utility to set default PIN "1234" for all employees who don't have PINs configured. Runs during app startup to ensure all employees can authenticate for privileged operations.
// Usage: ACTIVE - Called during application initialization to ensure all employees have authentication configured
import '../database/database.dart';
import '../auth/pin_auth_service.dart';
import '../../utils/error_logger.dart';

/// Bootstrap utility to set default PINs for all employees
class PinBootstrap {
  static final PinAuthService _pinService = PinAuthService.instance;
  static final PosDatabase _database = PosDatabase.instance;

  /// Set default PIN "1234" for all employees who don't have a PIN yet
  static Future<void> setDefaultPinsForAllEmployees() async {
    try {
      ErrorLogger.logInfo('Starting PIN bootstrap - setting default PIN 1234 for all employees');
      
      // Get all active employees
      final employees = await (_database.select(_database.employees)
            ..where((e) => e.isActive.equals(true)))
          .get();
      
      int pinsSet = 0;
      int pinsSkipped = 0;
      
      for (final employee in employees) {
        // Check if employee already has a PIN
        final hasPin = await _pinService.hasPin(employee.id);
        
        if (!hasPin) {
          // Set default PIN "1234"
          final success = await _pinService.setupPin(employee.id, '1234');
          if (success) {
            pinsSet++;
            ErrorLogger.logInfo('Set default PIN for employee ${employee.id} (${employee.firstName} ${employee.lastName})');
          } else {
            ErrorLogger.logError('Failed to set default PIN for employee ${employee.id}', 'PinBootstrap', StackTrace.current);
          }
        } else {
          pinsSkipped++;
          ErrorLogger.logInfo('Employee ${employee.id} already has PIN, skipping');
        }
      }
      
      ErrorLogger.logInfo('PIN bootstrap complete: $pinsSet PINs set, $pinsSkipped employees already had PINs');
      
    } catch (e, stack) {
      ErrorLogger.logError('Error during PIN bootstrap', e, stack);
    }
  }

  /// Check if any employees are missing PINs
  static Future<bool> areAnyPinsMissing() async {
    try {
      final employees = await (_database.select(_database.employees)
            ..where((e) => e.isActive.equals(true)))
          .get();
      
      for (final employee in employees) {
        final hasPin = await _pinService.hasPin(employee.id);
        if (!hasPin) {
          return true;
        }
      }
      
      return false;
    } catch (e, stack) {
      ErrorLogger.logError('Error checking for missing PINs', e, stack);
      return true; // Assume missing PINs on error to be safe
    }
  }

  /// Run bootstrap if needed (called on app startup)
  static Future<void> runBootstrapIfNeeded() async {
    try {
      final needsBootstrap = await areAnyPinsMissing();
      if (needsBootstrap) {
        ErrorLogger.logInfo('Missing PINs detected, running PIN bootstrap');
        await setDefaultPinsForAllEmployees();
      } else {
        ErrorLogger.logInfo('All employees have PINs, bootstrap not needed');
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error during bootstrap check', e, stack);
    }
  }
}
