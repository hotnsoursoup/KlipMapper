// lib/core/auth/widgets/pin_protected_wrapper.dart
// Wrapper widget that protects sensitive functions with PIN authentication and session timeout handling. Provides authentication gate for employee-specific operations and secure access control.
// Usage: ACTIVE - Used to wrap protected operations requiring employee PIN verification

import 'package:flutter/material.dart';
import '../pin_auth_service.dart';
import 'pin_dialog.dart';
import '../../utils/logger.dart';

/// Wrapper widget that protects sensitive functions with PIN authentication
class PinProtectedWrapper extends StatelessWidget {
  final int employeeId;
  final Widget child;
  final VoidCallback onAccessGranted;
  final String? authMessage;
  final bool requirePinSetup;
  final Duration? sessionTimeout;
  final VoidCallback? onAccessDenied;
  final VoidCallback? onPinSetupRequired;

  const PinProtectedWrapper({
    super.key,
    required this.employeeId,
    required this.child,
    required this.onAccessGranted,
    this.authMessage,
    this.requirePinSetup = false,
    this.sessionTimeout,
    this.onAccessDenied,
    this.onPinSetupRequired,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: child,
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    try {
      final pinAuthService = PinAuthService.instance;
      
      // Check if employee has PIN set up
      final hasPin = await pinAuthService.hasPin(employeeId);
      
      // Check if context is still valid after async operation
      if (!context.mounted) return;
      
      if (!hasPin) {
        if (requirePinSetup) {
          // Show PIN setup dialog
          await _showPinSetupDialog(context);
          return;
        } else {
          // PIN not required, proceed directly
          onAccessGranted();
          return;
        }
      }
      
      // Show PIN verification dialog
      await _showPinVerificationDialog(context);
      
    } catch (e, stack) {
      Logger.error('Error in PinProtectedWrapper', e, stack);
      if (context.mounted) {
        _showErrorDialog(context, 'An error occurred. Please try again.');
      }
    }
  }

  Future<void> _showPinSetupDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinDialog.setup(
        employeeId: employeeId,
        subtitle: authMessage ?? 'Set up a PIN to access this feature',
        onComplete: (success, pin) {
          if (success) {
            Logger.info('PIN setup completed for employee $employeeId');
          }
        },
      ),
    );

    if (result == true) {
      onAccessGranted();
    } else {
      onPinSetupRequired?.call();
    }
  }

  Future<void> _showPinVerificationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PinDialog.verify(
        employeeId: employeeId,
        subtitle: authMessage ?? 'Enter your PIN to continue',
        onComplete: (success, pin) {
          if (success) {
            Logger.info('PIN verification successful for employee $employeeId');
          }
        },
      ),
    );

    if (result == true) {
      onAccessGranted();
    } else {
      onAccessDenied?.call();
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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

/// Function-based PIN protection for direct use
class PinProtection {
  static final PinAuthService _pinAuthService = PinAuthService.instance;

  /// Protect a function with PIN authentication
  static Future<void> protect({
    required BuildContext context,
    required int employeeId,
    required VoidCallback onAccessGranted,
    String? authMessage,
    bool requirePinSetup = false,
    VoidCallback? onAccessDenied,
    VoidCallback? onPinSetupRequired,
  }) async {
    try {
      // Check if employee has PIN set up
      final hasPin = await _pinAuthService.hasPin(employeeId);
      
      // Check if context is still valid after async operation
      if (!context.mounted) return;
      
      if (!hasPin) {
        if (requirePinSetup) {
          // Show PIN setup dialog
          final result = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => PinDialog.setup(
              employeeId: employeeId,
              subtitle: authMessage ?? 'Set up a PIN to access this feature',
            ),
          );

          if (result == true) {
            onAccessGranted();
          } else {
            onPinSetupRequired?.call();
          }
          return;
        } else {
          // PIN not required, proceed directly
          onAccessGranted();
          return;
        }
      }
      
      // Show PIN verification dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => PinDialog.verify(
          employeeId: employeeId,
          subtitle: authMessage ?? 'Enter your PIN to continue',
        ),
      );

      if (result == true) {
        onAccessGranted();
      } else {
        onAccessDenied?.call();
      }
      
    } catch (e, stack) {
      Logger.error('Error in PinProtection.protect', e, stack);
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again.'),
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
  }

  /// Quick PIN verification for existing setup
  static Future<bool> verify({
    required BuildContext context,
    required int employeeId,
    String? authMessage,
  }) async {
    try {
      final hasPin = await _pinAuthService.hasPin(employeeId);
      
      // Check if context is still valid after async operation
      if (!context.mounted) return false;
      
      if (!hasPin) {
        return true; // No PIN required
      }
      
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => PinDialog.verify(
          employeeId: employeeId,
          subtitle: authMessage ?? 'Enter your PIN to continue',
        ),
      );

      return result == true;
      
    } catch (e, stack) {
      Logger.error('Error in PinProtection.verify', e, stack);
      return false;
    }
  }

  /// Check if employee has PIN without showing dialog
  static Future<bool> hasPin(int employeeId) async {
    try {
      return await _pinAuthService.hasPin(employeeId);
    } catch (e, stack) {
      Logger.error('Error checking PIN status for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Setup PIN for employee
  static Future<bool> setupPin({
    required BuildContext context,
    required int employeeId,
    String? title,
    String? subtitle,
  }) async {
    try {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => PinDialog.setup(
          employeeId: employeeId,
          title: title ?? 'Set Up PIN',
          subtitle: subtitle ?? 'Create a 4-6 digit PIN for secure access',
        ),
      );

      return result == true;
      
    } catch (e, stack) {
      Logger.error('Error setting up PIN for employee $employeeId', e, stack);
      return false;
    }
  }

  /// Change PIN for employee
  static Future<bool> changePin({
    required BuildContext context,
    required int employeeId,
    String? title,
    String? subtitle,
  }) async {
    try {
      // First verify current PIN
      final currentPinVerified = await verify(
        context: context,
        employeeId: employeeId,
        authMessage: 'Enter your current PIN to change it',
      );

      if (!currentPinVerified) {
        return false;
      }

      // Check if context is still valid after async operation
      if (!context.mounted) return false;

      // Get current PIN (we'll need to modify this to get the actual PIN)
      // For now, we'll use a placeholder approach
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => PinDialog.setup(
          employeeId: employeeId,
          title: title ?? 'Change PIN',
          subtitle: subtitle ?? 'Enter a new 4-6 digit PIN',
        ),
      );

      return result == true;
      
    } catch (e, stack) {
      Logger.error('Error changing PIN for employee $employeeId', e, stack);
      return false;
    }
  }
}

/// Extension methods for easier PIN protection
extension PinProtectedWidget on Widget {
  /// Wrap this widget with PIN protection
  Widget pinProtected({
    required BuildContext context,
    required int employeeId,
    required VoidCallback onAccessGranted,
    String? authMessage,
    bool requirePinSetup = false,
    VoidCallback? onAccessDenied,
    VoidCallback? onPinSetupRequired,
  }) {
    return PinProtectedWrapper(
      employeeId: employeeId,
      onAccessGranted: onAccessGranted,
      authMessage: authMessage,
      requirePinSetup: requirePinSetup,
      onAccessDenied: onAccessDenied,
      onPinSetupRequired: onPinSetupRequired,
      child: this,
    );
  }
}