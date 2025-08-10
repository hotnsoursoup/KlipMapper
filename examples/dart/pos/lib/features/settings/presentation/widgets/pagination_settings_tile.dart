// lib/features/settings/presentation/widgets/pagination_settings_tile.dart
// Pagination settings tile with performance warning dialog for large values
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class PaginationSettingTile extends StatelessWidget {
  final int itemsPerPage; 
  final ValueChanged<int> onChanged;
  
  const PaginationSettingTile({
    super.key, 
    required this.itemsPerPage,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        'Default Items Per Page', 
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        )
      ),
      subtitle: Text(
        'Number of items to display per page in lists and tables',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary, 
          fontSize: 13,
        )
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<int>(
          value: itemsPerPage, 
          underline: const SizedBox.shrink(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          items: const [10, 25, 50, 100, 200, 500]
              .map((i) => DropdownMenuItem(
                value: i, 
                child: Text(
                  '$i',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                )
              ))
              .toList(),
          onChanged: (v) => _onPaginationChanged(context, v),
        ),
      ),
    );
  }

  Future<void> _onPaginationChanged(BuildContext context, int? newValue) async {
    if (newValue == null) return;
    
    if (newValue >= 100) {
      final confirmed = await _showPerformanceWarningDialog(context, newValue);
      if (confirmed) {
        onChanged(newValue);
      }
    } else {
      onChanged(newValue);
    }
  }

  Future<bool> _showPerformanceWarningDialog(BuildContext context, int itemsPerPage) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.warningOrange, size: 24),
            const SizedBox(width: 8),
            const Text('Performance Warning'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to set the default page size to $itemsPerPage items.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Large page sizes may affect performance, especially on slower devices or with large datasets.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to continue?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    ) ?? false;
  }
}
