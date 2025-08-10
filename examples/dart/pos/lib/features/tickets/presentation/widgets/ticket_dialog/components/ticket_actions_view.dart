// lib/features/tickets/presentation/widgets/ticket_dialog/components/ticket_actions_view.dart
// Summary and actions view for ticket dialog with payment calculations. Displays selected services, customer info, and provides confirm/cancel actions.
// Usage: ACTIVE - Used within TicketDialog as the right side panel

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ticket_details_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/data/models/customer_model.dart';
import '../../../../../shared/data/models/service_model.dart';
import '../../../../../shared/data/models/technician_model.dart';
import '../../../../../shared/data/models/ticket_model.dart';

class TicketActionsView extends ConsumerWidget {
  final Ticket? ticket;
  final Customer? customer;
  final bool isNewCheckIn;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final Function(Ticket ticket) onConfirm;
  
  const TicketActionsView({
    super.key,
    this.ticket,
    this.customer,
    this.isNewCheckIn = false,
    this.availableServices = const [],
    this.availableTechnicians = const [],
    required this.onConfirm,
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

    // Calculate totals
    final subtotal = ticketDetails.selectedServices
        .fold(0.0, (sum, service) => sum + service.price);
    final tax = subtotal * 0.0825; // 8.25% tax rate
    final total = subtotal + tax;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          left: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 16),
                  
                  // Customer summary
                  if (ticketDetails.selectedCustomer != null) ...[
                    _buildSummarySection(
                      title: 'Customer',
                      children: [
                        Text(
                          ticketDetails.selectedCustomer!.fullName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (ticketDetails.selectedCustomer!.phone != null)
                          Text(
                            ticketDetails.selectedCustomer!.phone!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Services summary
                  if (ticketDetails.selectedServices.isNotEmpty) ...[
                    _buildSummarySection(
                      title: 'Services',
                      children: ticketDetails.selectedServices.map((service) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ),
                              Text(
                                '\$${service.price.toStringAsFixed(2)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Group service info
                  if (ticketDetails.isGroupService) ...[
                    _buildSummarySection(
                      title: 'Group Service',
                      children: [
                        Text(
                          'Group size: ${ticketDetails.groupSize} people',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Technician preference
                  if (ticketDetails.selectedTechnicianName != null) ...[
                    _buildSummarySection(
                      title: 'Preferred Technician',
                      children: [
                        Text(
                          ticketDetails.selectedTechnicianName!,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Notes
                  if (ticketDetails.notes.isNotEmpty) ...[
                    _buildSummarySection(
                      title: 'Notes',
                      children: [
                        Text(
                          ticketDetails.notes,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Payment summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment',
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: AppTextStyles.bodyMedium),
                            Text(
                              '\$${subtotal.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax (8.25%):', style: AppTextStyles.bodyMedium),
                            Text(
                              '\$${tax.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: ticketDetailsNotifier.canSave()
                        ? () {
                            final newTicket = ticketDetailsNotifier.buildTicket();
                            onConfirm(newTicket);
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isNewCheckIn ? 'Check In Customer' : 'Save Changes',
                      style: AppTextStyles.buttonText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}