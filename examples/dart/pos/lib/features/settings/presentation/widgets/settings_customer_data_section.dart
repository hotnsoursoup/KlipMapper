// lib/features/settings/presentation/widgets/sections/customer_data_section.dart
import 'package:flutter/material.dart';

import '../../../shared/data/models/setting_model.dart';
import 'settings_switch_setting_title.dart';

class CustomerDataSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  const CustomerDataSection({super.key, required this.settings,
    required this.onUpdate});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SwitchSettingTile(
        title: 'Collect Address Information',
        subtitle: 'Ask for address during registration',
        value: _b('general_collect_customer_address', true),
        onChanged: (v) => onUpdate('general_collect_customer_address', v),
      ),
      const Divider(height: 1),
      SwitchSettingTile(
        title: 'Collect Date of Birth',
        subtitle: 'Ask for DOB during registration',
        value: _b('general_collect_customer_dob', true),
        onChanged: (v) => onUpdate('general_collect_customer_dob', v),
      ),
      const Divider(height: 1),
      SwitchSettingTile(
        title: 'Collect Gender',
        subtitle: 'Ask for gender during registration',
        value: _b('general_collect_customer_gender', true),
        onChanged: (v) => onUpdate('general_collect_customer_gender', v),
      ),
      const Divider(height: 1),
      SwitchSettingTile(
        title: 'Collect Allergy Information',
        subtitle: 'Ask for allergies/sensitivities',
        value: _b('general_collect_customer_allergies', true),
        onChanged: (v) => onUpdate('general_collect_customer_allergies', v),
      ),
    ]);
  }
  bool _b(String k, bool d) {
    final s = settings[k];
    return s == null ? d : (s.value == 'true' || s.value == '1');
  }
}
