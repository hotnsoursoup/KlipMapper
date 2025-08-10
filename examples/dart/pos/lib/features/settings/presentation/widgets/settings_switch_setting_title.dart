// lib/features/settings/presentation/widgets/tiles/switch_setting_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SwitchSettingTile extends StatelessWidget {
  final String title; final String subtitle; final bool value;
  final ValueChanged<bool> onChanged;
  const SwitchSettingTile({super.key, required this.title, required this.subtitle,
    required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary, fontSize: 13)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
      ),
    );
  }
}
