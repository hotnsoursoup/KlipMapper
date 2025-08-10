/// Comprehensive checkout dialog supporting both ticket payments and quick sales.
/// 
/// **Architecture:**
/// - **State Management**: Local StatefulWidget with CheckoutState model
/// - **Payment Processing**: PaymentRepository integration with async processing
/// - **UI Modes**: Responsive layout (desktop/mobile) with fullscreen dialog
/// 
/// **Key Features:**
/// - Multi-ticket checkout with service itemization
/// - Quick sale mode for immediate service purchases
/// - Payment method selection (cash, card, other)
/// - Tip calculation (percentage or custom amount)
/// - Discount application with employee authentication
/// - Tax calculation (8.75% configurable rate)
/// - Real-time total calculation with payment summary
/// 
/// **Payment Flow:**
/// 1. Select payment method and configure tip/discount
/// 2. Validate payment details and calculate final total
/// 3. Process payment through PaymentRepository
/// 4. Handle success/error states with appropriate feedback
/// 
/// **Responsive Design:**
/// - Desktop: Left sidebar (30%) + main content (70%)
/// - Mobile: Stacked layout with mobile-specific summary/bottom bar
/// 
/// **Factory Constructors:**
/// - `CheckoutDialog.fromTickets()`: Standard ticket payment mode
/// - `CheckoutDialog.quickSale()`: Direct service sale mode
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/repositories/payment_repository.dart';
import '../../data/models/payment_result.dart';
import '../../data/models/checkout_state.dart';
import 'discount_selector.dart';

class CheckoutDialog extends StatefulWidget {
  final List<Ticket>? selectedTickets; // Nullable for Quick Sale mode
  final bool isQuickSale;
  final Function(PaymentResult) onPaymentComplete;
  final int? currentEmployeeId; // For PIN authentication
  
  const CheckoutDialog({
    super.key,
    this.selectedTickets,
    this.isQuickSale = false,
    required this.onPaymentComplete,
    this.currentEmployeeId,
  });
  
  // Factory constructors for different modes
  factory CheckoutDialog.fromTickets({
    required List<Ticket> tickets,
    required Function(PaymentResult) onPaymentComplete,
    int? currentEmployeeId,
  }) => CheckoutDialog(
    selectedTickets: tickets,
    onPaymentComplete: onPaymentComplete,
    currentEmployeeId: currentEmployeeId,
  );
  
  factory CheckoutDialog.quickSale({
    required Function(PaymentResult) onPaymentComplete,
    int? currentEmployeeId,
  }) => CheckoutDialog(
    isQuickSale: true,
    onPaymentComplete: onPaymentComplete,
    currentEmployeeId: currentEmployeeId,
  );

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  late CheckoutState _checkoutState;
  final double taxRate = 0.0875; // 8.75% tax rate
  final PaymentRepository _paymentRepository = PaymentRepository.instance;

  @override
  void initState() {
    super.initState();
    _initializeCheckoutState();
  }

  void _initializeCheckoutState() {
    _checkoutState = CheckoutState(
      selectedTickets: widget.selectedTickets,
      quickSaleItems: [],
      tipPercentage: 0.0,
      customTipAmount: 0.0,
      isProcessing: false,
      isQuickSale: widget.isQuickSale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            widget.isQuickSale ? 'Quick Sale' : 'Checkout',
            style: AppTextStyles.headline2.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (!widget.isQuickSale)
              TextButton.icon(
                onPressed: () => _switchToQuickSale(),
                icon: const Icon(Icons.point_of_sale, color: Colors.white, size: 20),
                label: const Text('Quick Sale', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Sidebar (30% width)
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: _buildLeftSidebar(),
        ),
        // Main Content Area (70% width)
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Summary at top for mobile
        _buildMobileSummary(),
        const Divider(height: 1),
        // Main content
        Expanded(
          child: _buildMainContent(),
        ),
        // Bottom bar for mobile
        _buildMobileBottomBar(),
      ],
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          _buildSidebarHeader(),
          _buildModeToggle(),
          Expanded(
            child: widget.isQuickSale 
                ? _buildQuickSaleCart()
                : _buildSelectedTicketsSummary(),
          ),
          _buildPaymentSummary(),
          _buildPaymentActions(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(
            widget.isQuickSale ? Icons.point_of_sale : Icons.shopping_cart,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Text(
            widget.isQuickSale ? 'Quick Sale' : 'Selected Tickets',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    if (widget.isQuickSale) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton.icon(
        onPressed: () => _switchToQuickSale(),
        icon: const Icon(Icons.point_of_sale, size: 18),
        label: const Text('Switch to Quick Sale'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: BorderSide(color: AppColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (widget.isQuickSale) {
      return _buildQuickSaleGrid();
    } else {
      return _buildTicketsDisplay();
    }
  }

  Widget _buildSelectedTicketsSummary() {
    final tickets = _checkoutState.selectedTickets ?? [];
    
    if (tickets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No tickets selected',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketSummaryCard(ticket);
      },
    );
  }

  Widget _buildTicketSummaryCard(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket #${ticket.ticketNumber}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(ticket.totalAmount ?? 0).toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              ticket.customer.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${ticket.services.length} service${ticket.services.length != 1 ? 's' : ''}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSaleCart() {
    // TODO: Implement Quick Sale cart display
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Quick Sale cart\n(Coming soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildQuickSaleGrid() {
    // TODO: Implement Quick Sale service grid
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Quick Sale service grid\n(Coming soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTicketsDisplay() {
    final tickets = _checkoutState.selectedTickets ?? [];
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: AppTextStyles.headline3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildServicesList(tickets),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return const Center(
        child: Text(
          'No tickets selected for checkout',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, ticketIndex) {
        final ticket = tickets[ticketIndex];
        return _buildTicketServicesSection(ticket);
      },
    );
  }

  Widget _buildTicketServicesSection(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _modifyTicket(ticket),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Services'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Services list
            ...ticket.services.map((service) => _buildServiceItem(service)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Service service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '${service.durationMinutes} min',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${service.price.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final subtotal = _calculateSubtotal();
    final tipAmount = _calculateTipAmount();
    final discountAmount = _calculateDiscountAmount();
    final taxAmount = _calculateTaxAmount();
    final total = _calculateTotal();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _buildSummaryLine('Subtotal', subtotal),
          if (tipAmount > 0) _buildSummaryLine('Tip', tipAmount),
          if (discountAmount > 0) _buildSummaryLine('Discount', -discountAmount),
          _buildSummaryLine('Tax (8.75%)', taxAmount),
          const Divider(),
          _buildSummaryLine('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
                ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal 
                ? AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  )
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Payment method selection
          _buildPaymentMethodSelector(),
          const SizedBox(height: 16),
          // Tip selection
          _buildTipSelector(),
          const SizedBox(height: 16),
          // Discount selection (if employee ID is provided)
          if (widget.currentEmployeeId != null) ...[
            _buildDiscountSelector(),
            const SizedBox(height: 16),
          ],
          // Process payment button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canProcessPayment() ? _processPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _checkoutState.isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Process Payment'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildPaymentMethodButton(PaymentMethod.cash, 'Cash', Icons.money),
        const SizedBox(height: 8),
        _buildPaymentMethodButton(PaymentMethod.card, 'Card', Icons.credit_card),
        const SizedBox(height: 8),
        _buildPaymentMethodButton(PaymentMethod.other, 'Other', Icons.payment),
      ],
    );
  }

  Widget _buildPaymentMethodButton(PaymentMethod method, String label, IconData icon) {
    final isSelected = _checkoutState.selectedPaymentMethod == method;
    
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _selectPaymentMethod(method),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : AppColors.primaryBlue,
          backgroundColor: isSelected ? AppColors.primaryBlue : Colors.transparent,
          side: BorderSide(color: AppColors.primaryBlue),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTipSelector() {
    final subtotal = _calculateSubtotal();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tip',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        // Percentage tip buttons
        Row(
          children: [
            Expanded(child: _buildTipPercentageButton(0.15, '15%')),
            const SizedBox(width: 8),
            Expanded(child: _buildTipPercentageButton(0.18, '18%')),
            const SizedBox(width: 8),
            Expanded(child: _buildTipPercentageButton(0.20, '20%')),
            const SizedBox(width: 8),
            Expanded(child: _buildTipPercentageButton(0.25, '25%')),
          ],
        ),
        const SizedBox(height: 12),
        // Custom tip input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Custom Tip Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  setState(() {
                    _checkoutState = _checkoutState.copyWith(
                      customTipAmount: amount,
                      tipPercentage: 0.0, // Clear percentage when custom amount is entered
                    );
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            // No tip button
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _checkoutState = _checkoutState.copyWith(
                    tipPercentage: 0.0,
                    customTipAmount: 0.0,
                  );
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: (_checkoutState.tipPercentage == 0.0 && _checkoutState.customTipAmount == 0.0) 
                    ? AppColors.primaryBlue.withValues(alpha: 0.1) 
                    : null,
                foregroundColor: (_checkoutState.tipPercentage == 0.0 && _checkoutState.customTipAmount == 0.0) 
                    ? AppColors.primaryBlue 
                    : AppColors.textSecondary,
                side: BorderSide(
                  color: (_checkoutState.tipPercentage == 0.0 && _checkoutState.customTipAmount == 0.0) 
                      ? AppColors.primaryBlue 
                      : AppColors.border,
                  width: (_checkoutState.tipPercentage == 0.0 && _checkoutState.customTipAmount == 0.0) ? 2 : 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('No Tip'),
            ),
          ],
        ),
        if (_calculateTipAmount() > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tip Amount:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${_calculateTipAmount().toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTipPercentageButton(double percentage, String label) {
    final isSelected = _checkoutState.tipPercentage == percentage && _checkoutState.customTipAmount == 0.0;
    
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _checkoutState = _checkoutState.copyWith(
            tipPercentage: percentage,
            customTipAmount: 0.0, // Clear custom amount when percentage is selected
          );
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : null,
        foregroundColor: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildDiscountSelector() {
    if (widget.currentEmployeeId == null) return const SizedBox.shrink();
    
    return DiscountSelector(
      currentDiscount: _checkoutState.discount,
      subtotal: _calculateSubtotal(),
      currentEmployeeId: widget.currentEmployeeId!,
      onDiscountChanged: (discount) {
        setState(() {
          _checkoutState = _checkoutState.copyWith(discount: discount);
        });
      },
    );
  }

  Widget _buildMobileSummary() {
    // TODO: Implement mobile summary
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Text('Mobile summary (Coming soon)'),
    );
  }

  Widget _buildMobileBottomBar() {
    // TODO: Implement mobile bottom bar
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Text('Mobile bottom bar (Coming soon)'),
    );
  }

  // Calculation methods
  double _calculateSubtotal() {
    if (widget.isQuickSale) {
      return _checkoutState.quickSaleItems
          .fold(0.0, (sum, item) => sum + item.price);
    } else {
      return (_checkoutState.selectedTickets ?? [])
          .fold(0.0, (sum, ticket) => sum + (ticket.totalAmount ?? 0.0));
    }
  }

  double _calculateTipAmount() {
    final subtotal = _calculateSubtotal();
    if (_checkoutState.customTipAmount > 0) {
      return _checkoutState.customTipAmount;
    } else if (_checkoutState.tipPercentage > 0) {
      return subtotal * _checkoutState.tipPercentage;
    }
    return 0.0;
  }

  double _calculateDiscountAmount() {
    return _checkoutState.discount?.calculateAmount(_calculateSubtotal()) ?? 0.0;
  }

  double _calculateTaxAmount() {
    final subtotal = _calculateSubtotal();
    final tipAmount = _calculateTipAmount();
    final discountAmount = _calculateDiscountAmount();
    return (subtotal + tipAmount - discountAmount) * taxRate;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + 
           _calculateTipAmount() - 
           _calculateDiscountAmount() + 
           _calculateTaxAmount();
  }

  // Action methods
  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      _checkoutState = _checkoutState.copyWith(selectedPaymentMethod: method);
    });
  }

  bool _canProcessPayment() {
    final hasItems = widget.isQuickSale 
        ? _checkoutState.quickSaleItems.isNotEmpty
        : (_checkoutState.selectedTickets?.isNotEmpty ?? false);
    
    return hasItems && 
           _checkoutState.selectedPaymentMethod != null && 
           !_checkoutState.isProcessing;
  }

  void _processPayment() async {
    setState(() {
      _checkoutState = _checkoutState.copyWith(isProcessing: true);
    });

    try {
      PaymentResult result;
      
      if (widget.isQuickSale) {
        // Process quick sale
        result = await _paymentRepository.processQuickSale(
          items: _checkoutState.quickSaleItems.map((item) => {
            'name': item.serviceName,
            'price': item.price,
            'quantity': item.quantity,
          },).toList(),
          paymentMethod: _checkoutState.selectedPaymentMethod!.name,
          amount: _calculateSubtotal(),
          tipAmount: _calculateTipAmount(),
          taxAmount: _calculateTaxAmount(),
          discountAmount: _calculateDiscountAmount(),
          discountType: _checkoutState.discount?.type,
          discountCode: _checkoutState.discount?.code,
          discountReason: _checkoutState.discount?.reason,
          customerId: _checkoutState.selectedCustomerId,
          notes: 'Quick sale processed via POS',
        );
      } else {
        // Process ticket payment
        result = await _paymentRepository.processPayment(
          tickets: _checkoutState.selectedTickets ?? [],
          paymentMethod: _checkoutState.selectedPaymentMethod!.name,
          amount: _calculateSubtotal(),
          tipAmount: _calculateTipAmount(),
          taxAmount: _calculateTaxAmount(),
          discountAmount: _calculateDiscountAmount(),
          discountType: _checkoutState.discount?.type,
          discountCode: _checkoutState.discount?.code,
          discountReason: _checkoutState.discount?.reason,
          customerId: _checkoutState.selectedCustomerId,
          notes: 'Payment processed via POS',
        );
      }
      
      setState(() {
        _checkoutState = _checkoutState.copyWith(isProcessing: false);
      });
      
      widget.onPaymentComplete(result);
      
    } catch (e) {
      setState(() {
        _checkoutState = _checkoutState.copyWith(
          isProcessing: false,
          errorMessage: 'Payment processing failed: ${e.toString()}',
        );
      });
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Error'),
            content: Text('Failed to process payment: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _switchToQuickSale() {
    // TODO: Implement quick sale switch
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick Sale mode coming soon...')),
    );
  }

  void _modifyTicket(Ticket ticket) {
    // TODO: Integrate with TicketDetailsDialog for modifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modify ticket ${ticket.ticketNumber} (Coming soon)')),
    );
  }
}

enum PaymentMethod { cash, card, other }
