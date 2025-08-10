// lib/features/settings/presentation/screens/settings_screen.dart
// Refactored parent: composes sections; pushes UI into leaf widgets.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_background_section.dart';
import '../widgets/settings_customer_data_section.dart';
import '../widgets/settings_dashboard_section.dart';
import '../widgets/settings_general.dart';
import '../widgets/settings_pagination_section.dart';
import '../widgets/settings_remote_section.dart';
import '../widgets/settings_security_section.dart';
import '../widgets/settings_store_section.dart';
import '../widgets/settings_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _hasUnsavedChanges = false;
  final int _currentEmployeeId = 1; // TODO: from auth

  Future<void> _update(String key, Object value) async {
    try {
      await ref.read(settingsMasterProvider.notifier).updateSetting(key, value);
      if (mounted) setState(() => _hasUnsavedChanges = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e'),
          backgroundColor: AppColors.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsMasterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Dashboard', icon: Icons.dashboard),
                  SettingsCard(child: DashboardSection(
                    settings: settings,
                    onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Backgrounds', icon: Icons.wallpaper),
                  SettingsCard(child: BackgroundsSection(
                    settings: settings,
                    onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Store', icon: Icons.store),
                  SettingsCard(child: StoreSection(
                    settings: settings,
                    onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Customer Data Collection',
                                      icon: Icons.person_add),
                  SettingsCard(child: CustomerDataSection(
                    settings: settings, onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'General', icon: Icons.settings),
                  SettingsCard(child: GeneralSection(
                    settings: settings, onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Pagination', icon: Icons.pages),
                  SettingsCard(child: PaginationSection(
                    settings: settings, onUpdate: _update,
                  )),

                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Security', icon: Icons.security),
                  SettingsCard(child: SecuritySection(
                    settings: settings,
                    onUpdate: _update,
                    currentEmployeeId: _currentEmployeeId,
                  )),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hasUnsavedChanges
                          ? () {
                              setState(() => _hasUnsavedChanges = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Settings saved'),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Settings'),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Remote Access',
                                      icon: Icons.screen_share),
                  const RemoteSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
