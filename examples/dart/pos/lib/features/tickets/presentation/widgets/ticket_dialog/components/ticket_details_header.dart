// lib/features/tickets/presentation/widgets/ticket_dialog/components/ticket_details_header.dart
// Header component for ticket dialog showing ticket/customer info and close button. Displays different styling for new check-ins vs existing tickets.
// Usage: ACTIVE - Used within TicketDialog as the top header section

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ticket_details_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/data/models/ticket_model.dart';
import '../../../../../shared/data/models/customer_model.dart';
import '../../../../../shared/data/models/service_model.dart';
import '../../../../../shared/data/models/technician_model.dart';

class TicketDetailsHeader extends ConsumerWidget {
  final Ticket? ticket;
  final Customer? customer;
  final bool isNewCheckIn;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final Function(Ticket ticket) onConfirm;
  
  const TicketDetailsHeader({
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
    final ticketDetails = ref.watch(ticketDetailsProvider(
      ticket: ticket,
      customer: customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
    ));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: ticketDetails.isNewCheckIn ? AppColors.primaryBlue : AppColors.darkNavy,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticketDetails.isNewCheckIn ? 'New Check-in' : 'Ticket Details',
                  style: AppTextStyles.headline2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (!ticketDetails.isNewCheckIn && ticketDetails.ticket != null) ...[
                      Text(
                        'Ticket #${ticketDetails.ticket!.ticketNumber}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Text(
                      ticketDetails.selectedCustomer?.fullName ?? 'Select Customer',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}