// lib/core/theme/app_colors.dart
// Defines the complete color palette for the POS application including primary, secondary, status, and UI element colors. Centralizes all color constants used throughout the app for consistent theming and branding.
// Usage: ACTIVE - Referenced by theme files and UI components throughout the entire application

import 'package:flutter/material.dart';

/// Color palette for Luxe Nails POS
/// Based on the dashboard.png design
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color darkNavy = Color(0xFF1F2937); // Dark header background

  // Status colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  // Aliases for consistency
  static const Color primary = primaryBlue;
  static const Color secondary = servicePurple;
  static const Color success = successGreen;
  static const Color warning = warningOrange;
  static const Color error = errorRed;

  // UI element colors
  static const Color servicePurple = Color(0xFF9333EA); // Used for group service badges
  static const Color serviceOrange = Color(0xFFFF8C42); // Used for service badges
  static const Color serviceTeal = Color(0xFF11B8AB); // Used for service badges
  static const Color serviceBlue = Color(0xFF4A90E2); // Used for service badges
  static const Color serviceYellow = Color(0xFFFFBC42); // Used for service badges
  static const Color servicePink = Color(0xFFEE5A6F); // Used for service badges

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnDark = Colors.white;

  // Background colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF3F4F6);

  // Border colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Queue card border colors (from design)
  static const Color queueRedBorder = Color(0xFFEF4444); // Long wait
  static const Color queueOrangeBorder = Color(0xFFF97316); // Medium wait
  static const Color queueBlueBorder = Color(0xFF3B82F6); // Appointment

  // Technician avatar colors
  static const Color techGreen = Color(0xFF10B981);
  static const Color techPurple = Color(0xFF9333EA);
  static const Color techBlue = Color(0xFF3B82F6);

  // Helper methods
  static Color getQueueBorderColor(String status, int waitMinutes) {
    if (status.toLowerCase() == 'appointment') {
      return queueBlueBorder;
    } else if (waitMinutes > 40) {
      return queueRedBorder;
    } else if (waitMinutes > 20) {
      return queueOrangeBorder;
    }
    return border;
  }
}
