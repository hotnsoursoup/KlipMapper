// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GiftCard _$GiftCardFromJson(Map<String, dynamic> json) => _GiftCard(
  id: json['id'] as String,
  code: json['code'] as String,
  initialBalance: (json['initialBalance'] as num).toDouble(),
  currentBalance: (json['currentBalance'] as num).toDouble(),
  customerId: json['customerId'] as String?,
  purchasedByCustomerId: json['purchasedByCustomerId'] as String?,
  status: json['status'] as String? ?? 'active',
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$GiftCardToJson(_GiftCard instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'initialBalance': instance.initialBalance,
  'currentBalance': instance.currentBalance,
  'customerId': instance.customerId,
  'purchasedByCustomerId': instance.purchasedByCustomerId,
  'status': instance.status,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_GiftCardTransaction _$GiftCardTransactionFromJson(Map<String, dynamic> json) =>
    _GiftCardTransaction(
      id: (json['id'] as num).toInt(),
      giftCardId: json['giftCardId'] as String,
      ticketId: json['ticketId'] as String?,
      transactionType: json['transactionType'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GiftCardTransactionToJson(
  _GiftCardTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'giftCardId': instance.giftCardId,
  'ticketId': instance.ticketId,
  'transactionType': instance.transactionType,
  'amount': instance.amount,
  'balanceAfter': instance.balanceAfter,
  'createdAt': instance.createdAt.toIso8601String(),
};
