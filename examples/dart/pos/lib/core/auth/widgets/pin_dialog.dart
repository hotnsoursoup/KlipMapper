// lib/core/auth/widgets/pin_dialog.dart
// Comprehensive PIN dialog widget supporting verification, setup, and change operations with confirmation flow. Provides secure PIN entry with error handling and loading states.
// Usage: ACTIVE - Core security component used throughout app for privileged operations, employee authentication, and PIN management
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../pin_auth_service.dart';
import 'pin_input_widget.dart';

/// Dialog for PIN entry and verification
class PinDialog extends StatefulWidget {
  final int employeeId;
  final String title;
  final String? subtitle;
  final String actionLabel;
  final bool isSetup; // true for PIN setup, false for verification
  final String? currentPin; // for PIN change operations
  final Function(bool success, String? pin)? onComplete;

  const PinDialog({
    super.key,
    required this.employeeId,
    required this.title,
    this.subtitle,
    required this.actionLabel,
    this.isSetup = false,
    this.currentPin,
    this.onComplete,
  });

  /// Factory for PIN verification
  factory PinDialog.verify({
    required int employeeId,
    String title = 'Enter PIN',
    String? subtitle,
    Function(bool success, String? pin)? onComplete,
  }) {
    return PinDialog(
      employeeId: employeeId,
      title: title,
      subtitle: subtitle ?? 'Enter your PIN to continue',
      actionLabel: 'Verify',
      onComplete: onComplete,
    );
  }

  /// Factory for PIN setup
  factory PinDialog.setup({
    required int employeeId,
    String title = 'Set Up PIN',
    String? subtitle,
    Function(bool success, String? pin)? onComplete,
  }) {
    return PinDialog(
      employeeId: employeeId,
      title: title,
      subtitle: subtitle ?? 'Create a 4-6 digit PIN for secure access',
      actionLabel: 'Set PIN',
      isSetup: true,
      onComplete: onComplete,
    );
  }

  /// Factory for PIN change
  factory PinDialog.change({
    required int employeeId,
    required String currentPin,
    String title = 'Change PIN',
    String? subtitle,
    Function(bool success, String? pin)? onComplete,
  }) {
    return PinDialog(
      employeeId: employeeId,
      title: title,
      subtitle: subtitle ?? 'Enter a new 4-6 digit PIN',
      actionLabel: 'Change PIN',
      isSetup: true,
      currentPin: currentPin,
      onComplete: onComplete,
    );
  }

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  final _confirmPinFocusNode = FocusNode();
  final _pinAuthService = PinAuthService.instance;
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    
    // Auto-focus PIN field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPinInput(),
            if (widget.isSetup && _showConfirmation) ...[
              const SizedBox(height: 16),
              _buildConfirmPinInput(),
            ],
            const SizedBox(height: 24),
            _buildActions(),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock,
            color: AppColors.primaryBlue,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.title,
          style: AppTextStyles.headline2.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.subtitle!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildPinInput() {
    if (widget.isSetup) {
      return PinSetupWidget(
        controller: _pinController,
        focusNode: _pinFocusNode,
        label: _showConfirmation ? 'New PIN' : 'Create PIN',
        errorText: _errorMessage,
        onChanged: (value) {
          setState(() {
            _errorMessage = null;
          });
        },
        onSubmitted: (value) {
          if (!_showConfirmation) {
            _proceedToConfirmation();
          } else {
            _handleAction();
          }
        },
      );
    } else {
      return PinVerificationWidget(
        controller: _pinController,
        focusNode: _pinFocusNode,
        errorText: _errorMessage,
        onChanged: (value) {
          setState(() {
            _errorMessage = null;
          });
        },
        onSubmitted: (value) {
          _handleAction();
        },
      );
    }
  }

  Widget _buildConfirmPinInput() {
    return PinSetupWidget(
      controller: _confirmPinController,
      focusNode: _confirmPinFocusNode,
      label: 'Confirm PIN',
      errorText: _errorMessage,
      onChanged: (value) {
        setState(() {
          _errorMessage = null;
        });
      },
      onSubmitted: (value) {
        _handleAction();
      },
    );
  }


  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.isSetup && !_showConfirmation ? 'Next' : widget.actionLabel,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error,
            color: AppColors.errorRed,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToConfirmation() {
    final pin = _pinController.text.trim();
    
    if (pin.length < 4 || pin.length > 6) {
      setState(() {
        _errorMessage = 'PIN must be 4-6 digits';
      });
      return;
    }

    setState(() {
      _showConfirmation = true;
      _errorMessage = null;
    });

    // Focus confirm PIN field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confirmPinFocusNode.requestFocus();
    });
  }

  void _handleAction() async {
    final pin = _pinController.text.trim();
    
    if (pin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a PIN';
      });
      return;
    }

    if (widget.isSetup) {
      if (!_showConfirmation) {
        _proceedToConfirmation();
        return;
      }
      
      // Setup or change PIN
      final confirmPin = _confirmPinController.text.trim();
      
      if (pin != confirmPin) {
        setState(() {
          _errorMessage = 'PINs do not match';
        });
        return;
      }
      
      await _setupOrChangePin(pin);
    } else {
      // Verify PIN
      await _verifyPin(pin);
    }
  }

  Future<void> _setupOrChangePin(String pin) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success;
      
      if (widget.currentPin != null) {
        // Change PIN
        success = await _pinAuthService.changePin(
          widget.employeeId, 
          widget.currentPin!, 
          pin,
        );
      } else {
        // Setup new PIN
        success = await _pinAuthService.setupPin(widget.employeeId, pin);
      }

      if (success) {
        widget.onComplete?.call(true, pin);
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _errorMessage = widget.currentPin != null 
              ? 'Failed to change PIN. Please try again.'
              : 'Failed to set up PIN. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyPin(String pin) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _pinAuthService.verifyPin(widget.employeeId, pin);
      
      if (success) {
        widget.onComplete?.call(true, pin);
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _errorMessage = 'Invalid PIN. Please try again.';
        });
        
        // Clear PIN field and refocus
        _pinController.clear();
        _pinFocusNode.requestFocus();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}