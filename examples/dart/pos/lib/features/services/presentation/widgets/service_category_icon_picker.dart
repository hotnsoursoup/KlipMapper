// lib/features/services/presentation/widgets/service_category_icon_picker.dart
// Icon picker widget for service category customization with Material Icons selection grid. Provides visual icon selection interface for service category branding and identification.
// Usage: ACTIVE - Used in service category creation and editing for icon selection and visual customization

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// An icon picker widget for service categories with predefined icon options
class ServiceCategoryIconPicker extends StatelessWidget {
  final String categoryName;
  final IconData currentIcon;
  final Function(IconData) onIconSelected;

  const ServiceCategoryIconPicker({
    super.key,
    required this.categoryName,
    required this.currentIcon,
    required this.onIconSelected,
  });

  // Predefined icon palette with 50+ professional icons for service categories
  static const List<IconData> iconPalette = [
    // Beauty & Grooming
    Icons.face, // Face/Beauty
    Icons.face_retouching_natural, // Natural Beauty
    Icons.spa, // Spa/Wellness
    Icons.self_improvement, // Meditation/Wellness
    Icons.pan_tool, // Hand/Nails
    Icons.brush, // Brush/Makeup
    Icons.content_cut, // Scissors/Hair
    Icons.dry_cleaning, // Cleaning/Treatment
    
    // Tools & Equipment
    Icons.format_paint, // Paint/Polish
    Icons.straighten, // Tools
    Icons.colorize, // Color/Dye
    Icons.texture, // Texture/Pattern
    Icons.layers, // Layers/Multi-step
    Icons.healing, // Healing/Treatment
    Icons.auto_fix_high, // Magic/Enhancement
    Icons.flare, // Shine/Glow
    
    // Body & Health
    Icons.accessibility_new, // Full Body
    Icons.airline_seat_legroom_extra, // Legs
    Icons.back_hand, // Back of Hand
    Icons.front_hand, // Palm/Front Hand
    Icons.volunteer_activism, // Hands Together
    Icons.clean_hands, // Clean Hands
    Icons.sanitizer, // Sanitizer/Clean
    Icons.soap, // Soap/Cleansing
    
    // Materials & Products
    Icons.water_drop, // Liquid/Oil
    Icons.opacity, // Transparency/Gel
    Icons.bubble_chart, // Bubbles/Foam
    Icons.blur_on, // Blur/Soft
    Icons.lens_blur, // Soft Focus
    Icons.gradient, // Gradient/Blend
    Icons.palette, // Color Palette
    Icons.invert_colors, // Color Invert
    
    // Services & Activities
    Icons.schedule, // Time/Duration
    Icons.event, // Appointment
    Icons.favorite, // Favorite/Popular
    Icons.star, // Premium/Special
    Icons.diamond, // Luxury
    Icons.local_fire_department, // Hot/Warm
    Icons.ac_unit, // Cold/Cool
    Icons.wb_sunny, // Sun/UV
    
    // Categories & Types
    Icons.category, // Category
    Icons.dashboard, // All/Overview
    Icons.widgets, // Components/Parts
    Icons.extension, // Extensions
    Icons.auto_awesome, // Automatic/Magic
    Icons.psychology, // Mind/Relaxation
    Icons.emoji_emotions, // Emotions/Mood
    Icons.mood, // Happy/Satisfied
    
    // Miscellaneous
    Icons.more_horiz, // More/Other
    Icons.circle, // Simple Circle
    Icons.square, // Simple Square
    Icons.hexagon, // Hexagon Shape
    Icons.change_history, // Triangle
  ];

  // Map of suggested icons for common service categories
  static const Map<String, IconData> suggestedIcons = {
    'nails': Icons.pan_tool,
    'gel': Icons.opacity,
    'acrylic': Icons.format_paint,
    'waxing': Icons.spa,
    'facials': Icons.face,
    'sns': Icons.layers,
    'massage': Icons.self_improvement,
    'hair': Icons.content_cut,
    'makeup': Icons.brush,
    'lashes': Icons.remove_red_eye,
    'brows': Icons.remove_red_eye,
    'other': Icons.more_horiz,
  };

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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: Icon(
                  currentIcon,
                  size: 20,
                  color: AppColors.primaryBlue,
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
              // Suggested icon button
              if (suggestedIcons.containsKey(categoryName.toLowerCase()))
                TextButton.icon(
                  onPressed: () {
                    final suggested = suggestedIcons[categoryName.toLowerCase()]!;
                    onIconSelected(suggested);
                  },
                  icon: Icon(
                    suggestedIcons[categoryName.toLowerCase()],
                    size: 18,
                  ),
                  label: const Text('Use Suggested'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Icon grid
          Text(
            'Select Icon',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          
          // Scrollable icon grid
          Container(
            height: 300, // Fixed height for scrollable area
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: iconPalette.length,
              itemBuilder: (context, index) {
                final icon = iconPalette[index];
                final isSelected = icon == currentIcon;
                final isSuggested = suggestedIcons[categoryName.toLowerCase()] == icon;
                
                return InkWell(
                  onTap: () => onIconSelected(icon),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppColors.primaryBlue.withValues(alpha: 0.15)
                        : isSuggested
                          ? AppColors.successGreen.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                          ? AppColors.primaryBlue 
                          : isSuggested
                            ? AppColors.successGreen.withValues(alpha: 0.3)
                            : AppColors.border.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryBlue.withValues(alpha: 0.2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected 
                        ? AppColors.primaryBlue
                        : isSuggested
                          ? AppColors.successGreen
                          : AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Helper text
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.successGreen.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Suggested icon for this category',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}