// lib/features/settings/presentation/widgets/sections/store_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/setting_model.dart';
import 'settings_coming_soon.dart';
import 'store_hours_tile.dart';

class StoreSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  const StoreSection({super.key, required this.settings, required this.onUpdate});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StoreHoursTile(
        summary: _str('store_hours_configuration', '').isEmpty
            ? 'Mon-Fri: 9:00 AM - 6:00 PM'
            : 'Custom hours configured',
        onSaveJson: (json) => onUpdate('store_hours_configuration', json),
      ),
      const Divider(height: 1),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text('Online Booking', style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: const Text('Allow customers to book online'),
        trailing: Switch(
          value: _bool('store_online_booking', false),
          onChanged: (v) => onUpdate('store_online_booking', v),
          thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
        ),
      ),
      const Divider(height: 1),
      ComingSoonTile(
        title: 'Store Location',
        subtitle: 'Switch between multiple locations',
        currentValue: _str('store_location', 'Main Location'),
      ),
    ]);
  }
  String _str(String k, String d) => settings[k]?.value ?? d;
  bool _bool(String k, bool d) {
    final s = settings[k];
    return s == null ? d : (s.value == 'true' || s.value == '1');
  }
}
