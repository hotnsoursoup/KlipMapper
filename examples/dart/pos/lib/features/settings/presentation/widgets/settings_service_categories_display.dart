// lib/features/settings/presentation/widgets/tiles/service_display_mode_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../shared/presentation/widgets/service_category_icon.dart';
import '../../../../shared/presentation/widgets/service_pill.dart';

class ServiceDisplayModeTile extends StatelessWidget {
  final String current; final ValueChanged<String> onSelect;
  const ServiceDisplayModeTile({super.key, required this.current,
    required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      title: Text('Service Display Mode', style:
        const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 4),
        const Text('Choose how services appear on the main screen'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _modeCard(
            label: 'Pills', selected: current == 'pills', onTap: () => onSelect('pills'),
            child: Wrap(spacing: 4, runSpacing: 4, children: [
              ServicePill(serviceName: 'Nails', categoryId: 'nails', isSmall: true),
              ServicePill(serviceName: 'Gel', categoryId: 'gel', isSmall: true),
            ]),
          )),
          const SizedBox(width: 12),
          Expanded(child: _modeCard(
            label: 'Icons', selected: current == 'icons', onTap: () => onSelect('icons'),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ServiceCategoryIcon(categoryId: 'nails', serviceName: 'Nails', size: 24),
              const SizedBox(width: 8),
              ServiceCategoryIcon(categoryId: 'gel', serviceName: 'Gel', size: 24),
            ]),
          )),
        ]),
      ]),
    );
  }

  Widget _modeCard({required String label, required bool selected,
    required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primaryBlue : AppColors.border,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppColors.primaryBlue.withValues(alpha: 0.05) : null,
        ),
        child: Column(children: [
          Text(label, style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primaryBlue : AppColors.textPrimary,
          )),
          const SizedBox(height: 8), child,
        ]),
      ),
    );
  }
}
