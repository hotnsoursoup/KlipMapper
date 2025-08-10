// lib/features/settings/presentation/widgets/sections/security_section.dart
import 'package:flutter/material.dart';

import '../../../shared/data/models/setting_model.dart';
import 'settings_manager_pin_tile.dart';

class SecuritySection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  final int currentEmployeeId;
  const SecuritySection({super.key, required this.settings,
    required this.onUpdate, required this.currentEmployeeId});
  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      ManagerPinTile(),
    ]);
  }
}
