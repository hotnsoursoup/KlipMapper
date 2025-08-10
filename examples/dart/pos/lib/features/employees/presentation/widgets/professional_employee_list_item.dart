// lib/features/employees/presentation/widgets/professional_employee_list_item.dart
// Professional employee list item widget with enhanced security and privacy features.
// Displays employee information with sensitive data masking, role-based styling, and streamlined action buttons.
// Usage: ACTIVE - Used in employee management screens requiring privacy-focused employee display

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/employee_model.dart';

/// Professional employee list item with masked sensitive data and improved design
class ProfessionalEmployeeListItem extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;
  final bool showFullPhone;

  const ProfessionalEmployeeListItem({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
    this.showFullPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee.status == 'active';
    final fullName = employee.displayNameOrFullName;
    final initials = _getInitials(fullName);
    final roleColor = _getRoleColor(employee.role);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
            ? AppColors.border.withValues(alpha: 0.2)
            : AppColors.border.withValues(alpha: 0.1),
          width: isActive ? 1 : 0.5,
        ),
        boxShadow: [
          if (isActive) BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? onEdit : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Professional avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isActive ? roleColor.withValues(alpha: 0.1) : AppColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? roleColor.withValues(alpha: 0.2) : AppColors.textSecondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isActive ? roleColor : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Employee information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fullName,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildStatusBadge(isActive),
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Role and contact info
                      Row(
                        children: [
                          // Role badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: roleColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              _formatRole(employee.role),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: roleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Contact info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.email,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatPhone(employee.phone),
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'monospace', // Better for phone display
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Additional info row
                      Row(
                        children: [
                          if (employee.isClockedIn) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.successGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Clocked In',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          
                          if (employee.commissionRate > 0) ...[
                            Text(
                              'Commission: ${(employee.commissionRate * 100).toStringAsFixed(1)}%',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          
                          Text(
                            'ID: ${employee.id}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Action buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Toggle status button
                        InkWell(
                          onTap: onToggleActive,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isActive 
                                ? AppColors.warningOrange.withValues(alpha: 0.1)
                                : AppColors.successGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              isActive ? Icons.pause : Icons.play_arrow,
                              size: 16,
                              color: isActive ? AppColors.warningOrange : AppColors.successGreen,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Delete button
                        InkWell(
                          onTap: onDelete,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.errorRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: AppColors.errorRed,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
          ? AppColors.successGreen.withValues(alpha: 0.1)
          : AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.labelSmall.copyWith(
          color: isActive ? AppColors.successGreen : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatPhone(String phone) {
    if (!showFullPhone && phone.length >= 4) {
      // Show only last 4 digits: ***-***-1234
      final lastFour = phone.substring(phone.length - 4);
      return '***-***-$lastFour';
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
      default:
        return AppColors.textSecondary;
    }
  }
}