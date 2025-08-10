// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceCategoryDomain _$ServiceCategoryDomainFromJson(
  Map<String, dynamic> json,
) => _ServiceCategoryDomain(
  id: json['id'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String? ?? '#6B7280',
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ServiceCategoryDomainToJson(
  _ServiceCategoryDomain instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'colorHex': instance.colorHex,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
