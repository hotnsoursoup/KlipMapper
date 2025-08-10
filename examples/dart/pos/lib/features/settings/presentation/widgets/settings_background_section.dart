// lib/features/settings/presentation/widgets/settings_background_section.dart
// Complete background section with selector, preview, and opacity controls
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/setting_model.dart';

class BackgroundsSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  
  const BackgroundsSection({
    super.key, 
    required this.settings, 
    required this.onUpdate
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBackgroundSelectorTile(),
        const Divider(height: 1),
        _buildBackgroundOpacitySliderTile(),
        const Divider(height: 1),
        _buildContainerOpacitySliderTile(),
        const Divider(height: 1),
        _buildWidgetOpacitySliderTile(),
      ],
    );
  }

  String _getString(String key, String defaultValue) {
    return settings[key]?.value ?? defaultValue;
  }

  double _getDouble(String key, double defaultValue) {
    final value = settings[key]?.value;
    if (value == null) return defaultValue;
    return double.tryParse(value) ?? defaultValue;
  }

  Widget _buildBackgroundSelectorTile() {
    final selectedBackground = _getString('dashboard_background', 'none');
    final backgroundOptions = {
      'none': BackgroundOption('None', BackgroundType.none, null, null),
      'gradient_blue': BackgroundOption('Blue Gradient', BackgroundType.gradient, [0xFF4A90E2, 0xFF7BA7E7], null),
      'gradient_purple': BackgroundOption('Purple Gradient', BackgroundType.gradient, [0xFF8E44AD, 0xFFAB7EDB], null),
      'gradient_green': BackgroundOption('Green Gradient', BackgroundType.gradient, [0xFF2ECC71, 0xFF58D68D], null),
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      title: Text(
        'Dashboard Background',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Choose a background for the dashboard',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          // Background preview
          _buildBackgroundPreview(),
          const SizedBox(height: 12),
          // Background options dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedBackground,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onUpdate('dashboard_background', newValue);
                }
              },
              items: backgroundOptions.entries.map((entry) {
                final option = entry.value;
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      // Icon based on type
                      Icon(
                        option.type == BackgroundType.none
                            ? Icons.block
                            : option.type == BackgroundType.gradient
                                ? Icons.gradient
                                : Icons.image,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        option.name,
                        style: AppTextStyles.bodyMedium,
                      ),
                      if (option.type == BackgroundType.gradient && option.colors != null) ...[
                        const Spacer(),
                        // Show gradient preview
                        Container(
                          width: 60,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: option.colors!.map((c) => Color(c)).toList(),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPreview() {
    final backgroundKey = _getString('dashboard_background', 'none');
    final backgroundOpacity = _getDouble('dashboard_background_opacity', 1.0);
    final containerOpacity = _getDouble('dashboard_container_opacity', 1.0);
    final widgetOpacity = _getDouble('dashboard_widget_opacity', 1.0);
    
    if (backgroundKey == 'none') {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 32,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No Background',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            // Background layer
            if (backgroundKey.startsWith('gradient_'))
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getGradientColors(backgroundKey),
                  ),
                ),
              ),
            
            // Opacity overlay to show the effect
            Container(
              color: Colors.white.withValues(alpha: 1.0 - backgroundOpacity),
            ),
            
            // Sample containers to show translucency effect
            Positioned(
              left: 8,
              right: 8,
              top: 8,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: containerOpacity),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Container Preview',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
            
            // Sample widget cards
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA).withValues(alpha: widgetOpacity),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Widget 1',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA).withValues(alpha: widgetOpacity),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Widget 2',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String backgroundKey) {
    switch (backgroundKey) {
      case 'gradient_blue':
        return [const Color(0xFF4A90E2), const Color(0xFF7BA7E7)];
      case 'gradient_purple':
        return [const Color(0xFF8E44AD), const Color(0xFFAB7EDB)];
      case 'gradient_green':
        return [const Color(0xFF2ECC71), const Color(0xFF58D68D)];
      default:
        return [AppColors.primaryBlue, AppColors.primaryBlue.withValues(alpha: 0.5)];
    }
  }

  Widget _buildBackgroundOpacitySliderTile() {
    final backgroundKey = _getString('dashboard_background', 'none');
    final backgroundOpacity = _getDouble('dashboard_background_opacity', 1.0);
    
    // Only show opacity slider if a background is selected
    if (backgroundKey == 'none') {
      return const SizedBox.shrink();
    }
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      title: Text(
        'Background Opacity',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Adjust the transparency of the background',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: backgroundOpacity,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: '${(backgroundOpacity * 100).round()}%',
                  onChanged: (value) {
                    onUpdate('dashboard_background_opacity', value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(backgroundOpacity * 100).round()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainerOpacitySliderTile() {
    final backgroundKey = _getString('dashboard_background', 'none');
    final containerOpacity = _getDouble('dashboard_container_opacity', 1.0);
    
    // Only show if a background is selected
    if (backgroundKey == 'none') {
      return const SizedBox.shrink();
    }
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      title: Text(
        'Container Transparency',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Transparency of main dashboard containers',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: containerOpacity,
                  min: 0.3,
                  max: 1.0,
                  divisions: 7,
                  label: '${(containerOpacity * 100).round()}%',
                  onChanged: (value) {
                    onUpdate('dashboard_container_opacity', value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(containerOpacity * 100).round()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetOpacitySliderTile() {
    final backgroundKey = _getString('dashboard_background', 'none');
    final widgetOpacity = _getDouble('dashboard_widget_opacity', 1.0);
    
    // Only show if a background is selected
    if (backgroundKey == 'none') {
      return const SizedBox.shrink();
    }
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      title: Text(
        'Widget Transparency',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Transparency of cards and widgets inside containers',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: widgetOpacity,
                  min: 0.3,
                  max: 1.0,
                  divisions: 7,
                  label: '${(widgetOpacity * 100).round()}%',
                  onChanged: (value) {
                    onUpdate('dashboard_widget_opacity', value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(widgetOpacity * 100).round()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Background option models
enum BackgroundType { none, gradient, image }

class BackgroundOption {
  final String name;
  final BackgroundType type;
  final List<int>? colors; // For gradients
  final String? fileExtension; // For images
  
  const BackgroundOption(this.name, this.type, this.colors, this.fileExtension);
}
