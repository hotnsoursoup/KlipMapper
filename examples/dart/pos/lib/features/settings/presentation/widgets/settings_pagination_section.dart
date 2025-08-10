// lib/features/settings/presentation/widgets/sections/pagination_section.dart
import 'package:flutter/material.dart';

import '../../../shared/data/models/setting_model.dart';
import 'pagination_settings_tile.dart';

class PaginationSection extends StatelessWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;
  const PaginationSection({super.key, required this.settings, required this.onUpdate});
  @override
  Widget build(BuildContext context) {
    return PaginationSettingTile(
      itemsPerPage: _i('general_default_items_per_page', 25),
      onChanged: (v) => onUpdate('general_default_items_per_page', v),
    );
  }
  int _i(String k, int d) => int.tryParse(settings[k]?.value ?? '') ?? d;
}
