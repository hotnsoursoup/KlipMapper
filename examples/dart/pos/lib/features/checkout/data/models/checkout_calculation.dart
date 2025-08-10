// lib/features/checkout/data/models/checkout_calculation.dart
// Calculation model for checkout totals including subtotal, tax, tips, and discounts.
// Provides formatted display strings, validation methods, and immutable calculation results.
// Usage: ACTIVE - Checkout processing, payment calculation, and transaction total computation

/// Calculation model for checkout totals
class CheckoutCalculation {
  final double subtotal;
  final double tipAmount;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final int itemCount;

  const CheckoutCalculation({
    required this.subtotal,
    required this.tipAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.itemCount,
  });

  /// Create empty calculation
  factory CheckoutCalculation.empty() {
    return const CheckoutCalculation(
      subtotal: 0.0,
      taxAmount: 0.0,
      tipAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      itemCount: 0,
    );
  }

  /// Formatted subtotal
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';

  /// Formatted tax amount
  String get formattedTax => '\$${taxAmount.toStringAsFixed(2)}';

  /// Formatted tip amount
  String get formattedTip => tipAmount > 0 ? '\$${tipAmount.toStringAsFixed(2)}' : '\$0.00';

  /// Formatted discount amount (with minus sign if > 0)
  String get formattedDiscount => discountAmount > 0 
      ? '-\$${discountAmount.toStringAsFixed(2)}' 
      : '\$0.00';

  /// Formatted total amount
  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  /// Check if there's a tip
  bool get hasTip => tipAmount > 0;

  /// Check if there's a discount
  bool get hasDiscount => discountAmount > 0;

  /// Check if there are items
  bool get hasItems => itemCount > 0;

  /// Get tax rate as percentage
  double get taxRate => subtotal > 0 ? (taxAmount / subtotal) * 100 : 0.0;

  /// Get formatted tax rate
  String get formattedTaxRate => '${taxRate.toStringAsFixed(2)}%';

  /// Create a copy with updated values
  CheckoutCalculation copyWith({
    double? subtotal,
    double? tipAmount,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    int? itemCount,
  }) {
    return CheckoutCalculation(
      subtotal: subtotal ?? this.subtotal,
      tipAmount: tipAmount ?? this.tipAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  String toString() {
    return 'CheckoutCalculation(items: $itemCount, subtotal: $formattedSubtotal, total: $formattedTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CheckoutCalculation &&
      other.subtotal == subtotal &&
      other.tipAmount == tipAmount &&
      other.taxAmount == taxAmount &&
      other.discountAmount == discountAmount &&
      other.totalAmount == totalAmount &&
      other.itemCount == itemCount;
  }

  @override
  int get hashCode {
    return subtotal.hashCode ^
      tipAmount.hashCode ^
      taxAmount.hashCode ^
      discountAmount.hashCode ^
      totalAmount.hashCode ^
      itemCount.hashCode;
  }
}