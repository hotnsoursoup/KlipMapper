// lib/core/utils/text_measurement_utils.dart
// Utility for measuring text dimensions and calculating dynamic dropdown widths based on content. Provides consistent text measurement across UI components for responsive layouts.
// Usage: ACTIVE - Used in dashboard filters, dropdown widgets, and responsive UI components for dynamic sizing
import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Utility class for measuring text width and creating dynamic dropdowns
class TextMeasurementUtils {
  /// Calculates the pixel width of a given text with the specified style
  static double calculateTextWidth(String text, [TextStyle? style]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style ?? AppTextStyles.bodyMedium,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  /// Calculates dynamic width for dropdown based on the longest item
  static double calculateDropdownWidth(
    List<String> items, {
    TextStyle? textStyle,
    double buffer = 60, // Default buffer for icon, padding, and dropdown arrow
    double minWidth = 120,
    double maxWidth = 300,
  }) {
    if (items.isEmpty) return minWidth;
    
    final longestItem = items.reduce((a, b) => a.length > b.length ? a : b);
    final textWidth = calculateTextWidth(longestItem, textStyle);
    final dynamicWidth = textWidth + buffer;
    
    return dynamicWidth.clamp(minWidth, maxWidth);
  }

  /// Creates a SizedBox with dynamic width for dropdown filters
  static Widget createDynamicDropdown({
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
    required Widget child,
    TextStyle? textStyle,
    double buffer = 60,
    double minWidth = 120,
    double maxWidth = 300,
  }) {
    final dynamicWidth = calculateDropdownWidth(
      items,
      textStyle: textStyle,
      buffer: buffer,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );

    return SizedBox(
      width: dynamicWidth,
      child: child,
    );
  }
}