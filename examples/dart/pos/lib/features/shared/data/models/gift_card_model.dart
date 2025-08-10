// lib/features/shared/data/models/gift_card_model.dart
// Defines gift card and transaction models using Freezed for immutable data structures. 
// Includes business logic for gift card management, balance tracking, and transaction history.
// Usage: ACTIVE - Used for gift card sales, redemption tracking, and customer loyalty programs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gift_card_model.freezed.dart';
part 'gift_card_model.g.dart';

/// Gift card model
@freezed
class GiftCard with _$GiftCard {
  const factory GiftCard({
    required String id,
    required String code,
    required double initialBalance,
    required double currentBalance,
    String? customerId,
    String? purchasedByCustomerId,
    @Default('active') String status,
    DateTime? expiresAt,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}

/// Gift card transaction model
@freezed
class GiftCardTransaction with _$GiftCardTransaction {
  const factory GiftCardTransaction({
    required int id,
    required String giftCardId,
    String? ticketId,
    required String transactionType,
    required double amount,
    required double balanceAfter,
    required DateTime createdAt,
  }) = _GiftCardTransaction;

  factory GiftCardTransaction.fromJson(Map<String, dynamic> json) =>
      _$GiftCardTransactionFromJson(json);
}

/// Gift card status enum
enum GiftCardStatus {
  active,
  depleted,
  expired,
  voided, // 'void' is a reserved keyword
}

/// Gift card transaction type enum
enum GiftCardTransactionType {
  purchase,
  redeem,
  refund,
  voided, // 'void' is a reserved keyword
}
