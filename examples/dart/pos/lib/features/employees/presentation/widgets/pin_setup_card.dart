// lib/features/employees/presentation/widgets/pin_setup_card.dart
// Professional PIN setup and management card widget for employee security configuration.
// Provides PIN status display, setup dialogs, and manager reset functionality with authentication.
// Usage: ACTIVE - Used in employee profile screens for PIN management

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/auth/pin_auth_service.dart';
import '../../../../core/auth/widgets/pin_management_dialog.dart';
import '../../../../utils/error_logger.dart';
import '../../../shared/data/models/employee_model.dart';

/// Professional PIN setup and management card for employee profiles
class PinSetupCard extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onPinChanged;
  final bool showManagerActions;
  final int? currentManagerId;
  final bool managerAlreadyVerified;

  const PinSetupCard({
    super.key,
    required this.employee,
    this.onPinChanged,
    this.showManagerActions = false,
    this.currentManagerId,
    this.managerAlreadyVerified = false,
  });

  @override
  State<PinSetupCard> createState() => _PinSetupCardState();
}

class _PinSetupCardState extends State<PinSetupCard> {
  final _pinAuthService = PinAuthService.instance;
  bool _hasPin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPinStatus();
  }

  Future<void> _loadPinStatus() async {
    try {
      final hasPin = await _pinAuthService.hasPin(widget.employee.id);
      if (mounted) {
        setState(() {
          _hasPin = hasPin;
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error loading PIN status for employee ${widget.employee.id}', e, stack);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSetNewPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.setNew(
        employeeId: widget.employee.id,
        employeeName: widget.employee.fullName,
        onComplete: (success) {
          if (success) {
            _loadPinStatus();
            widget.onPinChanged?.call();
          }
        },
      ),
    );
  }

  void _showChangePinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.changeExisting(
        employeeId: widget.employee.id,
        employeeName: widget.employee.fullName,
        onComplete: (success) {
          if (success) {
            _loadPinStatus();
            widget.onPinChanged?.call();
          }
        },
      ),
    );
  }

  void _showManagerResetDialog() {
    if (!widget.showManagerActions || widget.currentManagerId == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.managerReset(
        employeeId: widget.employee.id,
        employeeName: widget.employee.fullName,
        managerEmployeeId: widget.currentManagerId!,
        managerAlreadyVerified: widget.managerAlreadyVerified,
        onComplete: (success) {
          if (success) {
            _loadPinStatus();
            widget.onPinChanged?.call();
          }
        },
      ),
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          maxHeight: 400, // Limit the maximum height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PIN Management',
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage PIN for ${widget.employee.fullName}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            
            if (_hasPin) ...[
              _buildActionTile(
                icon: Icons.edit_outlined,
                title: 'Change PIN',
                subtitle: 'Update existing PIN',
                color: AppColors.primaryBlue,
                onTap: () {
                  Navigator.pop(context);
                  // Small delay to ensure bottom sheet is fully dismissed
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _showChangePinDialog();
                  });
                },
              ),
              const SizedBox(height: 8),
            ] else ...[
              _buildActionTile(
                icon: Icons.lock_outline,
                title: 'Set New PIN',
                subtitle: 'Create a secure PIN',
                color: AppColors.successGreen,
                onTap: () {
                  Navigator.pop(context);
                  // Small delay to ensure bottom sheet is fully dismissed
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _showSetNewPinDialog();
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
            
            if (widget.showManagerActions && widget.currentManagerId != null && !widget.managerAlreadyVerified) ...[
              _buildActionTile(
                icon: Icons.admin_panel_settings,
                title: 'Manager Reset',
                subtitle: 'Reset PIN with manager authorization',
                color: AppColors.warningOrange,
                onTap: () {
                  Navigator.pop(context);
                  // Small delay to ensure bottom sheet is fully dismissed
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _showManagerResetDialog();
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
            
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading PIN status...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200, // Even more generous to prevent any overflow
        ),
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              _hasPin 
                  ? AppColors.successGreen.withValues(alpha: 0.02)
                  : AppColors.warningOrange.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (_hasPin ? AppColors.successGreen : AppColors.warningOrange)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _hasPin ? Icons.lock : Icons.lock_open,
                      color: _hasPin ? AppColors.successGreen : AppColors.warningOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PIN Security',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          _hasPin ? 'Secured' : 'Not Set',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: _hasPin ? AppColors.successGreen : AppColors.warningOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (_hasPin ? AppColors.successGreen : AppColors.warningOrange)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _hasPin ? Icons.check_circle : Icons.warning,
                      color: _hasPin ? AppColors.successGreen : AppColors.warningOrange,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _hasPin
                    ? 'PIN is configured for secure operations.'
                    : 'No PIN configured. Employee cannot perform secure operations.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showActionSheet,
                      icon: Icon(_hasPin ? Icons.settings : Icons.add),
                      label: Text(_hasPin ? 'Manage PIN' : 'Set Up PIN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasPin ? AppColors.primaryBlue : AppColors.successGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}