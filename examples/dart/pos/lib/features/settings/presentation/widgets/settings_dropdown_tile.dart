// lib/features/settings/presentation/widgets/tiles/dropdown_setting_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DropdownSettingTile extends StatelessWidget {
  final String title; final String subtitle; final String value;
  final List<String> options; final ValueChanged<String?> onChanged;
  const DropdownSettingTile({super.key, required this.title, required this.subtitle,
    required this.value, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final safe = options.contains(value) ? value : options.first;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary, fontSize: 13)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: safe, underline: const SizedBox.shrink(),
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
          onChanged: onChanged,
          items: options.map((o) => DropdownMenuItem(
            value: o, child: Text(o))).toList(),
        ),
      ),
    );
  }
}
