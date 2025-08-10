// lib/features/shared/presentation/widgets/service_category_icon.dart
// Service category icon widget displaying customizable icons with theming support. Renders category icons with consistent styling and optional color customization.
// Usage: ACTIVE - Reusable icon component used throughout UI for service category visual identification

import 'package:flutter/material.dart';
import '../../../../core/config/service_categories.dart';

/// A compact icon widget to represent service categories
/// Uses minimal space while maintaining visual distinction
class ServiceCategoryIcon extends StatelessWidget {
  final dynamic categoryId;  // Can be int or String for backward compatibility
  final String? serviceName; // For tooltip display and fallback category detection
  final double size;
  final bool showTooltip;

  const ServiceCategoryIcon({
    super.key,
    this.categoryId,
    this.serviceName,
    this.size = 28,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine category key for color and icon lookup
    String categoryKey;
    
    if (categoryId == null && serviceName != null) {
      // Guess from service name if no categoryId provided
      categoryKey = _guessCategoryFromName(serviceName!);
    } else if (categoryId is int) {
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
      // Handle string category IDs (for backward compatibility)
      switch (categoryId) {
        case 'Nails':
          categoryKey = 'nails';
          break;
        case 'Gel':
          categoryKey = 'gel';
          break;
        case 'Acrylic':
          categoryKey = 'acrylic';
          break;
        case 'Waxing':
          categoryKey = 'waxing';
          break;
        case 'Facials':
          categoryKey = 'facials';
          break;
        case 'SNS/Dip':
          categoryKey = 'sns';
          break;
        case 'Massage':
          categoryKey = 'massage';
          break;
        case 'Hair':
          categoryKey = 'hair';
          break;
        default:
          categoryKey = categoryId.toString().toLowerCase();
      }
    } else {
      categoryKey = 'other';
    }
    
    // Get the category configuration which includes color and icon
    final categoryConfig = ServiceCategories.getCategory(categoryKey);
    final color = categoryConfig.color;
    final iconData = categoryConfig.icon ?? Icons.star; // Fallback to star if no icon
    
    // Use actual service name for tooltip, fallback to category display name
    final tooltipMessage = serviceName ?? categoryConfig.displayName;

    final Widget iconWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(
        iconData,
        size: size * 0.6,
        color: color,
      ),
    );

    if (showTooltip) {
      return Tooltip(
        message: tooltipMessage,
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  // Simple heuristic to guess category from service name
  String _guessCategoryFromName(String name) {
    final lowerName = name.toLowerCase();
    
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
}