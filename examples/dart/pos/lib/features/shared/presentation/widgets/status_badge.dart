// lib/features/shared/presentation/widgets/status_badge.dart
// Status badge widget displaying colored status indicators with text labels. Provides consistent status visualization across tickets, appointments, and other entities with customizable colors and styling.
// Usage: ACTIVE - Reusable status indicator used throughout UI for displaying entity states and statuses

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A flexible status badge widget for displaying various status types with consistent styling.
/// 
/// Features:
/// * Predefined factory constructors for common statuses (Walk-in, Appointment, etc.)
/// * Customizable background colors and icons
/// * Optional icon display control
/// * Consistent text styling and padding
/// * Factory methods for type safety and consistency
/// * Theme-aware colors from app color palette
/// 
/// Usage:
/// ```dart
/// // Using factory constructors
/// StatusBadge.walkIn()
/// StatusBadge.appointment() 
/// StatusBadge.inService()
/// StatusBadge.completed()
/// 
/// // Custom status badge
/// StatusBadge(
///   text: 'Custom Status',
///   backgroundColor: AppColors.primaryBlue,
///   icon: Icons.star,
/// )
/// ```
class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final IconData? icon;
  final bool showIcon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.icon,
    this.showIcon = true,
  });

  factory StatusBadge.walkIn() {
    return const StatusBadge(
      text: 'Walk-in',
      backgroundColor: AppColors.textSecondary,
      icon: Icons.directions_walk,
    );
  }

  factory StatusBadge.appointment() {
    return const StatusBadge(
      text: 'Appointment',
      backgroundColor: AppColors.primaryBlue,
      icon: Icons.event,
    );
  }

  factory StatusBadge.groupService() {
    return const StatusBadge(
      text: 'GROUP SERVICE',
      backgroundColor: AppColors.servicePurple,
      showIcon: false,
    );
  }

  factory StatusBadge.assigned() {
    return const StatusBadge(
      text: 'ASSIGNED',
      backgroundColor: AppColors.warningOrange,
      showIcon: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.statusBadge,
          ),
        ],
      ),
    );
  }
}
