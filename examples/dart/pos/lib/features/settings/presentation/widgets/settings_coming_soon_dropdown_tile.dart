// lib/features/settings/presentation/widgets/tiles/coming_soon_dropdown_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ComingSoonDropdownTile extends StatelessWidget {
  final String title; final String subtitle; final String value;
  final List<String> options;
  const ComingSoonDropdownTile({super.key, required this.title,
    required this.subtitle, required this.value, required this.options});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Coming Soon', style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.warningOrange, fontWeight: FontWeight.w600,
              fontSize: 10)),
          ),
        ]),
      ),
    );
  }
}
