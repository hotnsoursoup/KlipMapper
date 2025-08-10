// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => _TimeEntry(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  clockIn: DateTime.parse(json['clockIn'] as String),
  clockOut: json['clockOut'] == null
      ? null
      : DateTime.parse(json['clockOut'] as String),
  breakMinutes: (json['breakMinutes'] as num?)?.toInt() ?? 0,
  totalHours: (json['totalHours'] as num?)?.toDouble(),
  status: json['status'] as String? ?? 'active',
  editedBy: json['editedBy'] as String?,
  editReason: json['editReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TimeEntryToJson(_TimeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'clockIn': instance.clockIn.toIso8601String(),
      'clockOut': instance.clockOut?.toIso8601String(),
      'breakMinutes': instance.breakMinutes,
      'totalHours': instance.totalHours,
      'status': instance.status,
      'editedBy': instance.editedBy,
      'editReason': instance.editReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
