// lib/features/employees/presentation/widgets/employee_grid_card.dart
// Employee grid card widget displaying employee information in grid layout with Riverpod and time tracking integration. Features employee status, time tracking controls, and quick action buttons for efficient staff management.
// Usage: ACTIVE - Used in employee screen grid view for employee overview and time tracking

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../dashboard/providers/employee_status_provider.dart';
import '../../../employees/providers/employees_provider.dart';
import '../../../../utils/error_logger.dart';
import '../../../shared/data/models/employee_model.dart';
import 'self_service_pin_dialog.dart';

/// Professional, compact employee grid card with minimal colors and PIN status
/// Optimized StatefulWidget with Observer pattern for performance
class EmployeeGridCard extends ConsumerStatefulWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const EmployeeGridCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  @override
  ConsumerState<EmployeeGridCard> createState() => _EmployeeGridCardState();
}

class _EmployeeGridCardState extends ConsumerState<EmployeeGridCard> {
  bool _isClockOperationInProgress = false;

  Future<void> _handleClockInOut() async {
    if (_isClockOperationInProgress) return;
    
    setState(() {
      _isClockOperationInProgress = true;
    });

    try {
      final isClockedIn = await ref.read(employeeClockedInProvider(widget.employee.id).future);
      final employeeId = widget.employee.id;
      
      ErrorLogger.logInfo('Attempting to ${isClockedIn ? "clock out" : "clock in"} employee ID: $employeeId (${widget.employee.fullName})');
      
      if (isClockedIn) {
        // Clock out
        try {
          await ref.read(employeeStatusProvider.notifier).clockOut(employeeId);
          ErrorLogger.logInfo('Clock out successful for employee ID: $employeeId');
          _showSnackBar('${widget.employee.displayNameOrFullName} clocked out successfully', AppColors.warningOrange);
          // Refresh employee status
          ref.invalidate(employeeClockedInProvider(employeeId));
          ref.invalidate(employeeStatusProvider);
        } catch (e, stack) {
          ErrorLogger.logError('Clock out failed for employee ID: $employeeId', e, stack);
          _showSnackBar('Failed to clock out ${widget.employee.displayNameOrFullName}', AppColors.errorRed);
        }
      } else {
        try {
          await ref.read(employeeStatusProvider.notifier).clockIn(employeeId);
          ErrorLogger.logInfo('Clock in successful for employee ID: $employeeId');
          _showSnackBar('${widget.employee.displayNameOrFullName} clocked in successfully', AppColors.successGreen);
          // Refresh employee status
          ref.invalidate(employeeClockedInProvider(employeeId));
          ref.invalidate(employeeStatusProvider);
        } catch (e, stack) {
          ErrorLogger.logError('Clock in failed for employee ID: $employeeId', e, stack);
          _showSnackBar('Failed to clock in ${widget.employee.displayNameOrFullName}', AppColors.errorRed);
        }
      }
    } catch (e, stack) {
      ErrorLogger.logError('Clock operation error for employee ${widget.employee.id}', e, stack);
      _showSnackBar('Error during clock operation', AppColors.errorRed);
    } finally {
      if (mounted) {
        setState(() {
          _isClockOperationInProgress = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show PIN change menu on long press
  void _showPinChangeMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
            Text(
              widget.employee.displayNameOrFullName,
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Employee Actions',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              title: const Text('Change My PIN'),
              subtitle: const Text('Update your security PIN'),
              onTap: () {
                Navigator.pop(context);
                _showSelfServicePinDialog();
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Show self-service PIN change dialog
  void _showSelfServicePinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SelfServicePinDialog(
        employee: widget.employee,
        onComplete: (success) {
          if (success) {
            _showSnackBar('PIN updated successfully', AppColors.successGreen);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isClockedIn = ref.watch(employeeClockedInProvider(widget.employee.id));
    
    final fullName = widget.employee.displayNameOrFullName;
    final initials = _getInitials(fullName);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: widget.onEdit,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    // Header row with avatar, name, and status
                    Row(
                      children: [
                        // Compact avatar with clock-based styling
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                isClockedIn ? _getRoleColor(widget.employee.role) : AppColors.textSecondary,
                                isClockedIn ? _getRoleColor(widget.employee.role).withValues(alpha: 0.8) : AppColors.textSecondary.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isClockedIn 
                                    ? _getRoleColor(widget.employee.role).withValues(alpha: 0.3)
                                    : AppColors.textSecondary.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name positioned to the right of avatar
                        Expanded(
                          child: Text(
                            fullName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isClockedIn ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Service category icons at top right
                        if (widget.employee.capabilities.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.employee.capabilities.take(4).map((capability) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  _getCapabilityIcon(capability.id),
                                  size: 16,
                                  color: _getCapabilityColor(capability.id),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Role - neutral styling
                    Text(
                      _formatRole(widget.employee.role),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isClockedIn ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Bottom row: Phone info and Clock button
                    Row(
                      children: [
                        // Phone - compact
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatPhone(widget.employee.phone),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isClockedIn ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Clock In/Out Button - compact size with long-press PIN change
                        SizedBox(
                          height: 28,
                          child: GestureDetector(
                            onTap: _isClockOperationInProgress ? null : _handleClockInOut,
                            onLongPress: _isClockOperationInProgress ? null : _showPinChangeMenu,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isClockedIn ? AppColors.warningOrange : AppColors.successGreen,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _isClockOperationInProgress
                                      ? const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(
                                          isClockedIn ? Icons.logout : Icons.login,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isClockedIn ? 'Out' : 'In',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
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

  String _formatPhone(String phone) {
    // Show only last 4 digits for privacy
    if (phone.length >= 4) {
      final lastFour = phone.substring(phone.length - 4);
      return '***-$lastFour';
    }
    return phone;
  }

  String _formatRole(String role) {
    return role.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1).toLowerCase(),
    ).join(' ');
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return 'EM';
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.errorRed;
      case 'manager':
        return AppColors.primaryBlue;
      case 'technician':
        return AppColors.successGreen;
      case 'receptionist':
        return AppColors.servicePurple;
      case 'staff':
        return AppColors.warningOrange;
      default:
        return AppColors.textSecondary;
    }
  }
  
  /// Get icon for capability
  IconData _getCapabilityIcon(String capabilityId) {
    switch (capabilityId) {
      case 'mani_pedi':
        return Icons.colorize; // Nail polish
      case 'gels':
        return Icons.water_drop; // Gel drop
      case 'acrylics':
        return Icons.architecture; // Structure/building
      case 'waxing':
        return Icons.spa; // Spa/relaxation
      case 'facials':
        return Icons.face; // Face
      case 'dip_powder':
        return Icons.layers; // Layers
      default:
        return Icons.star; // Default
    }
  }
  
  
  /// Get color for capability
  Color _getCapabilityColor(String capabilityId) {
    switch (capabilityId) {
      case 'mani_pedi':
        return AppColors.primaryBlue;
      case 'gels':
        return AppColors.servicePurple;
      case 'acrylics':
        return AppColors.warningOrange;
      case 'waxing':
        return AppColors.successGreen;
      case 'facials':
        return AppColors.errorRed;
      case 'dip_powder':
        return const Color(0xFF795548); // Brown
      default:
        return AppColors.textSecondary;
    }
  }
}
