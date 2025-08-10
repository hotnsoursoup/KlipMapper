// lib/core/auth/widgets/manager_auth_wrapper.dart
// Widget wrapper and dialog for manager authentication requiring PIN verification before sensitive operations. Provides authentication protection for privileged actions like refunds, discounts, and employee management.
// Usage: ACTIVE - Used throughout app for protecting manager-only operations and authentication gates

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../pin_auth_service.dart';
import '../../../features/shared/data/repositories/drift_employee_repository.dart';
import '../../../utils/error_logger.dart';
import 'pin_input_widget.dart';

/// Wrapper that requires manager authentication before allowing access to sensitive operations
class ManagerAuthWrapper extends StatefulWidget {
  final Widget child;
  final String title;
  final String description;
  final int? requesterEmployeeId; // Employee requesting the operation
  final VoidCallback? onAuthSuccess;
  final VoidCallback? onAuthFailure;
  final Function(bool success, int? managerId)? onComplete;

  const ManagerAuthWrapper({
    super.key,
    required this.child,
    required this.title,
    required this.description,
    this.requesterEmployeeId,
    this.onAuthSuccess,
    this.onAuthFailure,
    this.onComplete,
  });

  /// Show manager authentication dialog
  static Future<bool> authenticate({
    required BuildContext context,
    required String title,
    required String description,
    int? requesterEmployeeId,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ManagerAuthDialog(
        title: title,
        description: description,
        requesterEmployeeId: requesterEmployeeId,
      ),
    );
    return result ?? false;
  }

  /// Protect a widget with manager authentication
  static Widget protect({
    required Widget child,
    required String title,
    required String description,
    int? requesterEmployeeId,
    VoidCallback? onAuthSuccess,
    VoidCallback? onAuthFailure,
  }) {
    return ManagerAuthWrapper(
      title: title,
      description: description,
      requesterEmployeeId: requesterEmployeeId,
      onAuthSuccess: onAuthSuccess,
      onAuthFailure: onAuthFailure,
      child: child,
    );
  }

  @override
  State<ManagerAuthWrapper> createState() => _ManagerAuthWrapperState();
}

class _ManagerAuthWrapperState extends State<ManagerAuthWrapper> {
  bool _isAuthenticated = false;
  int? _authenticatedManagerId;

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    return GestureDetector(
      onTap: () => _showAuthDialog(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.warningOrange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.warningOrange.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.admin_panel_settings,
              color: AppColors.warningOrange,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              'Manager Authentication Required',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.warningOrange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This operation requires manager authorization. Tap to authenticate.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAuthDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ManagerAuthDialog(
        title: widget.title,
        description: widget.description,
        requesterEmployeeId: widget.requesterEmployeeId,
      ),
    );

    if (result == true) {
      setState(() {
        _isAuthenticated = true;
      });
      widget.onAuthSuccess?.call();
      widget.onComplete?.call(true, _authenticatedManagerId);
    } else {
      widget.onAuthFailure?.call();
      widget.onComplete?.call(false, null);
    }
  }
}

/// Dialog for manager authentication
class ManagerAuthDialog extends StatefulWidget {
  final String title;
  final String description;
  final int? requesterEmployeeId;

  const ManagerAuthDialog({
    super.key,
    required this.title,
    required this.description,
    this.requesterEmployeeId,
  });

  @override
  State<ManagerAuthDialog> createState() => _ManagerAuthDialogState();
}

class _ManagerAuthDialogState extends State<ManagerAuthDialog> {
  final _pinAuthService = PinAuthService.instance;
  final _employeeRepository = DriftEmployeeRepository.instance;
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  List<ManagerInfo> _availableManagers = [];
  ManagerInfo? _selectedManager;
  bool _isLoading = false;
  bool _isLoadingManagers = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadManagers();
    
    // Auto-focus PIN field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadManagers() async {
    try {
      final employees = await _employeeRepository.getEmployees();
      final managers = employees
          .where((emp) => _isManagerRole(emp.role) && emp.status == 'active')
          .map((emp) => ManagerInfo(
                id: emp.id,
                name: emp.displayName ?? '${emp.firstName} ${emp.lastName}'.trim(),
                role: emp.role,
              ),)
          .toList();

      if (mounted) {
        setState(() {
          _availableManagers = managers;
          _selectedManager = managers.isNotEmpty ? managers.first : null;
          _isLoadingManagers = false;
        });
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error loading managers', e, stack);
      if (mounted) {
        setState(() {
          _isLoadingManagers = false;
          _errorMessage = 'Failed to load managers. Please try again.';
        });
      }
    }
  }

  bool _isManagerRole(String role) {
    return role.toLowerCase() == 'manager' || 
           role.toLowerCase() == 'admin' || 
           role.toLowerCase() == 'owner';
  }

  Future<void> _authenticate() async {
    if (_selectedManager == null) {
      setState(() {
        _errorMessage = 'Please select a manager';
      });
      return;
    }

    if (_pinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the manager PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _pinAuthService.verifyPin(
        _selectedManager!.id,
        _pinController.text,
      );

      if (isValid) {
        ErrorLogger.logInfo('Manager authentication successful: ${_selectedManager!.name} (ID: ${_selectedManager!.id})');
        
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _errorMessage = 'Incorrect PIN for ${_selectedManager!.name}';
          _isLoading = false;
        });
        _pinController.clear();
        _pinFocusNode.requestFocus();
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error during manager authentication', e, stack);
      setState(() {
        _errorMessage = 'Authentication failed. Please try again.';
        _isLoading = false;
      });
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
        width: 450,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            if (_isLoadingManagers)
              _buildLoadingState()
            else if (_availableManagers.isEmpty)
              _buildNoManagersState()
            else ...[
              _buildManagerSelection(),
              const SizedBox(height: 20),
              _buildPinInput(),
              const SizedBox(height: 24),
              _buildActions(),
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.warningOrange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.admin_panel_settings,
            color: AppColors.warningOrange,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.title,
          style: AppTextStyles.headline2.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.requesterEmployeeId != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Requested by Employee ID: ${widget.requesterEmployeeId}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Loading available managers...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNoManagersState() {
    return Column(
      children: [
        Icon(
          Icons.warning,
          color: AppColors.errorRed,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          'No Managers Available',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.errorRed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No active managers found in the system. Please contact your administrator.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildManagerSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Manager',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ManagerInfo>(

              value: _selectedManager,
              isExpanded: true,
              onChanged: (manager) {
                setState(() {
                  _selectedManager = manager;
                  _errorMessage = null;
                  _pinController.clear();
                });
              },
              items: _availableManagers.map((manager) {
                return DropdownMenuItem<ManagerInfo>(
                  value: manager,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _getRoleColor(manager.role).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          _getRoleIcon(manager.role),
                          color: _getRoleColor(manager.role),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              manager.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              manager.role.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: _getRoleColor(manager.role),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinInput() {
    return PinVerificationWidget(
      controller: _pinController,
      focusNode: _pinFocusNode,
      errorText: _errorMessage,
      onChanged: (_) => setState(() => _errorMessage = null),
      onSubmitted: (_) => _authenticate(),
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
            onPressed: _isLoading ? null : _authenticate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningOrange,
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
                : const Text('Authenticate'),
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
      case 'owner':
        return AppColors.errorRed;
      case 'manager':
        return AppColors.primaryBlue;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
      case 'owner':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.supervisor_account;
      default:
        return Icons.person;
    }
  }
}

/// Manager information model
class ManagerInfo {
  final int id;
  final String name;
  final String role;

  ManagerInfo({
    required this.id,
    required this.name,
    required this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManagerInfo &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}