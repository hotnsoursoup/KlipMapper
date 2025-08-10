// lib/features/appointments/data/models/calendar_theme.dart
// Calendar theme and color management with technician color assignment and responsive design.
// Includes status colors, styling decorations, and layout dimensions for calendar components.
// Usage: ACTIVE - Calendar UI theming, technician color coding, and responsive calendar layouts

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Theme and color management for the calendar
class CalendarTheme {
  /// Predefined colors for technicians (similar to the reference design)
  static const List<Color> technicianColors = [
    Color(0xFF81C784), // Light Green (like Olivia in reference)
    Color(0xFF64B5F6), // Light Blue (like Sophia in reference)  
    Color(0xFFF48FB1), // Light Pink (like Hana in reference)
    Color(0xFFFFB74D), // Light Orange (like Mika in reference)
    Color(0xFFAB47BC), // Purple
    Color(0xFF4DB6AC), // Teal
    Color(0xFFFF8A65), // Deep Orange
    Color(0xFF9575CD), // Medium Purple
    Color(0xFF4FC3F7), // Light Blue
    Color(0xFFA5D6A7), // Light Green
    Color(0xFFFFCC02), // Amber
    Color(0xFFEF5350), // Red
  ];

  /// Get a consistent color for a technician based on their ID
  static Color getTechnicianColor(String technicianId) {
    // Use hash of technician ID to get consistent color
    final hash = technicianId.hashCode.abs();
    final colorIndex = hash % technicianColors.length;
    return technicianColors[colorIndex];
  }

  /// Get a lighter version of the technician color for backgrounds
  static Color getTechnicianColorLight(String technicianId) {
    final baseColor = getTechnicianColor(technicianId);
    return baseColor.withValues(alpha: 0.2);
  }

  /// Get a darker version of the technician color for borders
  static Color getTechnicianColorDark(String technicianId) {
    final baseColor = getTechnicianColor(technicianId);
    return Color.fromRGBO(
      ((baseColor.r * 255.0) * 0.8).round(),
      ((baseColor.g * 255.0) * 0.8).round(),
      ((baseColor.b * 255.0) * 0.8).round(),
      1.0,
    );
  }

  /// Calendar grid colors
  static const Color gridLineColor = Color(0xFFE0E0E0);
  static const Color currentTimeLineColor = Color(0xFFFF5722);
  static const Color weekendBackgroundColor = Color(0xFFFAFAFA);
  static const Color todayBackgroundColor = Color(0xFFF3E5F5);
  static const Color selectedDayColor = AppColors.primaryBlue;

  /// Time slot colors
  static const Color availableSlotColor = Color(0xFFF5F5F5);
  static const Color bookedSlotColor = Color(0xFFE3F2FD);
  static const Color blockedSlotColor = Color(0xFFFFEBEE);
  static const Color breakSlotColor = Color(0xFFFFF3E0);

  /// Appointment status colors (matching CalendarAppointment)
  static const Map<String, Color> statusColors = {
    'scheduled': Colors.blue,
    'confirmed': Colors.green,
    'checkedIn': Colors.orange,
    'inProgress': Colors.purple,
    'completed': Color(0xFF2E7D32), // Dark green
    'cancelled': Colors.red,
    'noShow': Color(0xFFD32F2F), // Dark red
    'rescheduled': Colors.amber,
  };

  /// Text colors for different backgrounds
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Standard dimensions for calendar components
  static const double headerHeight = 60.0;
  static const double timeColumnWidth = 80.0;
  static const double technicianHeaderHeight = 80.0;
  static const double hourRowHeight = 60.0;
  static const double appointmentMinHeight = 40.0;
  static const double appointmentPadding = 0.0;
  static const double gridLineWidth = 1.0;
  static const double currentTimeLineWidth = 2.0;

  /// Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  /// Get minimum column width based on screen size
  static double getMinColumnWidth(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return 120.0; // Narrow columns on mobile
    } else if (screenWidth < tabletBreakpoint) {
      return 160.0; // Medium columns on tablet
    } else {
      return 200.0; // Wide columns on desktop
    }
  }

  /// Get maximum number of technician columns that fit on screen
  static int getMaxTechnicianColumns(double screenWidth) {
    final availableWidth = screenWidth - timeColumnWidth;
    final minColumnWidth = getMinColumnWidth(screenWidth);
    return (availableWidth / minColumnWidth).floor();
  }

  /// Appointment block styling
  static BoxDecoration getAppointmentDecoration({
    required Color color,
    required bool isSelected,
    required bool isPast,
    bool hasConflict = false,
  }) {
    return BoxDecoration(
      color: isPast ? color.withValues(alpha: 0.6) : color,
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(
        color: isSelected 
            ? selectedDayColor 
            : hasConflict 
                ? Colors.red 
                : color.withValues(alpha: 0.8),
        width: isSelected ? 2.0 : 1.0,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: selectedDayColor.withValues(alpha: 0.3),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2.0,
                offset: const Offset(0, 1),
              ),
            ],
    );
  }

  /// Time slot styling
  static BoxDecoration getTimeSlotDecoration({
    required bool isAvailable,
    required bool isCurrentTime,
    required bool isSelected,
    String? reason,
  }) {
    Color backgroundColor = availableSlotColor;
    Color borderColor = gridLineColor;

    if (!isAvailable) {
      switch (reason) {
        case 'Break':
          backgroundColor = breakSlotColor;
          break;
        case 'Lunch':
          backgroundColor = breakSlotColor;
          break;
        case 'Blocked':
          backgroundColor = blockedSlotColor;
          break;
        default:
          backgroundColor = bookedSlotColor;
      }
    }

    if (isCurrentTime) {
      borderColor = currentTimeLineColor;
    } else if (isSelected) {
      borderColor = selectedDayColor;
    }

    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: isCurrentTime ? currentTimeLineWidth : gridLineWidth,
      ),
    );
  }

  /// Text styles for calendar components
  static const TextStyle timeColumnTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle technicianHeaderTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle appointmentTitleStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle appointmentSubtitleStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  static const TextStyle appointmentTimeStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  /// Animation durations
  static const Duration appointmentAnimationDuration = Duration(milliseconds: 200);
  static const Duration viewChangeAnimationDuration = Duration(milliseconds: 300);
  static const Duration scrollAnimationDuration = Duration(milliseconds: 250);
}