// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  appointmentDate: DateTime.parse(json['appointmentDate'] as String),
  appointmentTime: json['appointmentTime'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  status: json['status'] as String? ?? 'scheduled',
  requestedTechnicianId: json['requestedTechnicianId'] as String?,
  assignedTechnicianId: json['assignedTechnicianId'] as String?,
  serviceIds: (json['serviceIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  notes: json['notes'] as String?,
  reminderSent: json['reminderSent'] as bool? ?? false,
  confirmationSent: json['confirmationSent'] as bool? ?? false,
  source: json['source'] as String? ?? 'pos',
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancellationReason: json['cancellationReason'] as String?,
  isGroupBooking: json['isGroupBooking'] as bool? ?? false,
  groupSize: (json['groupSize'] as num?)?.toInt() ?? 1,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  services: (json['services'] as List<dynamic>?)
      ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList(),
  requestedTechnicianName: json['requestedTechnicianName'] as String?,
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'appointmentTime': instance.appointmentTime,
      'durationMinutes': instance.durationMinutes,
      'status': instance.status,
      'requestedTechnicianId': instance.requestedTechnicianId,
      'assignedTechnicianId': instance.assignedTechnicianId,
      'serviceIds': instance.serviceIds,
      'notes': instance.notes,
      'reminderSent': instance.reminderSent,
      'confirmationSent': instance.confirmationSent,
      'source': instance.source,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'isGroupBooking': instance.isGroupBooking,
      'groupSize': instance.groupSize,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'customer': instance.customer,
      'services': instance.services,
      'requestedTechnicianName': instance.requestedTechnicianName,
    };
