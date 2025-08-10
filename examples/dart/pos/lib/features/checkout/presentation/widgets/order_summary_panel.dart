/// Multi-ticket checkout order summary panel with payment controls.
/// 
/// **Architecture:**
/// - **State Management**: MobX observer pattern with MultiCheckoutStore integration
/// - **Layout**: Fixed-width (400px) sidebar panel with scrollable content
/// - **Reactive UI**: Observer-wrapped components for real-time updates
/// 
/// **Key Features:**
/// - Selected ticket summary with individual pricing
/// - Real-time total calculation (subtotal, tip, tax, discount)
/// - Tip selection (percentage buttons or custom amount)
/// - Payment method selection (cash, card, split)
/// - Payment processing with loading states
/// - Clear selection functionality
/// 
/// **Calculation System:**
/// - Subtotal: Sum of all selected ticket amounts
/// - Tip: Percentage-based or custom amount
/// - Tax: Automatic calculation based on store configuration
/// - Discount: Applied discounts with visual feedback
/// - Total: Final amount with all adjustments
/// 
/// **Payment Flow:**
/// 1. Ticket selection updates summary automatically
/// 2. User configures tip and payment method
/// 3. Real-time validation enables/disables payment button
/// 4. Payment processing with loading feedback
/// 
/// **Responsive Design:**
/// - Fixed width for desktop checkout screen layout
/// - Scrollable content for handling multiple tickets
/// - Clear visual hierarchy with card-based sections
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/checkout_providers.dart';

class OrderSummaryPanel extends ConsumerStatefulWidget {
  const OrderSummaryPanel({super.key});

  @override
  ConsumerState<OrderSummaryPanel> createState() => _OrderSummaryPanelState();
}

class _OrderSummaryPanelState extends ConsumerState<OrderSummaryPanel> {
  final _customTipController = TextEditingController();

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTickets = ref.watch(selectedTicketsProvider);
    return Container(
      width: 400,
      color: AppColors.background,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: selectedTickets.isEmpty ? _buildEmptyState() : _buildOrderContent(),
          ),
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
          Text(
            'Order Summary',
            style: AppTextStyles.headline2.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Builder(builder: (_) {
            final hasSelection = ref.watch(selectedTicketsProvider).isNotEmpty;
            return hasSelection
                ? TextButton(
                    onPressed: () => ref.read(checkoutProvider.notifier).clearSelection(),
                    child: Text('Clear All', style: TextStyle(color: AppColors.errorRed)),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No items selected',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select tickets from the left to proceed with checkout',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectedTickets(),
          const SizedBox(height: 24),
          _buildTotalsSection(),
          const SizedBox(height: 24),
          _buildTipSection(),
          const SizedBox(height: 24),
          _buildPaymentSection(),
          const SizedBox(height: 32),
          _buildProcessButton(),
        ],
      ),
    );
  }

  Widget _buildSelectedTickets() {
    return Observer(
      builder: (_) {
        final selectedTickets = widget.checkoutStore.selectedTickets;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Items (${selectedTickets.length})',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...selectedTickets.map((ticket) => _buildTicketSummary(ticket)),
          ],
        );
      },
    );
  }

  Widget _buildTicketSummary(ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket #${ticket.ticketNumber}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ticket.customer.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (ticket.services.isNotEmpty)
                  Text(
                    '${ticket.services.length} service${ticket.services.length != 1 ? 's' : ''}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '\$${(ticket.totalAmount ?? 0).toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection() {
    final calc = ref.watch(checkoutCalculationProvider);
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildTotalRow('Subtotal', calc.formattedSubtotal),
              if (calc.hasTip) _buildTotalRow('Tip', calc.formattedTip),
              _buildTotalRow('Tax (${calc.formattedTaxRate})', calc.formattedTax),
              if (calc.hasDiscount) _buildTotalRow('Discount', calc.formattedDiscount, isDiscount: true),
              const Divider(),
              _buildTotalRow('Total', calc.formattedTotal, isTotal: true),
            ],
          ),
        );
  }

  Widget _buildTotalRow(String label, String amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal 
                  ? AppColors.primaryBlue 
                  : isDiscount 
                      ? AppColors.errorRed 
                      : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Tip',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTipButton('15%', 0.15),
              const SizedBox(width: 8),
              _buildTipButton('18%', 0.18),
              const SizedBox(width: 8),
              _buildTipButton('20%', 0.20),
              const SizedBox(width: 8),
              _buildTipButton('25%', 0.25),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customTipController,
                  decoration: InputDecoration(
                    labelText: 'Custom Tip (\$)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    ref.read(checkoutProvider.notifier).setCustomTip(amount);
                  },
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _customTipController.clear();
                  ref.read(checkoutProvider.notifier).setCustomTip(0.0);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipButton(String label, double percentage) {
    final isSelected = (ref.watch(checkoutProvider).value?.tipPercentage ?? 0.0) == percentage;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          _customTipController.clear();
          ref.read(checkoutProvider.notifier).setTipPercentage(percentage);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPaymentButton('Cash', Icons.money),
              const SizedBox(width: 8),
              _buildPaymentButton('Card', Icons.credit_card),
              const SizedBox(width: 8),
              _buildPaymentButton('Split', Icons.call_split),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(String label, IconData icon) {
    final isSelected = (ref.watch(checkoutProvider).value?.paymentMethod ?? '') == label.toLowerCase();
    
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(checkoutProvider.notifier).setPaymentMethod(label.toLowerCase());
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessButton() {
    final canProcess = ref.watch(canProcessPaymentProvider);
    final isProcessing = ref.watch(checkoutProvider).value?.isProcessing ?? false;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canProcess && !isProcessing
            ? () async {
                await ref.read(checkoutProvider.notifier).processPayment();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 20),
                  const SizedBox(width: 8),
                  Text('Proceed to Payment', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}
