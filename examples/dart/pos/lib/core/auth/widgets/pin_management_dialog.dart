// lib/core/auth/widgets/pin_management_dialog.dart
// Advanced PIN management dialog supporting setup, change, and manager reset operations with multi-step flow. Features step indicators, role-based authentication, and comprehensive error handling.
// Usage: ACTIVE - Primary PIN management interface used for employee onboarding, security updates, and administrative PIN resets
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../pin_auth_service.dart';
import '../../../utils/error_logger.dart';
import 'pin_input_widget.dart';

/// Comprehensive PIN management dialog with multiple modes
class PinManagementDialog extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final PinManagementMode mode;
  final int? managerEmployeeId; // For manager reset operations
  final bool managerAlreadyVerified; // Skip manager auth if already verified
  final Function(bool success)? onComplete;

  const PinManagementDialog({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.mode,
    this.managerEmployeeId,
    this.managerAlreadyVerified = false,
    this.onComplete,
  });

  /// Factory for setting up a new PIN
  factory PinManagementDialog.setNew({
    required int employeeId,
    required String employeeName,
    Function(bool success)? onComplete,
  }) {
    return PinManagementDialog(
      employeeId: employeeId,
      employeeName: employeeName,
      mode: PinManagementMode.setNew,
      onComplete: onComplete,
    );
  }

  /// Factory for changing existing PIN
  factory PinManagementDialog.changeExisting({
    required int employeeId,
    required String employeeName,
    Function(bool success)? onComplete,
  }) {
    return PinManagementDialog(
      employeeId: employeeId,
      employeeName: employeeName,
      mode: PinManagementMode.changeExisting,
      onComplete: onComplete,
    );
  }

  /// Factory for manager reset
  factory PinManagementDialog.managerReset({
    required int employeeId,
    required String employeeName,
    required int managerEmployeeId,
    bool managerAlreadyVerified = false,
    Function(bool success)? onComplete,
  }) {
    return PinManagementDialog(
      employeeId: employeeId,
      employeeName: employeeName,
      mode: PinManagementMode.managerReset,
      managerEmployeeId: managerEmployeeId,
      managerAlreadyVerified: managerAlreadyVerified,
      onComplete: onComplete,
    );
  }

  @override
  State<PinManagementDialog> createState() => _PinManagementDialogState();
}

class _PinManagementDialogState extends State<PinManagementDialog> {
  final _pinAuthService = PinAuthService.instance;
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  late TextEditingController _confirmPinController; // Make it non-final so we can replace it
  final _managerPinController = TextEditingController();
  
  final _currentPinFocusNode = FocusNode();
  final _newPinFocusNode = FocusNode();
  final _confirmPinFocusNode = FocusNode();
  final _managerPinFocusNode = FocusNode();

  PinManagementStep _currentStep = PinManagementStep.initial;
  bool _isLoading = false;
  String? _errorMessage;
  int _confirmPinKeyCounter = 0; // Counter to force widget rebuilds

  @override
  void initState() {
    super.initState();
    
    // Initialize the confirm PIN controller
    _confirmPinController = TextEditingController();
    
    _initializeDialog();
    
    // Add listeners to controllers to update UI when text changes
    _currentPinController.addListener(() => setState(() {}));
    _newPinController.addListener(() => setState(() {}));
    _confirmPinController.addListener(() => setState(() {}));
    _managerPinController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    // Note: _confirmPinController might be replaced during PIN flow
    _confirmPinController.dispose();
    _managerPinController.dispose();
    _currentPinFocusNode.dispose();
    _newPinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    _managerPinFocusNode.dispose();
    super.dispose();
  }

  void _initializeDialog() {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        _currentStep = PinManagementStep.newPin;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _newPinFocusNode.requestFocus();
        });
        break;
      case PinManagementMode.changeExisting:
        _currentStep = PinManagementStep.currentPin;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _currentPinFocusNode.requestFocus();
        });
        break;
      case PinManagementMode.managerReset:
        if (widget.managerAlreadyVerified) {
          // Skip manager auth if already verified
          _currentStep = PinManagementStep.newPin;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _newPinFocusNode.requestFocus();
          });
        } else {
          _currentStep = PinManagementStep.managerAuth;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _managerPinFocusNode.requestFocus();
          });
        }
        break;
    }
  }

  String get _dialogTitle {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return 'Set Up PIN';
      case PinManagementMode.changeExisting:
        return 'Change PIN';
      case PinManagementMode.managerReset:
        return 'Reset PIN';
    }
  }

  String get _dialogSubtitle {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return 'Create a new PIN for ${widget.employeeName}';
      case PinManagementMode.changeExisting:
        return 'Update PIN for ${widget.employeeName}';
      case PinManagementMode.managerReset:
        return 'Manager reset PIN for ${widget.employeeName}';
    }
  }

  IconData get _dialogIcon {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return Icons.lock_outline;
      case PinManagementMode.changeExisting:
        return Icons.edit_outlined;
      case PinManagementMode.managerReset:
        return Icons.admin_panel_settings;
    }
  }

  Color get _dialogIconColor {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return AppColors.successGreen;
      case PinManagementMode.changeExisting:
        return AppColors.primaryBlue;
      case PinManagementMode.managerReset:
        return AppColors.warningOrange;
    }
  }

  Future<void> _handleCurrentPinSubmit() async {
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
        widget.employeeId,
        _currentPinController.text,
      );

      if (isValid) {
        setState(() {
          _currentStep = PinManagementStep.newPin;
          _isLoading = false;
        });
        
        // Clear new PIN fields when transitioning from current PIN verification
        _newPinController.clear();
        _confirmPinController.clear();
        
        // Focus new PIN field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _newPinFocusNode.requestFocus();
        });
      } else {
        setState(() {
          _errorMessage = 'Current PIN is incorrect';
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error verifying current PIN', e, stack);
      setState(() {
        _errorMessage = 'Error verifying PIN. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleManagerAuthSubmit() async {
    if (_managerPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter manager PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final managerId = widget.managerEmployeeId ?? 1; // Default to employee 1 if not specified
      final isValid = await _pinAuthService.verifyPin(
        managerId,
        _managerPinController.text,
      );

      if (isValid) {
        setState(() {
          _currentStep = PinManagementStep.newPin;
          _isLoading = false;
        });
        
        // Clear new PIN fields when transitioning from manager auth
        _newPinController.clear();
        _confirmPinController.clear();
        
        // Focus new PIN field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _newPinFocusNode.requestFocus();
        });
      } else {
        setState(() {
          _errorMessage = 'Manager PIN is incorrect';
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error verifying manager PIN', e, stack);
      setState(() {
        _errorMessage = 'Error verifying manager PIN. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleNewPinSubmit() async {
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

    if (_newPinController.text.length > 6) {
      setState(() {
        _errorMessage = 'PIN must be no more than 6 digits';
      });
      return;
    }

    ErrorLogger.logInfo('=== NEW PIN SUBMIT DEBUG START ===');
    ErrorLogger.logInfo('New PIN entered: "${_newPinController.text}" (length: ${_newPinController.text.length})');
    ErrorLogger.logInfo('Current confirm PIN text: "${_confirmPinController.text}"');
    
    // Create a completely new controller for the confirm PIN step
    _confirmPinController.dispose();
    _confirmPinController = TextEditingController();
    _confirmPinController.addListener(() => setState(() {}));
    
    // Increment counter to force complete widget rebuild
    _confirmPinKeyCounter++;
    
    ErrorLogger.logInfo('Created new confirm PIN controller. Text: "${_confirmPinController.text}"');
    ErrorLogger.logInfo('Confirm PIN key counter: $_confirmPinKeyCounter');
    
    setState(() {
      _currentStep = PinManagementStep.confirmPin;
      _errorMessage = null;
    });

    // Focus the new field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorLogger.logInfo('Post-frame: Confirm PIN text after rebuild: "${_confirmPinController.text}"');
      _confirmPinFocusNode.requestFocus();
    });
    
    ErrorLogger.logInfo('=== NEW PIN SUBMIT DEBUG END ===');
  }

  Future<void> _handleConfirmPinSubmit() async {
    ErrorLogger.logInfo('Confirm PIN submit called. New PIN: "${_newPinController.text}", Confirm PIN: "${_confirmPinController.text}"');
    
    if (_confirmPinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please confirm your new PIN';
      });
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      ErrorLogger.logInfo('PINs do not match. New: "${_newPinController.text}", Confirm: "${_confirmPinController.text}"');
      setState(() {
        _errorMessage = 'PINs do not match. Please try again.';
      });
      // Clear both PIN fields when they don't match for better UX
      _newPinController.clear();
      _confirmPinController.clear();
      setState(() {
        _currentStep = PinManagementStep.newPin;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _newPinFocusNode.requestFocus();
      });
      return;
    }

    ErrorLogger.logInfo('PINs match, proceeding to save');
    await _savePinAndComplete();
  }

  Future<void> _savePinAndComplete() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newPin = _newPinController.text;
      final confirmPin = _confirmPinController.text;
      
      ErrorLogger.logInfo('=== PIN SAVE DEBUG START ===');
      ErrorLogger.logInfo('Employee ID: ${widget.employeeId}');
      ErrorLogger.logInfo('Mode: ${widget.mode.name}');
      ErrorLogger.logInfo('New PIN: "$newPin" (length: ${newPin.length})');
      ErrorLogger.logInfo('Confirm PIN: "$confirmPin" (length: ${confirmPin.length})');
      ErrorLogger.logInfo('PINs match: ${newPin == confirmPin}');
      
      // Additional validation before saving
      if (newPin.isEmpty) {
        ErrorLogger.logError('PIN validation failed', 'PIN is empty');
        setState(() {
          _errorMessage = 'PIN cannot be empty';
          _isLoading = false;
        });
        return;
      }
      
      if (confirmPin.isEmpty) {
        ErrorLogger.logError('PIN validation failed', 'Confirm PIN is empty');
        setState(() {
          _errorMessage = 'Please confirm your PIN';
          _isLoading = false;
        });
        return;
      }
      
      if (newPin != confirmPin) {
        ErrorLogger.logError('PIN validation failed', 'PINs do not match');
        setState(() {
          _errorMessage = 'PINs do not match';
          _isLoading = false;
        });
        return;
      }
      
      if (newPin.length < 4) {
        ErrorLogger.logError('PIN validation failed', 'PIN too short');
        setState(() {
          _errorMessage = 'PIN must be at least 4 digits';
          _isLoading = false;
        });
        return;
      }
      
      if (newPin.length > 6) {
        ErrorLogger.logError('PIN validation failed', 'PIN too long');
        setState(() {
          _errorMessage = 'PIN must be no more than 6 digits';
          _isLoading = false;
        });
        return;
      }
      
      // Validate PIN format one more time before saving
      if (!RegExp(r'^\d{4,6}$').hasMatch(newPin)) {
        ErrorLogger.logError('PIN validation failed', 'PIN format invalid');
        setState(() {
          _errorMessage = 'PIN must contain only digits (4-6 digits)';
          _isLoading = false;
        });
        return;
      }
      
      ErrorLogger.logInfo('All validations passed, calling setupPin...');
      
      final success = await _pinAuthService.setupPin(
        widget.employeeId,
        newPin,
      );

      ErrorLogger.logInfo('setupPin returned: $success');

      if (success) {
        ErrorLogger.logInfo('PIN ${widget.mode.name} successful for employee ${widget.employeeId}');
        
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getSuccessMessage()),
              backgroundColor: AppColors.successGreen,
              duration: const Duration(seconds: 3),
            ),
          );
          
          Navigator.of(context).pop(true);
          widget.onComplete?.call(true);
        }
      } else {
        ErrorLogger.logError('PIN save failed for employee ${widget.employeeId}', 'setupPin returned false');
        setState(() {
          _errorMessage = 'Failed to save PIN. Database operation failed. Please try again.';
          _isLoading = false;
        });
      }
      
      ErrorLogger.logInfo('=== PIN SAVE DEBUG END ===');
      
    } catch (e, stack) {
      ErrorLogger.logError('Error saving PIN for employee ${widget.employeeId}', e, stack);
      setState(() {
        _errorMessage = 'Error saving PIN: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _getSuccessMessage() {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return 'PIN set up successfully for ${widget.employeeName}';
      case PinManagementMode.changeExisting:
        return 'PIN changed successfully for ${widget.employeeName}';
      case PinManagementMode.managerReset:
        return 'PIN reset successfully for ${widget.employeeName}';
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return _dialogTitle;
      case PinManagementStep.currentPin:
        return 'Enter Current PIN';
      case PinManagementStep.managerAuth:
        return 'Manager Authentication';
      case PinManagementStep.newPin:
        return widget.mode == PinManagementMode.setNew ? 'Create PIN' : 'Enter New PIN';
      case PinManagementStep.confirmPin:
        return 'Confirm PIN';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return _dialogSubtitle;
      case PinManagementStep.currentPin:
        return 'Enter your current PIN to continue';
      case PinManagementStep.managerAuth:
        return 'Manager authorization required to reset PIN';
      case PinManagementStep.newPin:
        return 'Enter your new PIN (4-6 digits)';
      case PinManagementStep.confirmPin:
        return 'Enter your new PIN again to confirm';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return const SizedBox.shrink();
      case PinManagementStep.currentPin:
        return PinVerificationWidget(
          controller: _currentPinController,
          focusNode: _currentPinFocusNode,
          errorText: _errorMessage,
          onChanged: (_) => setState(() => _errorMessage = null),
          onSubmitted: (_) => _handleCurrentPinSubmit(),
        );
      case PinManagementStep.managerAuth:
        return PinVerificationWidget(
          controller: _managerPinController,
          focusNode: _managerPinFocusNode,
          errorText: _errorMessage,
          onChanged: (_) => setState(() => _errorMessage = null),
          onSubmitted: (_) => _handleManagerAuthSubmit(),
        );
      case PinManagementStep.newPin:
        return PinSetupWidget(
          controller: _newPinController,
          focusNode: _newPinFocusNode,
          label: 'New PIN',
          errorText: _errorMessage,
          onChanged: (_) => setState(() => _errorMessage = null),
          onSubmitted: (_) => _handleNewPinSubmit(),
        );
      case PinManagementStep.confirmPin:
        return PinSetupWidget(
          key: ValueKey('confirm_pin_$_confirmPinKeyCounter'), // Force rebuild with counter
          controller: _confirmPinController,
          focusNode: _confirmPinFocusNode,
          label: 'Confirm New PIN',
          errorText: _errorMessage,
          onChanged: (value) {
            ErrorLogger.logInfo('Confirm PIN changed to: "$value"');
            setState(() => _errorMessage = null);
          },
          onSubmitted: (_) => _handleConfirmPinSubmit(),
        );
    }
  }

  String _getActionButtonText() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return 'Continue';
      case PinManagementStep.currentPin:
        return 'Verify';
      case PinManagementStep.managerAuth:
        return 'Authenticate';
      case PinManagementStep.newPin:
        return 'Continue';
      case PinManagementStep.confirmPin:
        return 'Save PIN';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return true;
      case PinManagementStep.currentPin:
        return _currentPinController.text.isNotEmpty && _currentPinController.text.length >= 4;
      case PinManagementStep.managerAuth:
        return _managerPinController.text.isNotEmpty && _managerPinController.text.length >= 4;
      case PinManagementStep.newPin:
        return _newPinController.text.isNotEmpty && 
               _newPinController.text.length >= 4 && 
               _newPinController.text.length <= 6;
      case PinManagementStep.confirmPin:
        return _confirmPinController.text.isNotEmpty && 
               _confirmPinController.text.length >= 4 && 
               _confirmPinController.text.length <= 6;
    }
  }

  void _handleActionButton() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        break;
      case PinManagementStep.currentPin:
        _handleCurrentPinSubmit();
        break;
      case PinManagementStep.managerAuth:
        _handleManagerAuthSubmit();
        break;
      case PinManagementStep.newPin:
        _handleNewPinSubmit();
        break;
      case PinManagementStep.confirmPin:
        _handleConfirmPinSubmit();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 480,
        constraints: const BoxConstraints(
          maxHeight: 650,
          minHeight: 400,
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStepIndicator(),
            const SizedBox(height: 24),
            _buildStepContent(),
            const SizedBox(height: 32),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _dialogIconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _dialogIcon,
            color: _dialogIconColor,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _dialogTitle,
          style: AppTextStyles.headline2.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _dialogSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final totalSteps = _getTotalSteps();
    final currentStepIndex = _getCurrentStepIndex();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStepIndex;
        final isCurrent = index == currentStepIndex;
        
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent 
                    ? _dialogIconColor 
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        '${index + 1}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 40,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? _dialogIconColor 
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        );
      }),
    );
  }

  int _getTotalSteps() {
    switch (widget.mode) {
      case PinManagementMode.setNew:
        return 2; // New PIN -> Confirm PIN
      case PinManagementMode.changeExisting:
        return 3; // Current PIN -> New PIN -> Confirm PIN
      case PinManagementMode.managerReset:
        return widget.managerAlreadyVerified ? 2 : 3; // Skip manager auth if already verified
    }
  }

  int _getCurrentStepIndex() {
    switch (_currentStep) {
      case PinManagementStep.initial:
        return 0;
      case PinManagementStep.currentPin:
      case PinManagementStep.managerAuth:
        return 0;
      case PinManagementStep.newPin:
        if (widget.mode == PinManagementMode.setNew) {
          return 0;
        } else if (widget.mode == PinManagementMode.managerReset && widget.managerAlreadyVerified) {
          return 0; // First step for pre-verified manager reset
        } else {
          return 1;
        }
      case PinManagementStep.confirmPin:
        if (widget.mode == PinManagementMode.setNew) {
          return 1;
        } else if (widget.mode == PinManagementMode.managerReset && widget.managerAlreadyVerified) {
          return 1; // Second step for pre-verified manager reset
        } else {
          return 2;
        }
    }
  }

  Widget _buildStepContent() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getStepTitle(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getStepDescription(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildCurrentStep(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: (_isLoading || !_canProceed()) ? null : _handleActionButton,
            style: ElevatedButton.styleFrom(
              backgroundColor: _dialogIconColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(_getActionButtonText()),
          ),
        ),
      ],
    );
  }
}

/// PIN management modes
enum PinManagementMode {
  setNew,
  changeExisting,
  managerReset,
}

/// PIN management steps
enum PinManagementStep {
  initial,
  currentPin,
  managerAuth,
  newPin,
  confirmPin,
}