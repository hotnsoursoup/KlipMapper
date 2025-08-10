// lib/features/settings/presentation/widgets/tiles/coming_soon_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ComingSoonTile extends StatelessWidget {
  final String title; final String subtitle; final String currentValue;
  const ComingSoonTile({super.key, required this.title, required this.subtitle,
    required this.currentValue});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(currentValue, style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Coming Soon', style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.warningOrange, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}
