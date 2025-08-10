// lib/features/checkout/providers/checkout_providers.dart
// Comprehensive checkout providers for multi-ticket payment processing with complex calculations, tip handling, and invoice generation.
// Manages checkout state, payment processing, invoice creation, and ticket status updates for POS transactions.
// Usage: ACTIVE - Core checkout functionality for dashboard payment processing and invoice management

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/models/invoice_model.dart';
import '../../shared/data/repositories/drift_invoice_repository.dart';
import '../../shared/providers/tickets_master_provider.dart';
import '../data/models/checkout_calculation.dart';
import '../../../core/utils/app_logger.dart';

part 'checkout_providers.g.dart';
part 'checkout_providers.freezed.dart';

// ========== REPOSITORY PROVIDERS ==========

@riverpod
DriftInvoiceRepository invoiceRepository(Ref ref) {
  return DriftInvoiceRepository.instance;
}

// ========== CORE CHECKOUT PROVIDER ==========

/// Multi-ticket checkout provider handling payment processing and invoice generation
@riverpod
class Checkout extends _$Checkout {
  // Tax rate - configurable later via settings
  static const double _taxRate = 0.0875; // 8.75%

  @override
  Future<CheckoutState> build() async {
    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      await invoiceRepo.initialize();
      
      AppLogger.logInfo('CheckoutProvider: Initialized successfully');
      
      return const CheckoutState();
    } catch (e, stack) {
      AppLogger.logError('CheckoutProvider.build', e, stack);
      return CheckoutState(
        errorMessage: 'Failed to initialize checkout: $e',
      );
    }
  }

  /// Toggle ticket selection
  void toggleTicketSelection(String ticketId) {
    final currentState = state.value;
    if (currentState == null) return;

    final currentIds = Set<String>.from(currentState.selectedTicketIds);
    
    if (currentIds.contains(ticketId)) {
      currentIds.remove(ticketId);
    } else {
      currentIds.add(ticketId);
    }

    state = AsyncValue.data(currentState.copyWith(
      selectedTicketIds: currentIds,
      errorMessage: null,
    ));
  }

  /// Select all available tickets
  void selectAllTickets() {
    final availableTickets = ref.read(availableTicketsProvider);
    final ticketIds = availableTickets.map((t) => t.id).toSet();

    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      selectedTicketIds: ticketIds,
      errorMessage: null,
    ));
  }

  /// Clear ticket selection
  void clearSelection() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      selectedTicketIds: const {},
      errorMessage: null,
    ));
  }

  /// Set tip percentage (clears custom tip)
  void setTipPercentage(double percentage) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      tipPercentage: percentage,
      customTipAmount: 0.0,
      errorMessage: null,
    ));
  }

  /// Set custom tip amount (clears percentage)
  void setCustomTip(double amount) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      customTipAmount: amount,
      tipPercentage: 0.0,
      errorMessage: null,
    ));
  }

  /// Set discount
  void setDiscount({
    String? type,
    double amount = 0.0,
    String? code,
    String? reason,
  }) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      discountType: type,
      discountAmount: amount,
      discountCode: code,
      discountReason: reason,
      errorMessage: null,
    ));
  }

  /// Clear discount
  void clearDiscount() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      discountType: null,
      discountAmount: 0.0,
      discountCode: null,
      discountReason: null,
      errorMessage: null,
    ));
  }

  /// Set payment method
  void setPaymentMethod(String method) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      paymentMethod: method,
      errorMessage: null,
    ));
  }

  /// Set card details
  void setCardDetails({String? type, String? lastFour}) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      cardType: type,
      lastFourDigits: lastFour,
      errorMessage: null,
    ));
  }

  /// Set search query for ticket filtering
  void setSearchQuery(String query) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      searchQuery: query,
    ));
  }

  /// Set status filter for ticket filtering
  void setStatusFilter(String? filter) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      statusFilter: filter,
    ));
  }

  /// Set sort order for tickets
  void setSortBy(String sort) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      sortBy: sort,
    ));
  }

  /// Process payment and generate invoice
  Future<Invoice?> processPayment({
    String? transactionId,
    String? authorizationCode,
    String? notes,
  }) async {
    final currentState = state.value;
    if (currentState == null || !currentState.canProcessPayment) {
      _setError('Cannot process payment. Please check selection and payment method.');
      return null;
    }

    // Set processing state
    state = AsyncValue.data(currentState.copyWith(
      isProcessing: true,
      errorMessage: null,
    ));

    try {
      final selectedTickets = ref.read(selectedTicketsProvider);
      final calculation = ref.read(checkoutCalculationProvider);
      final now = DateTime.now();

      // Generate invoice
      final invoice = Invoice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        invoiceNumber: Invoice.generateInvoiceNumber(),
        ticketIds: selectedTickets.map((t) => t.id).toList(),
        customerName: _getPrimaryCustomerName(selectedTickets),
        subtotal: calculation.subtotal,
        taxAmount: calculation.taxAmount,
        tipAmount: calculation.tipAmount,
        discountAmount: calculation.discountAmount,
        totalAmount: calculation.totalAmount,
        paymentMethod: currentState.paymentMethod!,
        discountType: currentState.discountType,
        discountCode: currentState.discountCode,
        discountReason: currentState.discountReason,
        cardType: currentState.cardType,
        lastFourDigits: currentState.lastFourDigits,
        transactionId: transactionId,
        authorizationCode: authorizationCode,
        processedAt: now,
        processedBy: (EmployeeContext.currentEmployeeId ?? 0),
        notes: notes,
        createdAt: now,
        updatedAt: now,
      );

      // Save invoice to database
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      await invoiceRepo.createInvoice(invoice);

      // Update ticket statuses to 'paid'
      final ticketsProvider = ref.read(ticketsMasterProvider.notifier);
      for (final ticket in selectedTickets) {
        final updatedTicket = ticket.copyWith(
          status: 'paid',
          paymentStatus: 'paid',
          updatedAt: now,
        );
        await ticketsProvider.updateTicket(updatedTicket);
      }

      // Clear checkout state
      _resetCheckoutState();
      
      AppLogger.logInfo('Payment processed successfully: ${invoice.invoiceNumber}');
      return invoice;

    } catch (e, stack) {
      AppLogger.logError('Error processing payment', e, stack);
      _setError('Failed to process payment: ${e.toString()}');
      return null;
    } finally {
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncValue.data(currentState.copyWith(isProcessing: false));
      }
    }
  }

  /// Reset checkout state after successful payment
  void _resetCheckoutState() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      selectedTicketIds: const {},
      tipPercentage: 0.0,
      customTipAmount: 0.0,
      discountType: null,
      discountAmount: 0.0,
      discountCode: null,
      discountReason: null,
      paymentMethod: null,
      cardType: null,
      lastFourDigits: null,
      errorMessage: null,
    ));
  }

  /// Set error message
  void _setError(String error) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      errorMessage: error,
      isProcessing: false,
    ));
  }

  /// Get primary customer name for multi-ticket invoice
  String? _getPrimaryCustomerName(List<Ticket> tickets) {
    if (tickets.isEmpty) return null;
    if (tickets.length == 1) return tickets.first.customer.name;
    
    // For multiple tickets, return most frequent customer or first one
    final customerCounts = <String, int>{};
    for (final ticket in tickets) {
      final name = ticket.customer.name;
      customerCounts[name] = (customerCounts[name] ?? 0) + 1;
    }
    
    final mostFrequent = customerCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return mostFrequent.value > 1 ? mostFrequent.key : null;
  }

  /// Force refresh checkout state
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// ========== DERIVED PROVIDERS ==========

/// Provider for available tickets (ready for checkout)
@riverpod
List<Ticket> availableTickets(Ref ref) {
  final allTicketsAsync = ref.watch(ticketsMasterProvider);
  final checkoutState = ref.watch(checkoutProvider).value;
  
  return allTicketsAsync.when(
    data: (allTickets) {
      var tickets = allTickets.where((ticket) => 
          ticket.status == 'completed' || 
          ticket.status == 'in-service').toList();

      // Apply search filter
      if (checkoutState != null && checkoutState.searchQuery.isNotEmpty) {
        final query = checkoutState.searchQuery.toLowerCase();
        tickets = tickets.where((ticket) =>
            ticket.customer.name.toLowerCase().contains(query) ||
            ticket.ticketNumber.toLowerCase().contains(query) ||
            ticket.services.any((service) => 
                service.name.toLowerCase().contains(query))).toList();
      }

      // Apply status filter
      if (checkoutState?.statusFilter != null) {
        tickets = tickets.where((ticket) => 
            ticket.status == checkoutState!.statusFilter).toList();
      }

      // Apply sorting
      final sortBy = checkoutState?.sortBy ?? 'status';
      switch (sortBy) {
        case 'check-in':
          tickets.sort((a, b) => a.checkInTime.compareTo(b.checkInTime));
          break;
        case 'amount':
          tickets.sort((a, b) => (b.totalAmount ?? 0).compareTo(a.totalAmount ?? 0));
          break;
        case 'customer':
          tickets.sort((a, b) => a.customer.name.compareTo(b.customer.name));
          break;
        case 'status':
        default:
          // Sort by status priority: completed first, then in-service
          tickets.sort((a, b) {
            if (a.status == b.status) {
              return a.checkInTime.compareTo(b.checkInTime);
            }
            if (a.status == 'completed') return -1;
            if (b.status == 'completed') return 1;
            return 0;
          });
          break;
      }

      return tickets;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for currently selected tickets
@riverpod
List<Ticket> selectedTickets(Ref ref) {
  final allTicketsAsync = ref.watch(ticketsMasterProvider);
  final checkoutState = ref.watch(checkoutProvider).value;
  
  if (checkoutState == null) return [];
  
  return allTicketsAsync.when(
    data: (tickets) {
      return tickets
          .where((ticket) => checkoutState.selectedTicketIds.contains(ticket.id))
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for checkout calculation
@riverpod
CheckoutCalculation checkoutCalculation(Ref ref) {
  final selectedTickets = ref.watch(selectedTicketsProvider);
  final checkoutState = ref.watch(checkoutProvider).value;
  
  if (selectedTickets.isEmpty || checkoutState == null) {
    return CheckoutCalculation.empty();
  }

  final subtotal = selectedTickets.fold<double>(
    0.0, 
    (sum, ticket) => sum + (ticket.totalAmount ?? 0.0),
  );

  final tipAmount = checkoutState.customTipAmount > 0 
      ? checkoutState.customTipAmount 
      : subtotal * checkoutState.tipPercentage;

  final taxAmount = subtotal * Checkout._taxRate;

  final totalBeforeDiscount = subtotal + tipAmount + taxAmount;
  final finalDiscountAmount = checkoutState.discountAmount.clamp(0.0, totalBeforeDiscount);
  final totalAmount = totalBeforeDiscount - finalDiscountAmount;

  return CheckoutCalculation(
    subtotal: subtotal,
    tipAmount: tipAmount,
    taxAmount: taxAmount,
    discountAmount: finalDiscountAmount,
    totalAmount: totalAmount,
    itemCount: selectedTickets.length,
  );
}

/// Provider to check if payment can be processed
@riverpod
bool canProcessPayment(Ref ref) {
  final selectedTickets = ref.watch(selectedTicketsProvider);
  final checkoutState = ref.watch(checkoutProvider).value;
  
  return selectedTickets.isNotEmpty && 
         checkoutState?.paymentMethod != null && 
         checkoutState?.isProcessing != true;
}

/// Provider for primary customer name (for multi-ticket checkout)
@riverpod
String? primaryCustomerName(Ref ref) {
  final selectedTickets = ref.watch(selectedTicketsProvider);
  
  if (selectedTickets.isEmpty) return null;
  if (selectedTickets.length == 1) return selectedTickets.first.customer.name;
  
  // For multiple tickets, return most frequent customer or first one
  final customerCounts = <String, int>{};
  for (final ticket in selectedTickets) {
    final name = ticket.customer.name;
    customerCounts[name] = (customerCounts[name] ?? 0) + 1;
  }
  
  final mostFrequent = customerCounts.entries
      .reduce((a, b) => a.value > b.value ? a : b);
  
  return mostFrequent.value > 1 ? mostFrequent.key : null;
}

/// Provider for ready tickets count
@riverpod
int readyTicketsCount(Ref ref) {
  final availableTickets = ref.watch(availableTicketsProvider);
  return availableTickets.length;
}

/// Provider for total available value
@riverpod
double totalAvailableValue(Ref ref) {
  final availableTickets = ref.watch(availableTicketsProvider);
  return availableTickets.fold<double>(
    0.0, 
    (sum, ticket) => sum + (ticket.totalAmount ?? 0.0),
  );
}

// ========== UTILITY PROVIDERS ==========

/// Check if a ticket is selected
@riverpod
bool isTicketSelected(Ref ref, String ticketId) {
  final checkoutState = ref.watch(checkoutProvider).value;
  return checkoutState?.selectedTicketIds.contains(ticketId) ?? false;
}

/// Get selection summary text
@riverpod
String selectionSummary(Ref ref) {
  final selectedTickets = ref.watch(selectedTicketsProvider);
  final count = selectedTickets.length;
  
  if (count == 0) return 'No tickets selected';
  if (count == 1) return '1 ticket selected';
  return '$count tickets selected';
}

/// Get ready tickets summary text
@riverpod
String readyTicketsSummary(Ref ref) {
  final count = ref.watch(readyTicketsCountProvider);
  
  if (count == 0) return 'No tickets ready';
  if (count == 1) return '1 ticket ready';
  return '$count tickets ready';
}

// ========== STATE MODELS ==========

@freezed
class CheckoutState with _$CheckoutState {
  const CheckoutState._();
  
  const factory CheckoutState({
    @Default({}) Set<String> selectedTicketIds,
    @Default(0.0) double tipPercentage,
    @Default(0.0) double customTipAmount,
    String? discountType,
    @Default(0.0) double discountAmount,
    String? discountCode,
    String? discountReason,
    String? paymentMethod,
    String? cardType,
    String? lastFourDigits,
    @Default(false) bool isProcessing,
    String? errorMessage,
    @Default('') String searchQuery,
    String? statusFilter,
    @Default('status') String sortBy,
  }) = _CheckoutState;
  
  /// Check if payment can be processed
  bool get canProcessPayment =>
      selectedTicketIds.isNotEmpty && 
      paymentMethod != null && 
      !isProcessing;
}
