// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreSetting _$StoreSettingFromJson(Map<String, dynamic> json) =>
    _StoreSetting(
      key: json['key'] as String,
      value: json['value'] as String,
      category: json['category'] as String?,
      dataType: json['dataType'] as String?,
      description: json['description'] as String?,
      isSystem: json['isSystem'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StoreSettingToJson(_StoreSetting instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'category': instance.category,
      'dataType': instance.dataType,
      'description': instance.description,
      'isSystem': instance.isSystem,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_StoreHours _$StoreHoursFromJson(Map<String, dynamic> json) => _StoreHours(
  hours:
      (json['hours'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, DayHours.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
);

Map<String, dynamic> _$StoreHoursToJson(_StoreHours instance) =>
    <String, dynamic>{'hours': instance.hours};

_DayHours _$DayHoursFromJson(Map<String, dynamic> json) => _DayHours(
  isOpen: json['isOpen'] as bool? ?? false,
  openTime: (json['openTime'] as num?)?.toInt(),
  closeTime: (json['closeTime'] as num?)?.toInt(),
);

Map<String, dynamic> _$DayHoursToJson(_DayHours instance) => <String, dynamic>{
  'isOpen': instance.isOpen,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
};
