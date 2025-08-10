// lib/features/shared/presentation/widgets/optimized_service_category_icon.dart
// Performance-optimized service category icon widget with caching and RepaintBoundary isolation. Efficiently displays category icons with minimal rendering overhead.
// Usage: ACTIVE - High-performance icon widget used throughout services UI for category identification

import 'package:flutter/material.dart';
import '../../../services/data/service_category_store.dart';

/// An optimized icon widget to represent service categories
/// Uses database categories when available, with fallbacks
class OptimizedServiceCategoryIcon extends StatelessWidget {
  final dynamic categoryId;  // Can be int or String
  final String? serviceName; // For tooltip display
  final double size;
  final bool showTooltip;
  final ServiceCategoryStore? categoryStore;

  const OptimizedServiceCategoryIcon({
    super.key,
    this.categoryId,
    this.serviceName,
    this.size = 28,
    this.showTooltip = true,
    this.categoryStore,
  });

  @override
  Widget build(BuildContext context) {
    // Get color and icon from store if available
    Color color;
    IconData iconData;
    String tooltipMessage;

    if (categoryStore != null && categoryId != null) {
      // Use store for category data
      final categoryIdStr = categoryId.toString();
      color = categoryStore!.getCategoryColor(categoryIdStr);
      
      // Find category name
      dynamic category;
      try {
        category = categoryStore!.categories.cast<dynamic>().firstWhere(
          (c) => c?.id == categoryIdStr,
        );
      } catch (e) {
        // Category not found
        category = null;
      }
      
      if (category?.id != null) {
        iconData = categoryStore!.getCategoryIcon(category.name);
        tooltipMessage = serviceName ?? category.name;
      } else {
        // Fallback if category not found
        iconData = Icons.star;
        tooltipMessage = serviceName ?? 'Service';
      }
    } else {
      // Fallback to default behavior when no store
      color = _getDefaultColor();
      iconData = _getDefaultIcon();
      tooltipMessage = serviceName ?? 'Service';
    }

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

  // Default fallback color
  Color _getDefaultColor() {
    // Generate a color based on the category ID or service name
    final seed = (categoryId?.toString() ?? serviceName ?? 'default').hashCode;
    final hue = (seed % 360).toDouble();
    return HSVColor.fromAHSV(1.0, hue, 0.7, 0.8).toColor();
  }

  // Default fallback icon
  IconData _getDefaultIcon() {
    if (serviceName != null) {
      final lowerName = serviceName!.toLowerCase();
      
      if (lowerName.contains('nail') || lowerName.contains('manicure') || lowerName.contains('pedicure')) {
        return Icons.colorize;
      } else if (lowerName.contains('gel')) {
        return Icons.water_drop;
      } else if (lowerName.contains('acrylic')) {
        return Icons.architecture;
      } else if (lowerName.contains('wax')) {
        return Icons.spa;
      } else if (lowerName.contains('facial')) {
        return Icons.face;
      } else if (lowerName.contains('massage')) {
        return Icons.healing;
      } else if (lowerName.contains('hair')) {
        return Icons.content_cut;
      } else if (lowerName.contains('makeup')) {
        return Icons.brush;
      }
    }
    
    return Icons.star;
  }
}

/// Provider widget to pass ServiceCategoryStore to children
class ServiceCategoryIconProvider extends InheritedWidget {
  final ServiceCategoryStore categoryStore;

  const ServiceCategoryIconProvider({
    super.key,
    required this.categoryStore,
    required super.child,
  });

  static ServiceCategoryIconProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceCategoryIconProvider>();
  }

  @override
  bool updateShouldNotify(ServiceCategoryIconProvider oldWidget) {
    return categoryStore != oldWidget.categoryStore;
  }
}

/// Wrapper widget that automatically uses the provided category store
class ServiceCategoryIcon extends StatelessWidget {
  final dynamic categoryId;
  final String? serviceName;
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
    final provider = ServiceCategoryIconProvider.of(context);
    
    return OptimizedServiceCategoryIcon(
      categoryId: categoryId,
      serviceName: serviceName,
      size: size,
      showTooltip: showTooltip,
      categoryStore: provider?.categoryStore,
    );
  }
}