// lib/features/tickets/presentation/widgets/ticket_dialog/components/customer_selection_view.dart
// Customer selection component for ticket dialog using Riverpod providers. Provides search functionality and customer list for creating or editing tickets.
// Usage: ACTIVE - Used within TicketDialog for customer selection step

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ticket_details_provider.dart';
import '../../../../../customers/providers/customers_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/async_value_widget.dart';
import '../../../../../shared/data/models/customer_model.dart';
import '../../../../../shared/data/models/service_model.dart';
import '../../../../../shared/data/models/technician_model.dart';
import '../../../../../shared/data/models/ticket_model.dart';

class CustomerSelectionView extends ConsumerStatefulWidget {
  final Ticket? ticket;
  final Customer? customer;
  final bool isNewCheckIn;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  
  const CustomerSelectionView({
    super.key,
    this.ticket,
    this.customer,
    this.isNewCheckIn = false,
    this.availableServices = const [],
    this.availableTechnicians = const [],
  });

  @override
  ConsumerState<CustomerSelectionView> createState() => _CustomerSelectionViewState();
}

class _CustomerSelectionViewState extends ConsumerState<CustomerSelectionView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ticket details provider with the proper parameters
    final ticketDetails = ref.watch(ticketDetailsProvider(
      ticket: widget.ticket,
      customer: widget.customer,
      isNewCheckIn: widget.isNewCheckIn,
      availableServices: widget.availableServices,
      availableTechnicians: widget.availableTechnicians,
    ));
    
    final ticketDetailsNotifier = ref.read(ticketDetailsProvider(
      ticket: widget.ticket,
      customer: widget.customer,
      isNewCheckIn: widget.isNewCheckIn,
      availableServices: widget.availableServices,
      availableTechnicians: widget.availableTechnicians,
    ).notifier);
    
    final customersAsync = ref.watch(customersMasterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Customer',
          style: AppTextStyles.headline3,
        ),
        const SizedBox(height: 16),
        
        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search customers...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        
        // Customer list
        Expanded(
          child: AsyncValueWidget<Map<String, Customer>>(
            value: customersAsync,
            data: (context, customersMap, child) {
              final customersList = customersMap.values.toList();
              final filteredCustomers = _searchController.text.isEmpty
                  ? customersList
                  : customersList.where((c) =>
                      c.fullName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      (c.phone?.contains(_searchController.text) ?? false)
                    ).toList();

              if (filteredCustomers.isEmpty) {
                return const Center(
                  child: Text('No customers found'),
                );
              }

              return ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  final isSelected = ticketDetails.selectedCustomer?.id == customer.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? AppColors.primaryBlue : AppColors.surfaceLight,
                        child: Text(
                          customer.fullName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      title: Text(customer.fullName),
                      subtitle: Text(customer.phone ?? 'No phone'),
                      selected: isSelected,
                      onTap: () {
                        ticketDetailsNotifier.selectCustomer(customer);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Confirm button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: ticketDetails.selectedCustomer != null
                ? () => ticketDetailsNotifier.confirmCustomer()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Confirm Customer'),
          ),
        ),
      ],
    );
  }
}