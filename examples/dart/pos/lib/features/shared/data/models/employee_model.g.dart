// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Employee _$EmployeeFromJson(Map<String, dynamic> json) => _Employee(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  socialSecurityNumber: json['socialSecurityNumber'] as String?,
  role: json['role'] as String,
  status: json['status'] as String? ?? 'active',
  locationId: json['locationId'] as String,
  username: json['username'] as String,
  pinHash: json['pinHash'] as String?,
  displayName: json['displayName'] as String?,
  commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
  isClockedIn: json['isClockedIn'] as bool? ?? false,
  lastClockIn: json['lastClockIn'] == null
      ? null
      : DateTime.parse(json['lastClockIn'] as String),
  lastClockOut: json['lastClockOut'] == null
      ? null
      : DateTime.parse(json['lastClockOut'] as String),
  hoursThisWeek: (json['hoursThisWeek'] as num?)?.toInt() ?? 0,
  hoursThisMonth: (json['hoursThisMonth'] as num?)?.toInt() ?? 0,
  departmentId: json['departmentId'] as String?,
  departmentName: json['departmentName'] as String?,
  canAcceptWalkins: json['canAcceptWalkins'] as bool? ?? true,
  canAcceptAppointments: json['canAcceptAppointments'] as bool? ?? true,
  profileImageUrl: json['profileImageUrl'] as String?,
  permissions: json['permissions'] as Map<String, dynamic>?,
  capabilities:
      (json['capabilities'] as List<dynamic>?)
          ?.map((e) => EmployeeCapability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  specializations:
      (json['specializations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EmployeeToJson(_Employee instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'socialSecurityNumber': instance.socialSecurityNumber,
  'role': instance.role,
  'status': instance.status,
  'locationId': instance.locationId,
  'username': instance.username,
  'pinHash': instance.pinHash,
  'displayName': instance.displayName,
  'commissionRate': instance.commissionRate,
  'isClockedIn': instance.isClockedIn,
  'lastClockIn': instance.lastClockIn?.toIso8601String(),
  'lastClockOut': instance.lastClockOut?.toIso8601String(),
  'hoursThisWeek': instance.hoursThisWeek,
  'hoursThisMonth': instance.hoursThisMonth,
  'departmentId': instance.departmentId,
  'departmentName': instance.departmentName,
  'canAcceptWalkins': instance.canAcceptWalkins,
  'canAcceptAppointments': instance.canAcceptAppointments,
  'profileImageUrl': instance.profileImageUrl,
  'permissions': instance.permissions,
  'capabilities': instance.capabilities,
  'specializations': instance.specializations,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
