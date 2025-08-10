// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  gender: json['gender'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  zipCode: json['zipCode'] as String?,
  loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt() ?? 0,
  lastVisit: json['lastVisit'] == null
      ? null
      : DateTime.parse(json['lastVisit'] as String),
  preferredTechnician: json['preferredTechnician'] as String?,
  notes: json['notes'] as String?,
  allergies: json['allergies'] as String?,
  emailOptIn: json['emailOptIn'] as bool? ?? false,
  smsOptIn: json['smsOptIn'] as bool? ?? false,
  status: json['status'] as String? ?? 'active',
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'dateOfBirth': instance.dateOfBirth,
  'gender': instance.gender,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
  'loyaltyPoints': instance.loyaltyPoints,
  'lastVisit': instance.lastVisit?.toIso8601String(),
  'preferredTechnician': instance.preferredTechnician,
  'notes': instance.notes,
  'allergies': instance.allergies,
  'emailOptIn': instance.emailOptIn,
  'smsOptIn': instance.smsOptIn,
  'status': instance.status,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
