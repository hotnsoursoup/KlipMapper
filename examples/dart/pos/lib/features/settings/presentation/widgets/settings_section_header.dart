import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionHeader({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: AppColors.primaryBlue, size: 22),
        const SizedBox(width: 10),
        Text(title,
          style: AppTextStyles.headline2.copyWith(
            fontSize: 18, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
