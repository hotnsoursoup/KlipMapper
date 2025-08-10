// lib/core/auth/pin_auth_service.dart
// PIN authentication service providing secure hash-based PIN verification for employees. Handles PIN creation, validation, and secure storage with salt-based hashing for employee authentication.
// Usage: ACTIVE - Used throughout app for employee authentication and manager authorization

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../database/database.dart';
import '../utils/logger.dart';
import 'package:drift/drift.dart';

/// Service for PIN authentication across the application
class PinAuthService {
  final PosDatabase _database = PosDatabase.instance;
  
  // Singleton pattern
  static final PinAuthService _instance = PinAuthService._internal();
  static PinAuthService get instance => _instance;
  PinAuthService._internal();

  /// Generate a random salt for PIN hashing
  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  /// Hash a PIN with salt using SHA-256
  String _hashPin(String pin, String salt) {
    final combined = pin + salt;
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Set up PIN for an employee
  Future<bool> setupPin(int employeeId, String pin) async {
    try {
      Logger.info('=== SETUP PIN DEBUG START ===');
      Logger.info('Employee ID: $employeeId');
      Logger.info('PIN: "$pin" (length: ${pin.length})');
      
      // Database is lazily initialized via PosDatabase.instance
      Logger.info('Database access prepared via singleton instance');
      
      // Validate PIN format (4-6 digits)
      if (!_isValidPin(pin)) {
        Logger.warning('Invalid PIN format provided for employee $employeeId - PIN: "$pin"');
        Logger.info('=== SETUP PIN DEBUG END (Invalid format) ===');
        return false;
      }
      Logger.info('PIN format validation passed');
      
      // Check if employee exists
      final existingEmployee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
          
      if (existingEmployee == null) {
        Logger.error('Employee $employeeId not found in database', 'Employee does not exist');
        Logger.info('=== SETUP PIN DEBUG END (Employee not found) ===');
        return false;
      }
      Logger.info('Employee found: ${existingEmployee.firstName} ${existingEmployee.lastName}');
      
      // Generate salt and hash the PIN
      final salt = _generateSalt();
      Logger.info('Generated salt length: ${salt.length}');
      
      final hashedPin = _hashPin(pin, salt);
      Logger.info('Generated hash length: ${hashedPin.length}');
      
      final now = DateTime.now().toIso8601String();
      Logger.info('Timestamp: $now');
      
      // Update employee record with PIN data
      final rowsAffected = await (_database.update(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(
            pinHash: Value(hashedPin),
            pinSalt: Value(salt),
            pinCreatedAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),);
      
      Logger.info('Database update completed. Rows affected: $rowsAffected');
      
      if (rowsAffected == 0) {
        Logger.error('No rows were updated during PIN setup for employee $employeeId', 'Update returned 0 rows affected');
        Logger.info('=== SETUP PIN DEBUG END (No rows affected) ===');
        return false;
      }
      
      // Verify the PIN was actually saved
      final updatedEmployee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
          
      if (updatedEmployee?.pinHash == null || updatedEmployee?.pinSalt == null) {
        Logger.error('PIN was not saved properly for employee $employeeId', 'PIN hash or salt is null after update');
        Logger.info('=== SETUP PIN DEBUG END (PIN not saved) ===');
        return false;
      }
      
      Logger.info('PIN verification: PIN hash saved successfully');
      Logger.info('Stored PIN hash length: ${updatedEmployee!.pinHash!.length}');
      Logger.info('Stored salt length: ${updatedEmployee.pinSalt!.length}');
      
      Logger.info('PIN setup successfully for employee $employeeId');
      Logger.info('=== SETUP PIN DEBUG END (Success) ===');
      return true;
      
    } catch (e, stack) {
      Logger.error('Error setting up PIN for employee $employeeId', e, stack);
      Logger.info('=== SETUP PIN DEBUG END (Exception) ===');
      return false;
    }
  }

  /// Verify PIN for an employee
  Future<bool> verifyPin(int employeeId, String pin) async {
    try {
      // Database is lazily initialized via PosDatabase.instance
      
      // Get employee PIN data
      final employee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
      
      if (employee == null) {
        Logger.warning('Employee $employeeId not found for PIN verification');
        return false;
      }
      
      if (employee.pinHash == null || employee.pinSalt == null) {
        Logger.warning('No PIN set up for employee $employeeId');
        return false;
      }
      
      // Hash the provided PIN with stored salt
      final hashedPin = _hashPin(pin, employee.pinSalt!);
      
      // Compare with stored hash
      final isValid = hashedPin == employee.pinHash;
      
      if (isValid) {
        // Update last used timestamp
        await _updatePinLastUsed(employeeId);
        Logger.info('PIN verification successful for employee $employeeId');
      } else {
        Logger.warning('PIN verification failed for employee $employeeId');
      }
      
      return isValid;
      
    } catch (e, stack) {
      Logger.error('Error verifying PIN for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Check if employee has a PIN set up
  Future<bool> hasPin(int employeeId) async {
    try {
      // Database is lazily initialized via PosDatabase.instance
      
      final employee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
      
      return employee?.pinHash != null && employee?.pinSalt != null;
      
    } catch (e, stack) {
      Logger.error('Error checking PIN setup for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Change PIN for an employee
  Future<bool> changePin(int employeeId, String oldPin, String newPin) async {
    try {
      // First verify the old PIN
      final oldPinValid = await verifyPin(employeeId, oldPin);
      if (!oldPinValid) {
        Logger.warning('Old PIN verification failed for employee $employeeId');
        return false;
      }
      
      // Set up the new PIN
      return await setupPin(employeeId, newPin);
      
    } catch (e, stack) {
      Logger.error('Error changing PIN for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Remove PIN for an employee
  Future<bool> removePin(int employeeId, String currentPin) async {
    try {
      // First verify the current PIN
      final pinValid = await verifyPin(employeeId, currentPin);
      if (!pinValid) {
        Logger.warning('PIN verification failed during PIN removal for employee $employeeId');
        return false;
      }
      
      // Database is lazily initialized via PosDatabase.instance
      
      // Clear PIN data
      await (_database.update(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(
            pinHash: const Value(null),
            pinSalt: const Value(null),
            pinCreatedAt: const Value(null),
            pinLastUsedAt: const Value(null),
            updatedAt: Value(DateTime.now()),
          ),);
      
      Logger.info('PIN removed successfully for employee $employeeId');
      return true;
      
    } catch (e, stack) {
      Logger.error('Error removing PIN for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Get PIN creation timestamp for an employee
  Future<DateTime?> getPinCreatedAt(int employeeId) async {
    try {
      // Database is lazily initialized via PosDatabase.instance
      
      final employee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
      
      if (employee?.pinCreatedAt != null) {
        return employee!.pinCreatedAt!;
      }
      
      return null;
      
    } catch (e, stack) {
      Logger.error('Error getting PIN creation date for employee $employeeId', e, stack);
      return null;
    }
  }

  /// Get PIN last used timestamp for an employee
  Future<DateTime?> getPinLastUsedAt(int employeeId) async {
    try {
      // Database is lazily initialized via PosDatabase.instance
      
      final employee = await (_database.select(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .getSingleOrNull();
      
      if (employee?.pinLastUsedAt != null) {
        return employee!.pinLastUsedAt!;
      }
      
      return null;
      
    } catch (e, stack) {
      Logger.error('Error getting PIN last used date for employee $employeeId', e, stack);
      return null;
    }
  }

  /// Get all employees with PIN set up
  Future<List<Employee>> getEmployeesWithPin() async {
    try {
      // Database is lazily initialized via PosDatabase.instance
      
      final employees = await (_database.select(_database.employees)
            ..where((e) => e.pinHash.isNotNull() & e.pinSalt.isNotNull()))
          .get();
      
      return employees;
      
    } catch (e, stack) {
      Logger.error('Error getting employees with PIN', e, stack);
      return [];
    }
  }

  /// Update PIN last used timestamp
  Future<void> _updatePinLastUsed(int employeeId) async {
    try {
      await (_database.update(_database.employees)
            ..where((e) => e.id.equals(employeeId)))
          .write(EmployeesCompanion(
            pinLastUsedAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),);
    } catch (e, stack) {
      Logger.error('Error updating PIN last used for employee $employeeId', e, stack);
      // Don't rethrow as this is not critical for PIN verification
    }
  }

  /// Validate PIN format (4-6 digits)
  bool _isValidPin(String pin) {
    final pinRegex = RegExp(r'^\d{4,6}$');
    return pinRegex.hasMatch(pin);
  }

  /// Validate PIN strength (no sequential or repeated digits)
  bool isStrongPin(String pin) {
    if (!_isValidPin(pin)) return false;
    
    // Check for all same digits (e.g., 1111, 2222)
    if (pin.split('').toSet().length == 1) {
      return false;
    }
    
    // Check for sequential ascending (e.g., 1234, 2345)
    bool isAscending = true;
    for (int i = 1; i < pin.length; i++) {
      if (int.parse(pin[i]) != int.parse(pin[i-1]) + 1) {
        isAscending = false;
        break;
      }
    }
    if (isAscending) return false;
    
    // Check for sequential descending (e.g., 4321, 5432)
    bool isDescending = true;
    for (int i = 1; i < pin.length; i++) {
      if (int.parse(pin[i]) != int.parse(pin[i-1]) - 1) {
        isDescending = false;
        break;
      }
    }
    if (isDescending) return false;
    
    return true;
  }

  /// Get PIN strength description
  String getPinStrengthDescription(String pin) {
    if (!_isValidPin(pin)) {
      return 'PIN must be 4-6 digits';
    }
    
    if (!isStrongPin(pin)) {
      return 'PIN is weak (avoid repeated or sequential digits)';
    }
    
    return 'PIN is strong';
  }
}
