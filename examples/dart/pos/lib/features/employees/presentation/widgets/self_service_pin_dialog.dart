// lib/features/employees/presentation/widgets/self_service_pin_dialog.dart
// Self-service PIN change dialog allowing employees to update their security PIN independently.
// Implements multi-step verification process with current PIN validation, new PIN creation, and confirmation.
// Usage: ACTIVE - Used for employee self-service PIN management in profile screens

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/auth/pin_auth_service.dart';
import '../../../../core/auth/widgets/pin_input_widget.dart';
import '../../../../utils/error_logger.dart';
import '../../../shared/data/models/employee_model.dart';

/// Self-service PIN change dialog for employees
class SelfServicePinDialog extends StatefulWidget {
  final Employee employee;
  final Function(bool success)? onComplete;

  const SelfServicePinDialog({
    super.key,
    required this.employee,
    this.onComplete,
  });

  @override
  State<SelfServicePinDialog> createState() => _SelfServicePinDialogState();
}

class _SelfServicePinDialogState extends State<SelfServicePinDialog> {
  final _pinAuthService = PinAuthService.instance;
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _currentPinFocusNode = FocusNode();
  final _newPinFocusNode = FocusNode();
  final _confirmPinFocusNode = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;
  int _currentStep = 0; // 0: current PIN, 1: new PIN, 2: confirm PIN

  @override
  void initState() {
    super.initState();
    // Focus current PIN field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentPinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _currentPinFocusNode.dispose();
    _newPinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyCurrentPin() async {
    if (_currentPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your current PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _pinAuthService.verifyPin(
        widget.employee.id,
        _currentPinController.text,
      );

      if (mounted) {
        if (isValid) {
          setState(() {
            _currentStep = 1;
            _isLoading = false;
          });
          // Focus new PIN field
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _newPinFocusNode.requestFocus();
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Current PIN is incorrect';
          });
        }
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error verifying current PIN', e, stack);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to verify PIN. Please try again.';
        });
      }
    }
  }

  void _proceedToConfirmStep() {
    if (_newPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new PIN';
      });
      return;
    }

    if (_newPinController.text.length < 4) {
      setState(() {
        _errorMessage = 'PIN must be at least 4 digits';
      });
      return;
    }

    // Check if new PIN is different from current PIN
    if (_newPinController.text == _currentPinController.text) {
      setState(() {
        _errorMessage = 'New PIN must be different from current PIN';
      });
      return;
    }

    setState(() {
      _currentStep = 2;
      _errorMessage = null;
    });

    // Focus confirm PIN field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confirmPinFocusNode.requestFocus();
    });
  }

  Future<void> _changePIN() async {
    if (_confirmPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please confirm your new PIN';
      });
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = 'PINs do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _pinAuthService.setupPin(
        widget.employee.id,
        _newPinController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ErrorLogger.logInfo('PIN changed successfully for employee ${widget.employee.id}');
          
          // Show success message
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.successGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PIN Changed!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Your PIN has been successfully updated. Use your new PIN for all secure operations.',
                style: AppTextStyles.bodyMedium,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close success dialog
                    Navigator.of(context).pop(); // Close PIN change dialog
                    widget.onComplete?.call(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to change PIN. Please try again.';
          });
        }
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error changing PIN', e, stack);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _errorMessage = null;
      });

      // Focus appropriate field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentStep == 0) {
          _currentPinFocusNode.requestFocus();
        } else if (_currentStep == 1) {
          _newPinFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    color: AppColors.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Your PIN',
                        style: AppTextStyles.headline3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.employee.fullName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onComplete?.call(false);
                  },
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Progress indicator
            Row(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? AppColors.primaryBlue
                            : AppColors.border.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (i < 2) const SizedBox(width: 8),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Content based on current step
            if (_currentStep == 0) ...[
              // Current PIN step
              Text(
                'Enter Your Current PIN',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter your current PIN to verify your identity.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PinVerificationWidget(
                controller: _currentPinController,
                focusNode: _currentPinFocusNode,
                errorText: _errorMessage,
                onSubmitted: (_) => _verifyCurrentPin(),
              ),
            ] else if (_currentStep == 1) ...[
              // New PIN step
              Text(
                'Create New PIN',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a new 4-6 digit PIN for secure operations.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PinSetupWidget(
                controller: _newPinController,
                focusNode: _newPinFocusNode,
                errorText: _errorMessage,
                onSubmitted: (_) => _proceedToConfirmStep(),
              ),
            ] else if (_currentStep == 2) ...[
              // Confirm PIN step
              Text(
                'Confirm New PIN',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Re-enter your new PIN to confirm.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PinVerificationWidget(
                controller: _confirmPinController,
                focusNode: _confirmPinFocusNode,
                errorText: _errorMessage,
                onSubmitted: (_) => _changePIN(),
              ),
            ],

            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _goBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _currentStep == 0
                            ? _verifyCurrentPin
                            : _currentStep == 1
                                ? _proceedToConfirmStep
                                : _changePIN,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(_currentStep == 0
                            ? 'Verify'
                            : _currentStep == 1
                                ? 'Continue'
                                : 'Change PIN',),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}