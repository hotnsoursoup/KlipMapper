// lib/features/tickets/presentation/widgets/ticket_dialog/components/service_selection_view.dart
// Service selection component for ticket dialog with group service toggle and technician preference. Manages service selection, group booking options, and notes.
// Usage: ACTIVE - Used within TicketDialog for service selection step

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ticket_details_provider.dart';
import '../../../../../services/providers/services_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/async_value_widget.dart';
import '../../../../../shared/data/models/customer_model.dart';
import '../../../../../shared/data/models/service_model.dart';
import '../../../../../shared/data/models/technician_model.dart';
import '../../../../../shared/data/models/ticket_model.dart';

class ServiceSelectionView extends ConsumerWidget {
  final Ticket? ticket;
  final Customer? customer;
  final bool isNewCheckIn;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  
  const ServiceSelectionView({
    super.key,
    this.ticket,
    this.customer,
    this.isNewCheckIn = false,
    this.availableServices = const [],
    this.availableTechnicians = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the ticket details provider with the proper parameters
    final ticketDetails = ref.watch(ticketDetailsProvider(
      ticket: ticket,
      customer: customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
    ));
    
    final ticketDetailsNotifier = ref.read(ticketDetailsProvider(
      ticket: ticket,
      customer: customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
    ).notifier);
    
    // Use available services if provided, otherwise fetch from provider
    final servicesAsync = availableServices.isNotEmpty
        ? AsyncValue.data(availableServices)
        : ref.watch(servicesMasterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer info header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: Text(
                  ticketDetails.selectedCustomer?.fullName.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketDetails.selectedCustomer?.fullName ?? 'No Customer',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (ticketDetails.selectedCustomer?.phone != null)
                      Text(
                        ticketDetails.selectedCustomer!.phone!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => ticketDetailsNotifier.editCustomer(),
                child: const Text('Change'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Group service toggle
        Row(
          children: [
            Text(
              'Select Services',
              style: AppTextStyles.headline3,
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Group Service',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: ticketDetails.isGroupService,
                  onChanged: (value) => ticketDetailsNotifier.toggleGroupService(value),
                  thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Group size selector (if group service)
        if (ticketDetails.isGroupService) ...[
          Row(
            children: [
              Text(
                'Group Size: ',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: 8),
              ...List.generate(6, (index) {
                final size = index + 2;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$size'),
                    selected: ticketDetails.groupSize == size,
                    onSelected: (_) => ticketDetailsNotifier.updateGroupSize(size),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
        ],
        
        // Service list
        Expanded(
          child: AsyncValueWidget<List<Service>>(
            value: servicesAsync,
            data: (context, services, child) {
              if (services.isEmpty) {
                return const Center(
                  child: Text('No services available'),
                );
              }

              // Group services by category
              final servicesByCategory = <String, List<Service>>{};
              for (final service in services) {
                final categoryName = service.categoryName ?? 'Uncategorized';
                servicesByCategory[categoryName] ??= [];
                servicesByCategory[categoryName]!.add(service);
              }

              return ListView.builder(
                itemCount: servicesByCategory.length,
                itemBuilder: (context, index) {
                  final categoryName = servicesByCategory.keys.elementAt(index);
                  final categoryServices = servicesByCategory[categoryName]!;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          categoryName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      ...categoryServices.map((service) {
                        final isSelected = ticketDetails.selectedServices
                            .any((s) => s.id == service.id);
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: CheckboxListTile(
                            title: Text(service.name),
                            subtitle: Text(
                              '\$${service.price.toStringAsFixed(2)} • ${service.durationMinutes} min',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            value: isSelected,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (_) {
                              ticketDetailsNotifier.toggleService(service);
                            },
                          ),
                        );
                      }),
                    ],
                  );
                },
              );
            },
          ),
        ),
        
        // Notes field
        const SizedBox(height: 16),
        Text(
          'Notes (Optional)',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add any notes about this ticket...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) => ticketDetailsNotifier.updateNotes(value),
        ),
        
        // Technician selection
        const SizedBox(height: 16),
        Text(
          'Preferred Technician (Optional)',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: ticketDetails.selectedTechnicianId,
          decoration: InputDecoration(
            hintText: 'Select technician',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('No preference'),
            ),
            ...availableTechnicians.map((tech) => DropdownMenuItem(
              value: tech.id,
              child: Text(tech.name),
            )),
          ],
          onChanged: (techId) {
            final tech = availableTechnicians
                .firstWhere((t) => t.id == techId, orElse: () => Technician(
                  id: '', 
                  name: '',
                  turnNumber: 0,
                  status: 'available',
                  avatarColor: 'blue',
                  avatarInitial: 'T',
                ));
            ticketDetailsNotifier.selectTechnician(techId, tech.name);
          },
        ),
      ],
    );
  }
}