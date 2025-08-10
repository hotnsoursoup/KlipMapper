// lib/features/tickets/presentation/widgets/ticket_dialog/ticket_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/models/customer_model.dart';
import '../../../../shared/data/models/service_model.dart';
import '../../../../shared/data/models/technician_model.dart';
import '../../../../shared/data/models/ticket_model.dart';
import '../../../providers/ticket_details_provider.dart';
import 'components/customer_selection_view.dart';
import 'components/service_selection_view.dart';
import 'components/ticket_actions_view.dart';
import 'components/ticket_details_header.dart';

class TicketDetailsDialog extends ConsumerWidget {
  final Ticket? ticket;
  final Customer? customer;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final void Function(Ticket ticket) onConfirm;
  final bool isNewCheckIn;

  const TicketDetailsDialog({
    super.key,
    this.ticket,
    this.customer,
    required this.availableServices,
    required this.availableTechnicians,
    required this.onConfirm,
    this.isNewCheckIn = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the family instance once (so we can also use .select below)
    final family = ticketDetailsProvider(
      ticket: ticket,
      customer: customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
    );

    // Keep the expensive parts from rebuilding: just read the tiny flag we need
    final customerConfirmed = ref.watch(
      family.select((s) => s.valueOrNull?.customerConfirmed ?? false),
    );

    // You can still keep a full watch somewhere if you need other fields later:
    // final vm = ref.watch(family);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive bounds instead of hardcoded 800x910
          final maxW = constraints.maxWidth.clamp(720.0, 1200.0);
          final maxH = constraints.maxHeight.clamp(640.0, 1000.0);

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxW,
              maxHeight: maxH,
              minWidth: 720,
              minHeight: 640,
            ),
            child: Column(
              children: [
                TicketDetailsHeader(
                  ticket: ticket,
                  customer: customer,
                  isNewCheckIn: isNewCheckIn,
                  availableServices: availableServices,
                  availableTechnicians: availableTechnicians,
                  onConfirm: onConfirm,
                ),
                const Divider(height: 1),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT: step content (scrollable, animated)
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              child: customerConfirmed
                                  ? ServiceSelectionView(
                                      key: const ValueKey('serviceStep'),
                                      ticket: ticket,
                                      customer: customer,
                                      isNewCheckIn: isNewCheckIn,
                                      availableServices: availableServices,
                                      availableTechnicians: availableTechnicians,
                                    )
                                  : CustomerSelectionView(
                                      key: const ValueKey('customerStep'),
                                      ticket: ticket,
                                      customer: customer,
                                      isNewCheckIn: isNewCheckIn,
                                      availableServices: availableServices,
                                      availableTechnicians: availableTechnicians,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      // RIGHT: actions panel
                      TicketActionsView(
                        ticket: ticket,
                        customer: customer,
                        isNewCheckIn: isNewCheckIn,
                        availableServices: availableServices,
                        availableTechnicians: availableTechnicians,
                        onConfirm: onConfirm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
