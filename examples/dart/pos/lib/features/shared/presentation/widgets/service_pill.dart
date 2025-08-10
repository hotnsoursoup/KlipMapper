// lib/features/shared/presentation/widgets/service_pill.dart
// Service pill widget displaying service information in compact, styled container format. Shows service name, duration, and price with customizable theming and interactive states.
// Usage: ACTIVE - Core UI component used across tickets, appointments, and service selection for service display

import 'package:flutter/material.dart';
import '../../../../core/config/service_categories.dart';
import '../../../../core/services/lookup_service.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A pill-shaped widget for displaying service names with consistent color coding and sizing options.
/// 
/// Features:
/// * Dynamic color coding based on service categories
/// * Three size variants: regular, small, and extra small
/// * Lookup service integration for category colors
/// * Backward compatibility with int/String category IDs
/// * Consistent styling across the application
/// * Performance-optimized category lookups
/// * Fallback colors for undefined categories
/// 
/// Usage:
/// ```dart
/// ServicePill(
///   serviceName: 'Haircut',
///   categoryId: 1,
///   isSmall: false,  // Regular size
/// )
/// 
/// ServicePill(
///   serviceName: 'Manicure',
///   categoryId: '2',
///   isExtraSmall: true,  // Smallest size for compact layouts
/// )
/// ```
class ServicePill extends StatelessWidget {
  final String serviceName;
  final dynamic categoryId;  // Can be int or String for backward compatibility
  final bool isSmall;
  final bool isExtraSmall;

  const ServicePill({
    super.key,
    required this.serviceName,
    this.categoryId,
    this.isSmall = false,
    this.isExtraSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get the actual category color from the lookup service
    Color color;
    
    if (categoryId != null) {
      // Get the color directly from the lookup service (returns Color, not hex string)
      color = LookupService.instance.getCategoryColor(categoryId.toString());
    } else {
      // No categoryId, try to guess from service name
      final guessedKey = _guessCategoryFromName(serviceName);
      color = ServiceCategories.getCategoryColor(guessedKey);
    }
    
    // Create better contrast by using a darker version of the color for text
    final textColor = _getDarkerColor(color);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isExtraSmall ? 6 : (isSmall ? 8 : 12),
        vertical: isExtraSmall ? 1 : (isSmall ? 2 : 4),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(isExtraSmall ? 10 : 14),
      ),
      child: Text(
        serviceName,
        style: (isExtraSmall ? AppTextStyles.labelSmall : (isSmall ? AppTextStyles.labelMedium : AppTextStyles.servicePill))
            .copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: isExtraSmall ? 12 : (isSmall ? 14 : 16),
        ),
      ),
    );
  }

  // Get default color based on category ID
  Color _getDefaultColor(dynamic categoryId) {
    String categoryKey;
    
    if (categoryId is int) {
      // Map integer category IDs to string keys
      switch (categoryId) {
        case 1:
          categoryKey = 'nails';
          break;
        case 2:
          categoryKey = 'gel';
          break;
        case 3:
          categoryKey = 'acrylic';
          break;
        case 4:
          categoryKey = 'waxing';
          break;
        case 5:
          categoryKey = 'facials';
          break;
        case 6:
          categoryKey = 'sns';
          break;
        default:
          categoryKey = 'other';
      }
    } else if (categoryId is String) {
      // First try to parse as integer if it's a numeric string
      final intId = int.tryParse(categoryId);
      if (intId != null) {
        return _getDefaultColor(intId);
      } else {
        // Handle string category IDs
        categoryKey = categoryId.toLowerCase();
      }
    } else {
      categoryKey = 'other';
    }
    
    return ServiceCategories.getCategoryColor(categoryKey);
  }
  
  // Simple heuristic to guess category from service name
  // This is a fallback when category is not explicitly provided
  String _guessCategoryFromName(String name) {
    final lowerName = name.toLowerCase();
    
    // Map service names to the correct category IDs
    if (lowerName.contains('gel')) {
      return 'gel';
    } else if (lowerName.contains('acrylic')) {
      return 'acrylic';
    } else if (lowerName.contains('sns') || lowerName.contains('dip')) {
      return 'sns';
    } else if (lowerName.contains('wax')) {
      return 'waxing';
    } else if (lowerName.contains('facial')) {
      return 'facials';
    } else if (lowerName.contains('massage')) {
      return 'massage';
    } else if (lowerName.contains('hair')) {
      return 'hair';
    } else if (lowerName.contains('manicure') || lowerName.contains('pedicure') || 
               lowerName.contains('mani') || lowerName.contains('pedi')) {
      return 'nails';
    }
    
    return 'other';
  }
  
  /// Creates a darker version of the color for better text contrast
  Color _getDarkerColor(Color color) {
    // Convert to HSL to adjust lightness
    final hsl = HSLColor.fromColor(color);
    
    // Make the color darker for better contrast
    // For light colors (high lightness), darken significantly
    // For already dark colors, darken less
    final targetLightness = hsl.lightness > 0.7 
        ? (hsl.lightness * 0.4).clamp(0.0, 1.0)  // Light colors: darken to 40% of original
        : (hsl.lightness * 0.7).clamp(0.0, 1.0); // Dark colors: darken to 70% of original
        
    return hsl.withLightness(targetLightness).toColor();
  }
}
