// lib/features/employees/presentation/widgets/employee_list_item.dart
// Employee list item widget displaying comprehensive employee information with management actions.
// Shows avatar, personal details, capabilities, commission rates, and provides edit, activate/deactivate, and delete functionality.
// Usage: ACTIVE - Used in employees screen for displaying employee cards in a list layout

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/employee_model.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const EmployeeListItem({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee.status == 'active';
    final fullName = employee.displayNameOrFullName;
    final initials = _getInitials(fullName);
    final avatarColor = _getAvatarColor(fullName);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.border : AppColors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: AppTextStyles.headline3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Employee info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              fullName,
                              style: AppTextStyles.headline3,
                            ),
                            const SizedBox(width: 8),
                            if (!isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Inactive',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.badge_outlined,
                              employee.role,
                              AppColors.primaryBlue,
                            ),
                            if (employee.email.isNotEmpty) ...[
                              const SizedBox(width: 16),
                              _buildInfoChip(
                                Icons.email_outlined,
                                employee.email,
                                AppColors.textSecondary,
                              ),
                            ],
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              Icons.phone_outlined,
                              employee.phone,
                              AppColors.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Capabilities row
                        if (employee.capabilities.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: employee.capabilities.map((capability) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(capability.color.replaceFirst('#', '0xFF'))).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  capability.displayName,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Color(int.parse(capability.color.replaceFirst('#', '0xFF'))),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            if (employee.commissionRate > 0) ...[
                              _buildRateChip(
                                'Commission',
                                '${(employee.commissionRate * 100).toStringAsFixed(0)}%',
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onToggleActive,
                        icon: Icon(
                          isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          color: isActive ? AppColors.warningOrange : AppColors.successGreen,
                        ),
                        tooltip: isActive ? 'Deactivate' : 'Activate',
                      ),
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.primaryBlue,
                        ),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.errorRed,
                        ),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRateChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.successGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'E';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      AppColors.techGreen,
      AppColors.techPurple,
      AppColors.techBlue,
      const Color(0xFFFF9800), // Orange
      const Color(0xFFE91E63), // Pink
    ];
    final index = name.length % colors.length;
    return colors[index];
  }

}