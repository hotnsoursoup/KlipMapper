// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  ticketId: json['ticketId'] as String,
  paymentMethod: json['paymentMethod'] as String,
  amount: (json['amount'] as num).toDouble(),
  tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0.0,
  cardLastFour: json['cardLastFour'] as String?,
  cardType: json['cardType'] as String?,
  transactionId: json['transactionId'] as String?,
  status: json['status'] as String? ?? 'completed',
  refundAmount: (json['refundAmount'] as num?)?.toDouble(),
  refundReason: json['refundReason'] as String?,
  refundedAt: json['refundedAt'] == null
      ? null
      : DateTime.parse(json['refundedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'ticketId': instance.ticketId,
  'paymentMethod': instance.paymentMethod,
  'amount': instance.amount,
  'tipAmount': instance.tipAmount,
  'cardLastFour': instance.cardLastFour,
  'cardType': instance.cardType,
  'transactionId': instance.transactionId,
  'status': instance.status,
  'refundAmount': instance.refundAmount,
  'refundReason': instance.refundReason,
  'refundedAt': instance.refundedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};
