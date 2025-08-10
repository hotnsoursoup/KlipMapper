// lib/features/settings/presentation/widgets/tiles/manager_pin_tile.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/manager_pin_bootstrap.dart';

class ManagerPinTile extends StatefulWidget {
  const ManagerPinTile({super.key});
  @override
  State<ManagerPinTile> createState() => _ManagerPinTileState();
}

class _ManagerPinTileState extends State<ManagerPinTile> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text('Manager PIN Setup', style:
        AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      subtitle: const Text('Set up or reset manager PINs'),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.admin_panel_settings, color: AppColors.primaryBlue),
      ),
      trailing: _busy
          ? const SizedBox(width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Setup', style: TextStyle(color: Colors.white)),
            ),
      onTap: _busy ? null : _setup,
    );
  }

  Future<void> _setup() async {
    setState(() => _busy = true);
    try {
      final ok = await ManagerPinBootstrap.instance
          .forceManagerPinSetup(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Manager PIN setup complete' : 'Cancelled'),
        backgroundColor: ok ? AppColors.successGreen : Colors.grey,
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to setup manager PIN'),
        backgroundColor: AppColors.errorRed,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

// lib/features/settings/presentation/widgets/tiles/store_hours_t
