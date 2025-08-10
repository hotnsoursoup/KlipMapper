// lib/features/settings/presentation/widgets/sections/general_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/setting_model.dart';
import 'settings_coming_soon_dropdown_tile.dart';
import 'settings_coming_soon_tile.dart';

class GeneralSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  const GeneralSection({super.key, required this.settings, required this.onUpdate});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ComingSoonDropdownTile(
        title: 'Theme', subtitle: 'Choose the app appearance',
        value: _s('general_theme', 'Light'),
        options: const ['Light','Dark','System'],
      ),
      const Divider(height: 1),
      ComingSoonSwitchTile(
        title: 'Sound Effects', subtitle: 'Play UI sounds',
        value: _b('general_sound_effects', true),
      ),
      const Divider(height: 1),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text('Animations', style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: const Text('Enable smooth transitions'),
        trailing: Switch(
          value: _b('general_animations', true),
          onChanged: (v) => onUpdate('general_animations', v),
          thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
        ),
      ),
      const Divider(height: 1),
      ComingSoonDropdownTile(
        title: 'Language', subtitle: 'Preferred language',
        value: _s('general_language', 'English'),
        options: const ['English','Spanish','French'],
      ),
    ]);
  }
  String _s(String k, String d) => settings[k]?.value ?? d;
  bool _b(String k, bool d) {
    final s = settings[k];
    return s == null ? d : (s.value == 'true' || s.value == '1');
  }
}
