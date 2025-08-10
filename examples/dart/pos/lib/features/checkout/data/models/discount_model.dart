// lib/features/checkout/data/models/discount_model.dart
// Comprehensive discount model with percentage, fixed, and employee discount types.
// Includes validation, calculation logic, and predefined discount presets for common scenarios.
// Usage: ACTIVE - Primary discount system, checkout processing, and promotional campaigns

import 'package:json_annotation/json_annotation.dart';

part 'discount_model.g.dart';

@JsonSerializable()
class Discount {
  final String type; // 'percentage', 'fixed', 'employee'
  final double value; // percentage (0.0-1.0) or fixed amount
  final String? code; // discount code
  final String? reason; // reason for discount
  final int? authorizedBy; // employee ID who authorized
  final DateTime? expiresAt; // expiration date
  final double? maxAmount; // maximum discount amount for percentage discounts
  final double? minOrderAmount; // minimum order amount required

  const Discount({
    required this.type,
    required this.value,
    this.code,
    this.reason,
    this.authorizedBy,
    this.expiresAt,
    this.maxAmount,
    this.minOrderAmount,
  });

  /// Calculate discount amount based on subtotal
  double calculateAmount(double subtotal) {
    // Check minimum order requirement
    if (minOrderAmount != null && subtotal < minOrderAmount!) {
      return 0.0;
    }

    double discountAmount;
    
    switch (type) {
      case 'percentage':
        discountAmount = subtotal * value;
        // Apply maximum discount limit if specified
        if (maxAmount != null && discountAmount > maxAmount!) {
          discountAmount = maxAmount!;
        }
        break;
      case 'fixed':
        discountAmount = value;
        // Don't exceed the subtotal
        if (discountAmount > subtotal) {
          discountAmount = subtotal;
        }
        break;
      case 'employee':
        // Employee discount is typically a percentage
        discountAmount = subtotal * value;
        if (maxAmount != null && discountAmount > maxAmount!) {
          discountAmount = maxAmount!;
        }
        break;
      default:
        discountAmount = 0.0;
    }

    return discountAmount;
  }

  /// Check if discount is valid
  bool get isValid {
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) {
      return false;
    }
    return true;
  }

  /// Get display name for discount
  String get displayName {
    switch (type) {
      case 'percentage':
        return '${(value * 100).toStringAsFixed(0)}% Off';
      case 'fixed':
        return '\$${value.toStringAsFixed(2)} Off';
      case 'employee':
        return 'Employee Discount (${(value * 100).toStringAsFixed(0)}%)';
      default:
        return 'Discount';
    }
  }

  /// Get description for discount
  String get description {
    final parts = <String>[];
    
    if (code != null) {
      parts.add('Code: $code');
    }
    
    if (reason != null) {
      parts.add('Reason: $reason');
    }
    
    if (minOrderAmount != null) {
      parts.add('Min order: \$${minOrderAmount!.toStringAsFixed(2)}');
    }
    
    if (maxAmount != null && type == 'percentage') {
      parts.add('Max discount: \$${maxAmount!.toStringAsFixed(2)}');
    }
    
    return parts.join(' • ');
  }

  /// Predefined discount types
  static Discount percentage({
    required double percentage,
    String? code,
    String? reason,
    int? authorizedBy,
    double? maxAmount,
    double? minOrderAmount,
  }) {
    return Discount(
      type: 'percentage',
      value: percentage / 100, // Convert percentage to decimal
      code: code,
      reason: reason,
      authorizedBy: authorizedBy,
      maxAmount: maxAmount,
      minOrderAmount: minOrderAmount,
    );
  }

  static Discount fixed({
    required double amount,
    String? code,
    String? reason,
    int? authorizedBy,
    double? minOrderAmount,
  }) {
    return Discount(
      type: 'fixed',
      value: amount,
      code: code,
      reason: reason,
      authorizedBy: authorizedBy,
      minOrderAmount: minOrderAmount,
    );
  }

  static Discount employee({
    required double percentage,
    required int employeeId,
    String? reason,
    double? maxAmount,
  }) {
    return Discount(
      type: 'employee',
      value: percentage / 100, // Convert percentage to decimal
      reason: reason ?? 'Employee discount',
      authorizedBy: employeeId,
      maxAmount: maxAmount,
    );
  }

  /// Common discount presets
  static List<Discount> get commonDiscounts => [
    Discount.percentage(percentage: 5, reason: '5% Customer discount'),
    Discount.percentage(percentage: 10, reason: '10% Senior/Student discount'),
    Discount.percentage(percentage: 15, reason: '15% Loyalty discount'),
    Discount.percentage(percentage: 20, reason: '20% Special promotion'),
    Discount.fixed(amount: 5.0, reason: '\$5 off first visit'),
    Discount.fixed(amount: 10.0, reason: '\$10 off \$50+ order', minOrderAmount: 50.0),
    Discount.employee(percentage: 25, employeeId: 0, maxAmount: 50.0),
  ];

  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);

  Discount copyWith({
    String? type,
    double? value,
    String? code,
    String? reason,
    int? authorizedBy,
    DateTime? expiresAt,
    double? maxAmount,
    double? minOrderAmount,
  }) {
    return Discount(
      type: type ?? this.type,
      value: value ?? this.value,
      code: code ?? this.code,
      reason: reason ?? this.reason,
      authorizedBy: authorizedBy ?? this.authorizedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      maxAmount: maxAmount ?? this.maxAmount,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
    );
  }

  @override
  String toString() {
    return 'Discount(type: $type, value: $value, code: $code, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Discount &&
        other.type == type &&
        other.value == value &&
        other.code == code &&
        other.reason == reason &&
        other.authorizedBy == authorizedBy;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        value.hashCode ^
        (code?.hashCode ?? 0) ^
        (reason?.hashCode ?? 0) ^
        (authorizedBy?.hashCode ?? 0);
  }
}