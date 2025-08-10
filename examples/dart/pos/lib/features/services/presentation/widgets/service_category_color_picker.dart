// lib/features/services/presentation/widgets/service_category_color_picker.dart
// Color picker widget for service category customization with predefined palette and custom color selection. Provides visual color selection interface with Material Design colors.
// Usage: ACTIVE - Used in service category creation and editing dialogs for visual customization

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A color picker widget for service categories with predefined color palette
class ServiceCategoryColorPicker extends StatelessWidget {
  final String categoryName;
  final Color currentColor;
  final Function(Color) onColorSelected;

  const ServiceCategoryColorPicker({
    super.key,
    required this.categoryName,
    required this.currentColor,
    required this.onColorSelected,
  });

  // Predefined color palette with 20 professional colors
  static const List<Color> colorPalette = [
    // Blues
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF3F51B5), // Indigo
    
    // Greens
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFF009688), // Teal
    Color(0xFF00796B), // Dark Teal
    
    // Purples & Pinks
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFFE91E63), // Pink
    Color(0xFFFF4081), // Pink Accent
    
    // Oranges & Yellows
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFFFFC107), // Amber
    Color(0xFFFFEB3B), // Yellow
    
    // Reds & Browns
    Color(0xFFF44336), // Red
    Color(0xFF795548), // Brown
    Color(0xFF9E9E9E), // Grey
    Color(0xFF607D8B), // Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  categoryName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Color grid
          Text(
            'Select Color',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: colorPalette.length,
            itemBuilder: (context, index) {
              final color = colorPalette[index];
              final isSelected = color.value == currentColor.value;
              
              return InkWell(
                onTap: () => onColorSelected(color),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                  ),
                  child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}