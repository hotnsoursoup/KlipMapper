// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceDomain _$ServiceDomainFromJson(Map<String, dynamic> json) =>
    _ServiceDomain(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      basePrice: (json['basePrice'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceDomainToJson(_ServiceDomain instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'durationMinutes': instance.durationMinutes,
      'basePrice': instance.basePrice,
      'categoryId': instance.categoryId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
