import 'package:flutter/material.dart';

import '../../../shared/data/models/setting_model.dart';
import 'settings_service_categories_display.dart';
import 'settings_switch_setting_title.dart';

class DashboardSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  const DashboardSection({super.key, required this.settings,
    required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SwitchSettingTile(
        title: 'Show Customer Phone',
        subtitle: 'Display phone numbers on tickets',
        value: _bool('dashboard_show_customer_phone', true),
        onChanged: (v) => onUpdate('dashboard_show_customer_phone', v),
      ),
      const Divider(height: 1),
      SwitchSettingTile(
        title: 'Checkout Notifications',
        subtitle: 'Notify when tickets are ready',
        value: _bool('dashboard_enable_checkout_notifications', true),
        onChanged: (v) => onUpdate('dashboard_enable_checkout_notifications', v),
      ),
      const Divider(height: 1),
      ServiceDisplayModeTile(
        current: _str('dashboard_service_display_mode', 'pills'),
        onSelect: (m) => onUpdate('dashboard_service_display_mode', m),
      ),
    ]);
  }

  bool _bool(String k, bool d) {
    final s = settings[k];
    return s == null ? d : (s.value == 'true' || s.value == '1');
  }
  String _str(String k, String d) => settings[k]?.value ?? d;
}
