// lib/features/checkout/data/models/discount_data.dart
// Discount data model with percentage and fixed amount calculations for checkout processing.
// Includes technician authorization, validation, and discount amount computation logic.
// Usage: ACTIVE - Checkout discounts, manager authorization, and transaction adjustments

enum DiscountType { percentage, fixed }

class DiscountData {
  final String reason;
  final DiscountType type; // percentage or fixed
  final double value;
  final String technicianPin;
  final String technicianId;
  final DateTime appliedAt;

  const DiscountData({
    required this.reason,
    required this.type,
    required this.value,
    required this.technicianPin,
    required this.technicianId,
    required this.appliedAt,
  });

  DiscountData copyWith({
    String? reason,
    DiscountType? type,
    double? value,
    String? technicianPin,
    String? technicianId,
    DateTime? appliedAt,
  }) {
    return DiscountData(
      reason: reason ?? this.reason,
      type: type ?? this.type,
      value: value ?? this.value,
      technicianPin: technicianPin ?? this.technicianPin,
      technicianId: technicianId ?? this.technicianId,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  double calculateAmount(double subtotal) {
    switch (type) {
      case DiscountType.percentage:
        return subtotal * (value / 100);
      case DiscountType.fixed:
        return value.clamp(0, subtotal); // Don't exceed subtotal
    }
  }

  String get displayValue {
    switch (type) {
      case DiscountType.percentage:
        return '${value.toStringAsFixed(1)}%';
      case DiscountType.fixed:
        return '\$${value.toStringAsFixed(2)}';
    }
  }

  bool get isValid {
    return reason.trim().isNotEmpty && 
           value > 0 && 
           technicianPin.isNotEmpty &&
           technicianId.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'type': type.name,
      'value': value,
      'technicianPin': technicianPin,
      'technicianId': technicianId,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }

  factory DiscountData.fromJson(Map<String, dynamic> json) {
    return DiscountData(
      reason: json['reason'] as String,
      type: DiscountType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => DiscountType.percentage,
      ),
      value: (json['value'] as num).toDouble(),
      technicianPin: json['technicianPin'] as String,
      technicianId: json['technicianId'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'DiscountData(reason: $reason, type: $type, value: $displayValue, technicianId: $technicianId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is DiscountData &&
      other.reason == reason &&
      other.type == type &&
      other.value == value &&
      other.technicianPin == technicianPin &&
      other.technicianId == technicianId;
  }

  @override
  int get hashCode {
    return reason.hashCode ^
      type.hashCode ^
      value.hashCode ^
      technicianPin.hashCode ^
      technicianId.hashCode;
  }
}