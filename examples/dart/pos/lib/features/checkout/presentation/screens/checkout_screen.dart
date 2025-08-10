// lib/features/checkout/presentation/screens/checkout_screen.dart
// Multi-ticket checkout interface with dual-panel layout for ticket selection and payment processing. Features advanced filtering, sorting, search functionality, and integration with MultiCheckoutStore for batch payment operations with comprehensive order summary.
// Usage: ACTIVE - Primary checkout interface for processing multiple ticket payments and managing checkout workflow

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ticket_utils.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../providers/checkout_providers.dart';
import '../../../shared/providers/tickets_master_provider.dart';
import '../widgets/order_summary_panel.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure tickets master initializes; provider auto-loads but we can optionally refresh.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ticketsMasterProvider.notifier); // touch to initialize
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await ref.read(ticketsMasterProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left panel - Ticket selection
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFiltersAndSearch(),
                  Expanded(child: _buildTicketsList()),
                ],
              ),
            ),
          ),
          // Right panel - Order summary
          const OrderSummaryPanel(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/dashboard'),
            icon: const Icon(Icons.arrow_back, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 16),
          Text(
            'Checkout',
            style: AppTextStyles.headline1.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildTabButton('Tickets', true, Icons.receipt),
              const SizedBox(width: 8),
              _buildTabButton('Quick Sale', false, Icons.point_of_sale),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primaryBlue : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Select Tickets',
                style: AppTextStyles.headline2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Observer(
                builder: (_) => Text(
                  '${_checkoutStore.readyTicketsCount} tickets found',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose tickets ready for checkout',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSearchField(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusFilter(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSortFilter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by customer, ticket #, or service...',
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) => ref.read(checkoutProvider.notifier).setSearchQuery(value),
      ),
    );
  }

  Widget _buildStatusFilter() {
    final state = ref.watch(checkoutProvider).value;
    return DropdownButtonFormField<String?>(
      value: state?.statusFilter,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.border),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: const [
          DropdownMenuItem(value: null, child: Text('All Tickets')),
          DropdownMenuItem(value: 'completed', child: Text('Ready to Pay')),
          DropdownMenuItem(value: 'in-service', child: Text('In Service')),
          DropdownMenuItem(value: 'queued', child: Text('Queued')),
        ],
        onChanged: (value) => ref.read(checkoutProvider.notifier).setStatusFilter(value),
    );
  }

  Widget _buildSortFilter() {
    final state = ref.watch(checkoutProvider).value;
    return DropdownButtonFormField<String>(
      value: state?.sortBy ?? 'status',
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.border),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: const [
          DropdownMenuItem(value: 'status', child: Text('Sort by Status')),
          DropdownMenuItem(value: 'check-in', child: Text('Sort by Check-in Time')),
          DropdownMenuItem(value: 'amount', child: Text('Sort by Amount')),
          DropdownMenuItem(value: 'customer', child: Text('Sort by Customer')),
        ],
        onChanged: (value) => ref.read(checkoutProvider.notifier).setSortBy(value ?? 'status'),
    );
  }




  Widget _buildTicketsList() {
    final ticketsAsync = ref.watch(ticketsMasterProvider);
    final availableTickets = ref.watch(availableTicketsProvider);

    if (ticketsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (availableTickets.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableTickets.length,
      itemBuilder: (context, index) {
        final ticket = availableTickets[index];
        return _buildSelectableTicketCard(ticket);
      },
    );
  }

  Widget _buildSelectableTicketCard(Ticket ticket) {
    final isSelected = ref.watch(isTicketSelectedProvider(ticket.id));
    final isReadyForCheckout = ticket.status == 'completed' || ticket.status == 'in-service';
        
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primaryBlue
                  : isReadyForCheckout 
                      ? AppColors.primaryBlue.withValues(alpha: 0.3)
                      : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => ref.read(checkoutProvider.notifier).toggleTicketSelection(ticket.id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Selection checkbox
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryBlue : AppColors.border,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Ticket info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ticket #${ticket.ticketNumber}',
                              style: AppTextStyles.headline3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(ticket.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              ticket.customer.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (ticket.services.isNotEmpty) ...
                          ticket.services.take(2).map((service) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                service.name,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ).toList(),
                        if (ticket.services.length > 2)
                          Text(
                            '+${ticket.services.length - 2} more services',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (true) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Check-in: ${_formatTime(ticket.checkInTime)}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Wait: ${_calculateWaitTime(ticket.checkInTime)}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Amount and service count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        TicketUtils.formatPrice(ticket.totalAmount ?? 0),
                        style: AppTextStyles.headline3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ticket.services.length} service${ticket.services.length != 1 ? 's' : ''}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildStatusChip(String status) {
    final statusColor = TicketUtils.getStatusColor(status);
    final statusLabel = TicketUtils.getStatusLabel(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusLabel,
        style: AppTextStyles.labelSmall.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tickets ready for checkout',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty 
                ? 'Try adjusting your search criteria'
                : 'Complete services to enable checkout',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/tickets'),
            icon: const Icon(Icons.receipt, size: 18),
            label: const Text('View All Tickets'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return AppDateFormatter.formatTime(dateTime);
  }

  String _calculateWaitTime(DateTime checkInTime) {
    final now = DateTime.now();
    final difference = now.difference(checkInTime);
    final minutes = difference.inMinutes;
    
    if (minutes < 60) {
      return '${minutes} min';
    } else {
      final hours = difference.inHours;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
    }
  }

  Future<void> _processPayment() async {
    if (!_checkoutStore.canProcessPayment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select tickets and payment method'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    try {
      final invoice = await _checkoutStore.processPayment(
        notes: 'Multi-ticket checkout via POS',
      );

      if (invoice != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment processed successfully! Invoice ${invoice.invoiceNumber}',
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
        
        // Refresh tickets
        await _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

}
