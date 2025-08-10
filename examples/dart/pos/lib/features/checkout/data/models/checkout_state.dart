// lib/features/checkout/data/models/checkout_state.dart
// Checkout state model managing both ticket-based and quick sale checkout processes.
// Handles payment methods, tips, discounts, and validation for different checkout modes.
// Usage: ACTIVE - Checkout flow state management, payment processing, and transaction validation

import '../../../shared/data/models/ticket_model.dart';
import 'quick_sale_item.dart';
import 'discount_model.dart';
import '../../presentation/widgets/checkout_dialog.dart';

class CheckoutState {
  final List<Ticket>? selectedTickets; // Null for Quick Sale
  final List<QuickSaleItem> quickSaleItems;
  final double tipPercentage;
  final double customTipAmount;
  final Discount? discount;
  final PaymentMethod? selectedPaymentMethod;
  final bool isProcessing;
  final String? errorMessage;
  final bool isQuickSale;
  final String? selectedCustomerId; // Optional for Quick Sale
  
  const CheckoutState({
    this.selectedTickets,
    required this.quickSaleItems,
    required this.tipPercentage,
    required this.customTipAmount,
    this.discount,
    this.selectedPaymentMethod,
    required this.isProcessing,
    this.errorMessage,
    required this.isQuickSale,
    this.selectedCustomerId,
  });

  CheckoutState copyWith({
    List<Ticket>? selectedTickets,
    List<QuickSaleItem>? quickSaleItems,
    double? tipPercentage,
    double? customTipAmount,
    Discount? discount,
    PaymentMethod? selectedPaymentMethod,
    bool? isProcessing,
    String? errorMessage,
    bool? isQuickSale,
    String? selectedCustomerId,
  }) {
    return CheckoutState(
      selectedTickets: selectedTickets ?? this.selectedTickets,
      quickSaleItems: quickSaleItems ?? this.quickSaleItems,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      customTipAmount: customTipAmount ?? this.customTipAmount,
      discount: discount ?? this.discount,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
      isQuickSale: isQuickSale ?? this.isQuickSale,
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
    );
  }

  // Validation
  bool get allServicesAssigned {
    if (isQuickSale) {
      // Only services require technician assignment
      return quickSaleItems
        .where((item) => item.type == ServiceType.service)
        .every((item) => item.assignedTechnicianId?.isNotEmpty == true);
    }
    return true; // Tickets already have assignments
  }

  bool get hasItems {
    if (isQuickSale) {
      return quickSaleItems.isNotEmpty;
    } else {
      return selectedTickets?.isNotEmpty == true;
    }
  }

  bool get canProcessPayment {
    return hasItems && 
           selectedPaymentMethod != null && 
           allServicesAssigned &&
           !isProcessing;
  }

  double get totalItems {
    if (isQuickSale) {
      return quickSaleItems.fold(0.0, (sum, item) => sum + item.quantity);
    } else {
      return (selectedTickets?.length ?? 0).toDouble();
    }
  }

  List<QuickSaleItem> get unassignedServices {
    return quickSaleItems
        .where((item) => 
            item.type == ServiceType.service && 
            item.assignedTechnicianId?.isEmpty != false,)
        .toList();
  }

  bool get hasTip => tipPercentage > 0 || customTipAmount > 0;

  bool get hasDiscount => discount != null;

  String get tipDisplayText {
    if (customTipAmount > 0) {
      return '\$${customTipAmount.toStringAsFixed(2)} (Custom)';
    } else if (tipPercentage > 0) {
      return '${(tipPercentage * 100).toStringAsFixed(0)}%';
    }
    return 'No tip';
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedTickets': selectedTickets?.map((ticket) => ticket.toJson()).toList(),
      'quickSaleItems': quickSaleItems.map((item) => item.toJson()).toList(),
      'tipPercentage': tipPercentage,
      'customTipAmount': customTipAmount,
      'discount': discount?.toJson(),
      'selectedPaymentMethod': selectedPaymentMethod?.name,
      'isProcessing': isProcessing,
      'errorMessage': errorMessage,
      'isQuickSale': isQuickSale,
      'selectedCustomerId': selectedCustomerId,
    };
  }

  @override
  String toString() {
    return 'CheckoutState(isQuickSale: $isQuickSale, hasItems: $hasItems, paymentMethod: $selectedPaymentMethod, canProcess: $canProcessPayment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CheckoutState &&
      other.isQuickSale == isQuickSale &&
      other.tipPercentage == tipPercentage &&
      other.customTipAmount == customTipAmount &&
      other.selectedPaymentMethod == selectedPaymentMethod &&
      other.isProcessing == isProcessing &&
      other.selectedCustomerId == selectedCustomerId;
  }

  @override
  int get hashCode {
    return isQuickSale.hashCode ^
      tipPercentage.hashCode ^
      customTipAmount.hashCode ^
      selectedPaymentMethod.hashCode ^
      isProcessing.hashCode ^
      selectedCustomerId.hashCode;
  }
}