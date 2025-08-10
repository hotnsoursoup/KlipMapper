// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
  type: json['type'] as String,
  value: (json['value'] as num).toDouble(),
  code: json['code'] as String?,
  reason: json['reason'] as String?,
  authorizedBy: (json['authorizedBy'] as num?)?.toInt(),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  maxAmount: (json['maxAmount'] as num?)?.toDouble(),
  minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
  'type': instance.type,
  'value': instance.value,
  'code': instance.code,
  'reason': instance.reason,
  'authorizedBy': instance.authorizedBy,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'maxAmount': instance.maxAmount,
  'minOrderAmount': instance.minOrderAmount,
};
