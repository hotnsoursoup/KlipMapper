// lib/features/checkout/data/models/payment_result.dart
// Payment result model capturing completed checkout transactions with all financial details.
// Supports both ticket-based and quick sale payments with comprehensive transaction tracking.
// Usage: ACTIVE - Payment completion tracking, transaction history, and receipt generation

import '../../../checkout/presentation/widgets/checkout_dialog.dart';
import 'quick_sale_item.dart';

class PaymentResult {
  final String paymentId;
  final List<String>? ticketIds; // Null for Quick Sale
  final List<QuickSaleItem>? quickSaleItems; // Null for Ticket mode
  final PaymentMethod method;
  final double subtotal;
  final double tipAmount;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final DateTime processedAt;
  final String? technicianPin;
  final String? discountReason;
  final String? customerId; // Optional for Quick Sale
  final bool isQuickSale;

  const PaymentResult({
    required this.paymentId,
    this.ticketIds,
    this.quickSaleItems,
    required this.method,
    required this.subtotal,
    required this.tipAmount,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.processedAt,
    this.technicianPin,
    this.discountReason,
    this.customerId,
    required this.isQuickSale,
  });

  PaymentResult copyWith({
    String? paymentId,
    List<String>? ticketIds,
    List<QuickSaleItem>? quickSaleItems,
    PaymentMethod? method,
    double? subtotal,
    double? tipAmount,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    DateTime? processedAt,
    String? technicianPin,
    String? discountReason,
    String? customerId,
    bool? isQuickSale,
  }) {
    return PaymentResult(
      paymentId: paymentId ?? this.paymentId,
      ticketIds: ticketIds ?? this.ticketIds,
      quickSaleItems: quickSaleItems ?? this.quickSaleItems,
      method: method ?? this.method,
      subtotal: subtotal ?? this.subtotal,
      tipAmount: tipAmount ?? this.tipAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      processedAt: processedAt ?? this.processedAt,
      technicianPin: technicianPin ?? this.technicianPin,
      discountReason: discountReason ?? this.discountReason,
      customerId: customerId ?? this.customerId,
      isQuickSale: isQuickSale ?? this.isQuickSale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'ticketIds': ticketIds,
      'quickSaleItems': quickSaleItems?.map((item) => item.toJson()).toList(),
      'method': method.name,
      'subtotal': subtotal,
      'tipAmount': tipAmount,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'processedAt': processedAt.toIso8601String(),
      'technicianPin': technicianPin,
      'discountReason': discountReason,
      'customerId': customerId,
      'isQuickSale': isQuickSale,
    };
  }

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      paymentId: json['paymentId'] as String,
      ticketIds: (json['ticketIds'] as List<dynamic>?)?.cast<String>(),
      quickSaleItems: (json['quickSaleItems'] as List<dynamic>?)
          ?.map((item) => QuickSaleItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      method: PaymentMethod.values.firstWhere(
        (method) => method.name == json['method'],
        orElse: () => PaymentMethod.cash,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      tipAmount: (json['tipAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      processedAt: DateTime.parse(json['processedAt'] as String),
      technicianPin: json['technicianPin'] as String?,
      discountReason: json['discountReason'] as String?,
      customerId: json['customerId'] as String?,
      isQuickSale: json['isQuickSale'] as bool,
    );
  }

  @override
  String toString() {
    return 'PaymentResult(paymentId: $paymentId, method: $method, total: \$${totalAmount.toStringAsFixed(2)}, isQuickSale: $isQuickSale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is PaymentResult &&
      other.paymentId == paymentId &&
      other.method == method &&
      other.totalAmount == totalAmount &&
      other.isQuickSale == isQuickSale;
  }

  @override
  int get hashCode {
    return paymentId.hashCode ^
      method.hashCode ^
      totalAmount.hashCode ^
      isQuickSale.hashCode;
  }
}