// lib/features/settings/presentation/widgets/background_selector.dart
// Background theme selector widget with Riverpod state management and preview generation. Features background theme selection, live preview generation, and settings persistence for UI customization.
// Usage: ACTIVE - Used in settings screen for background theme configuration

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../../../core/services/background_preview_generator.dart';
import '../../../../utils/error_logger.dart';

/// Widget for selecting dashboard background
class BackgroundSelector extends ConsumerWidget {
  
  const BackgroundSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardSettingsAsync = ref.watch(dashboardSettingsNotifierProvider);
    final backgroundOptions = ref.watch(availableBackgroundOptionsProvider);

    return dashboardSettingsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) {
        ErrorLogger.logError('Failed to load dashboard settings', error, stack);
        return Center(
          child: Text(
            'Failed to load settings: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
      },
      data: (dashboardSettings) {
        if (backgroundOptions.isEmpty) {
          return const Center(
            child: Text('No background options available'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Background',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Choose a background for your dashboard',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildBackgroundGrid(ref, backgroundOptions, dashboardSettings.dashboardBackground),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundGrid(WidgetRef ref, Map<String, dynamic> options, String currentBackground) {
    const itemWidth = 120.0;
    const itemHeight = 90.0;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.entries.map((entry) {
        final key = entry.key;
        final option = entry.value;
        final isSelected = currentBackground == key;
        
        return GestureDetector(
          onTap: () => _selectBackground(ref, key),
          child: Container(
            width: itemWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(ref.context).colorScheme.primary
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(ref.context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(7),
                  ),
                  child: BackgroundPreviewGenerator.buildPreviewWidget(
                    key,
                    width: itemWidth - 2,
                    height: itemHeight - 25,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(ref.context).colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(7),
                    ),
                  ),
                  child: Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(ref.context).colorScheme.primary
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _selectBackground(WidgetRef ref, String backgroundKey) async {
    try {
      final dashboardNotifier = ref.read(dashboardSettingsNotifierProvider.notifier);
      await dashboardNotifier.setDashboardBackground(backgroundKey);
      ErrorLogger.logInfo('Background selected: $backgroundKey');
    } catch (e) {
      ErrorLogger.logError('Failed to select background: $backgroundKey', e);
    }
  }
}