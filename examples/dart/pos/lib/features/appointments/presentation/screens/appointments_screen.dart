// lib/features/appointments/presentation/screens/appointments_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// --- Core & Shared Imports ---
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/loading_skeletons.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../../shared/presentation/widgets/service_pill.dart';

// --- Feature-Specific Imports ---
// This now imports the file with your master/derived providers
import '../../domain/providers/appointment_providers.dart';
import '../../domain/providers/technician_providers.dart';
import '../widgets/appointments_dialog.dart';

// A local provider to manage the UI's current filter state.
// This is watched by the main data provider.
final uiFiltersProvider = StateProvider<AppointmentFilter>((ref) {
  return const AppointmentFilter(); // Default empty filter
});

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Read the current filter state from our simple UI provider.
    final currentFilters = ref.watch(uiFiltersProvider);

    // 2. Watch the derived provider, passing in the current filters.
    // Riverpod handles the magic of re-fetching when `currentFilters` change.
    final appointmentsAsync =
        ref.watch(appointmentsByFilterProvider(currentFilters));

    // 3. We'll feed the master provider directly to AsyncValueWidget.fromProvider

    return Scaffold(
      appBar: StandardAppHeader.withNavigation(
        title: 'Appointments',
        navigationLabel: 'Calendar View',
        onNavigate: () => context.go('/calendar'),
        addButtonLabel: 'New Appointment',
        onAdd: () => _showNewAppointmentDialog(context, ref),
      ),
      body: Column(
        children: [
          // Summary Cards - now uses the dedicated statistics provider
          _buildCompactSummaryCards(ref),
          const Divider(height: 1),
          // Main Content Area
          Expanded(
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTableHeader(
                      context,
                      ref,
                      // Use current async value for count; fallback to 0 while loading
                      appointmentsAsync.value?.length ?? 0,
                    ),
                    Expanded(
                      // Drive UI from the filtered provider directly
                      child: AsyncValueWidget<List<Appointment>>.fromProvider(
                        provider: appointmentsByFilterProvider(currentFilters),
                        data: (context, filtered, __) =>
                            filtered.isEmpty
                                ? _buildEmptyState(context, ref)
                                : _buildAppointmentsDataTable(filtered),
                        loading: (context) =>
                            LoadingSkeletons.appointmentListSkeleton(itemCount: 10),
                        error: (context, error, stackTrace) => _buildErrorState(ref),
                      ),
                    ),
                    // Note: Pagination controls are removed as the new provider
                    // pattern doesn't support it without significant changes.
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, WidgetRef ref, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: AppColors.primaryBlue, size: 18),
          const SizedBox(width: 8),
          Text('All Appointments',
              style: AppTextStyles.headline3
                  .copyWith(color: AppColors.textPrimary)),
          const SizedBox(width: 24),
          Expanded(child: _buildFiltersRow(ref)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(WidgetRef ref) {
    // Read the current filter values to display in the UI
    final filters = ref.watch(uiFiltersProvider);
    // Read the notifier to make changes
    final notifier = ref.read(uiFiltersProvider.notifier);

    return Row(
      children: [
        // Status Dropdown
        _buildCompactDropdown(
          value: filters.status ?? 'All',
          items: const [
            'All',
            'Scheduled',
            'Confirmed',
            'Arrived',
            'In-Service',
            'Completed',
            'Cancelled',
            'No-Show'
          ],
          onChanged: (value) {
            // Update the filter state
            final newStatus = value == 'All' ? null : value;
            notifier.update((state) => AppointmentFilter(
                  status: newStatus,
                  technicianId: state.technicianId,
                ));
          },
          icon: Icons.flag_outlined,
        ),
        const SizedBox(width: 12),

        // You can add other filters here (e.g., Technician) in the same way

        const Spacer(),
        // Clear Filters Button
        if (filters.status != null || filters.technicianId != null)
          OutlinedButton.icon(
            onPressed: () {
              // Reset the filter state to its default
              notifier.state = const AppointmentFilter();
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear Filters'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
          ),
      ],
    );
  }

  Widget _buildAppointmentsDataTable(List<Appointment> appointments) {
    return SingleChildScrollView(
      child: DataTable(
        // ... same as before ...
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Status')),
        ],
        rows: appointments
            .map((appointment) => _buildDataRow(appointment))
            .toList(),
      ),
    );
  }

  DataRow _buildDataRow(Appointment appointment) {
    return DataRow(
      cells: [
        DataCell(Text(_formatDate(appointment.scheduledStartTime))),
        DataCell(Text(appointment.customerName)),
        DataCell(_buildStatusChip(appointment.status)),
      ],
    );
  }

  void _showNewAppointmentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AppointmentDialog.create(
        onSave: (newAppointment) async {
          // Call the method on the master provider's notifier
          await ref
              .read(appointmentsMasterProvider.notifier)
              .addAppointment(newAppointment);
          if (context.mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildCompactSummaryCards(WidgetRef ref) {
    // Watch the dedicated statistics provider
    final stats = ref.watch(appointmentStatisticsProvider);
    // You can now build your summary cards using stats.todayCount, etc.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatCard(label: 'Total', value: stats.total),
        _StatCard(label: 'Upcoming', value: stats.upcoming),
        _StatCard(label: 'Confirmed', value: stats.confirmed),
        _StatCard(label: 'Completed', value: stats.completed),
      ],
    );
  }

  // Helper widgets remain largely the same
  Widget _buildCompactDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    double width = 150,
  }) {
    return SizedBox(
      width: width,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            value: value,
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: AppTextStyles.bodySmall),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final normalized = status.toLowerCase();
    Color bg;
    Color fg = Colors.white;
    switch (normalized) {
      case 'scheduled':
        bg = AppColors.primaryBlue;
        break;
      case 'confirmed':
        bg = AppColors.successGreen;
        break;
      case 'arrived':
      case 'in-service':
        bg = AppColors.warningOrange;
        break;
      case 'completed':
        bg = Colors.grey;
        break;
      case 'cancelled':
      case 'no-show':
      case 'voided':
        bg = AppColors.errorRed;
        break;
      default:
        bg = AppColors.textLight;
        fg = AppColors.textPrimary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: AppTextStyles.statusBadge.copyWith(color: fg)),
    );
  }

  String _formatDate(DateTime date) {
    // yyyy-MM-dd HH:mm
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd $hh:$min';
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textLight),
          const SizedBox(height: 8),
          Text('No appointments found', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => ref.read(uiFiltersProvider.notifier).state = const AppointmentFilter(),
            icon: const Icon(Icons.clear),
            label: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
          const SizedBox(height: 8),
          Text('Error loading appointments', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(appointmentsMasterProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// Example of a simple stat card for the summary
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value.toString(), style: AppTextStyles.headline3),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
