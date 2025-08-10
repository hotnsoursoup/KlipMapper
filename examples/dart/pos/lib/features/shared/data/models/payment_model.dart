// lib/features/shared/data/models/payment_model.dart
// Freezed payment data model with tip handling, refund support, and transaction tracking for financial operations.
// Usage: ACTIVE - Core payment data model used in checkout and financial reporting systems
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment model
@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String ticketId,
    required String paymentMethod,
    required double amount,
    @Default(0.0) double tipAmount,
    String? cardLastFour,
    String? cardType,
    String? transactionId,
    @Default('completed') String status,
    double? refundAmount,
    String? refundReason,
    DateTime? refundedAt,
    required DateTime createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Payment method enum
enum PaymentMethod {
  cash,
  card,
  check,
  giftCard,
  other,
}

/// Payment status enum
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

extension PaymentMethodX on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.check:
        return 'check';
      case PaymentMethod.giftCard:
        return 'gift_card';
      case PaymentMethod.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.giftCard:
        return 'Gift Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'cash':
        return PaymentMethod.cash;
      case 'card':
        return PaymentMethod.card;
      case 'check':
        return PaymentMethod.check;
      case 'gift_card':
        return PaymentMethod.giftCard;
      case 'other':
        return PaymentMethod.other;
      default:
        return PaymentMethod.cash;
    }
  }
}
