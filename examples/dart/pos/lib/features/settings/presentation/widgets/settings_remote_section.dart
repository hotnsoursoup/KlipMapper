// lib/features/settings/presentation/widgets/sections/remote_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class RemoteSection extends StatelessWidget {
  const RemoteSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.screen_share, color: Colors.grey),
            const SizedBox(width: 8),
            Text('Remote View',
              style: AppTextStyles.headline3.copyWith(color: Colors.grey)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('COMING SOON',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.warningOrange,
                  fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 8),
          Text('Allow remote viewing for support and monitoring',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
        ]),
      ),
    );
  }
}
