// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Appointment {

 String get id; String get customerId; DateTime get appointmentDate; String get appointmentTime;// HH:mm format
 int get durationMinutes; String get status; String? get requestedTechnicianId; String? get assignedTechnicianId; List<String> get serviceIds; String? get notes; bool get reminderSent; bool get confirmationSent; String get source; DateTime? get cancelledAt; String? get cancellationReason; bool get isGroupBooking; int get groupSize; DateTime get createdAt; DateTime get updatedAt;// Populated objects (loaded from repository)
 Customer? get customer; List<Service>? get services; String? get requestedTechnicianName;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedTechnicianId, requestedTechnicianId) || other.requestedTechnicianId == requestedTechnicianId)&&(identical(other.assignedTechnicianId, assignedTechnicianId) || other.assignedTechnicianId == assignedTechnicianId)&&const DeepCollectionEquality().equals(other.serviceIds, serviceIds)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderSent, reminderSent) || other.reminderSent == reminderSent)&&(identical(other.confirmationSent, confirmationSent) || other.confirmationSent == confirmationSent)&&(identical(other.source, source) || other.source == source)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.isGroupBooking, isGroupBooking) || other.isGroupBooking == isGroupBooking)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.requestedTechnicianName, requestedTechnicianName) || other.requestedTechnicianName == requestedTechnicianName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,appointmentDate,appointmentTime,durationMinutes,status,requestedTechnicianId,assignedTechnicianId,const DeepCollectionEquality().hash(serviceIds),notes,reminderSent,confirmationSent,source,cancelledAt,cancellationReason,isGroupBooking,groupSize,createdAt,updatedAt,customer,const DeepCollectionEquality().hash(services),requestedTechnicianName]);

@override
String toString() {
  return 'Appointment(id: $id, customerId: $customerId, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, durationMinutes: $durationMinutes, status: $status, requestedTechnicianId: $requestedTechnicianId, assignedTechnicianId: $assignedTechnicianId, serviceIds: $serviceIds, notes: $notes, reminderSent: $reminderSent, confirmationSent: $confirmationSent, source: $source, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, isGroupBooking: $isGroupBooking, groupSize: $groupSize, createdAt: $createdAt, updatedAt: $updatedAt, customer: $customer, services: $services, requestedTechnicianName: $requestedTechnicianName)';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, DateTime appointmentDate, String appointmentTime, int durationMinutes, String status, String? requestedTechnicianId, String? assignedTechnicianId, List<String> serviceIds, String? notes, bool reminderSent, bool confirmationSent, String source, DateTime? cancelledAt, String? cancellationReason, bool isGroupBooking, int groupSize, DateTime createdAt, DateTime updatedAt, Customer? customer, List<Service>? services, String? requestedTechnicianName
});


$CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? appointmentDate = null,Object? appointmentTime = null,Object? durationMinutes = null,Object? status = null,Object? requestedTechnicianId = freezed,Object? assignedTechnicianId = freezed,Object? serviceIds = null,Object? notes = freezed,Object? reminderSent = null,Object? confirmationSent = null,Object? source = null,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? isGroupBooking = null,Object? groupSize = null,Object? createdAt = null,Object? updatedAt = null,Object? customer = freezed,Object? services = freezed,Object? requestedTechnicianName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,appointmentDate: null == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedTechnicianId: freezed == requestedTechnicianId ? _self.requestedTechnicianId : requestedTechnicianId // ignore: cast_nullable_to_non_nullable
as String?,assignedTechnicianId: freezed == assignedTechnicianId ? _self.assignedTechnicianId : assignedTechnicianId // ignore: cast_nullable_to_non_nullable
as String?,serviceIds: null == serviceIds ? _self.serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderSent: null == reminderSent ? _self.reminderSent : reminderSent // ignore: cast_nullable_to_non_nullable
as bool,confirmationSent: null == confirmationSent ? _self.confirmationSent : confirmationSent // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,isGroupBooking: null == isGroupBooking ? _self.isGroupBooking : isGroupBooking // ignore: cast_nullable_to_non_nullable
as bool,groupSize: null == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,services: freezed == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<Service>?,requestedTechnicianName: freezed == requestedTechnicianName ? _self.requestedTechnicianName : requestedTechnicianName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  DateTime appointmentDate,  String appointmentTime,  int durationMinutes,  String status,  String? requestedTechnicianId,  String? assignedTechnicianId,  List<String> serviceIds,  String? notes,  bool reminderSent,  bool confirmationSent,  String source,  DateTime? cancelledAt,  String? cancellationReason,  bool isGroupBooking,  int groupSize,  DateTime createdAt,  DateTime updatedAt,  Customer? customer,  List<Service>? services,  String? requestedTechnicianName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.customerId,_that.appointmentDate,_that.appointmentTime,_that.durationMinutes,_that.status,_that.requestedTechnicianId,_that.assignedTechnicianId,_that.serviceIds,_that.notes,_that.reminderSent,_that.confirmationSent,_that.source,_that.cancelledAt,_that.cancellationReason,_that.isGroupBooking,_that.groupSize,_that.createdAt,_that.updatedAt,_that.customer,_that.services,_that.requestedTechnicianName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  DateTime appointmentDate,  String appointmentTime,  int durationMinutes,  String status,  String? requestedTechnicianId,  String? assignedTechnicianId,  List<String> serviceIds,  String? notes,  bool reminderSent,  bool confirmationSent,  String source,  DateTime? cancelledAt,  String? cancellationReason,  bool isGroupBooking,  int groupSize,  DateTime createdAt,  DateTime updatedAt,  Customer? customer,  List<Service>? services,  String? requestedTechnicianName)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.customerId,_that.appointmentDate,_that.appointmentTime,_that.durationMinutes,_that.status,_that.requestedTechnicianId,_that.assignedTechnicianId,_that.serviceIds,_that.notes,_that.reminderSent,_that.confirmationSent,_that.source,_that.cancelledAt,_that.cancellationReason,_that.isGroupBooking,_that.groupSize,_that.createdAt,_that.updatedAt,_that.customer,_that.services,_that.requestedTechnicianName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  DateTime appointmentDate,  String appointmentTime,  int durationMinutes,  String status,  String? requestedTechnicianId,  String? assignedTechnicianId,  List<String> serviceIds,  String? notes,  bool reminderSent,  bool confirmationSent,  String source,  DateTime? cancelledAt,  String? cancellationReason,  bool isGroupBooking,  int groupSize,  DateTime createdAt,  DateTime updatedAt,  Customer? customer,  List<Service>? services,  String? requestedTechnicianName)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.customerId,_that.appointmentDate,_that.appointmentTime,_that.durationMinutes,_that.status,_that.requestedTechnicianId,_that.assignedTechnicianId,_that.serviceIds,_that.notes,_that.reminderSent,_that.confirmationSent,_that.source,_that.cancelledAt,_that.cancellationReason,_that.isGroupBooking,_that.groupSize,_that.createdAt,_that.updatedAt,_that.customer,_that.services,_that.requestedTechnicianName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment implements Appointment {
  const _Appointment({required this.id, required this.customerId, required this.appointmentDate, required this.appointmentTime, required this.durationMinutes, this.status = 'scheduled', this.requestedTechnicianId, this.assignedTechnicianId, required final  List<String> serviceIds, this.notes, this.reminderSent = false, this.confirmationSent = false, this.source = 'pos', this.cancelledAt, this.cancellationReason, this.isGroupBooking = false, this.groupSize = 1, required this.createdAt, required this.updatedAt, this.customer, final  List<Service>? services, this.requestedTechnicianName}): _serviceIds = serviceIds,_services = services;
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  DateTime appointmentDate;
@override final  String appointmentTime;
// HH:mm format
@override final  int durationMinutes;
@override@JsonKey() final  String status;
@override final  String? requestedTechnicianId;
@override final  String? assignedTechnicianId;
 final  List<String> _serviceIds;
@override List<String> get serviceIds {
  if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceIds);
}

@override final  String? notes;
@override@JsonKey() final  bool reminderSent;
@override@JsonKey() final  bool confirmationSent;
@override@JsonKey() final  String source;
@override final  DateTime? cancelledAt;
@override final  String? cancellationReason;
@override@JsonKey() final  bool isGroupBooking;
@override@JsonKey() final  int groupSize;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
// Populated objects (loaded from repository)
@override final  Customer? customer;
 final  List<Service>? _services;
@override List<Service>? get services {
  final value = _services;
  if (value == null) return null;
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? requestedTechnicianName;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedTechnicianId, requestedTechnicianId) || other.requestedTechnicianId == requestedTechnicianId)&&(identical(other.assignedTechnicianId, assignedTechnicianId) || other.assignedTechnicianId == assignedTechnicianId)&&const DeepCollectionEquality().equals(other._serviceIds, _serviceIds)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderSent, reminderSent) || other.reminderSent == reminderSent)&&(identical(other.confirmationSent, confirmationSent) || other.confirmationSent == confirmationSent)&&(identical(other.source, source) || other.source == source)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.isGroupBooking, isGroupBooking) || other.isGroupBooking == isGroupBooking)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.requestedTechnicianName, requestedTechnicianName) || other.requestedTechnicianName == requestedTechnicianName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,appointmentDate,appointmentTime,durationMinutes,status,requestedTechnicianId,assignedTechnicianId,const DeepCollectionEquality().hash(_serviceIds),notes,reminderSent,confirmationSent,source,cancelledAt,cancellationReason,isGroupBooking,groupSize,createdAt,updatedAt,customer,const DeepCollectionEquality().hash(_services),requestedTechnicianName]);

@override
String toString() {
  return 'Appointment(id: $id, customerId: $customerId, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, durationMinutes: $durationMinutes, status: $status, requestedTechnicianId: $requestedTechnicianId, assignedTechnicianId: $assignedTechnicianId, serviceIds: $serviceIds, notes: $notes, reminderSent: $reminderSent, confirmationSent: $confirmationSent, source: $source, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, isGroupBooking: $isGroupBooking, groupSize: $groupSize, createdAt: $createdAt, updatedAt: $updatedAt, customer: $customer, services: $services, requestedTechnicianName: $requestedTechnicianName)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, DateTime appointmentDate, String appointmentTime, int durationMinutes, String status, String? requestedTechnicianId, String? assignedTechnicianId, List<String> serviceIds, String? notes, bool reminderSent, bool confirmationSent, String source, DateTime? cancelledAt, String? cancellationReason, bool isGroupBooking, int groupSize, DateTime createdAt, DateTime updatedAt, Customer? customer, List<Service>? services, String? requestedTechnicianName
});


@override $CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? appointmentDate = null,Object? appointmentTime = null,Object? durationMinutes = null,Object? status = null,Object? requestedTechnicianId = freezed,Object? assignedTechnicianId = freezed,Object? serviceIds = null,Object? notes = freezed,Object? reminderSent = null,Object? confirmationSent = null,Object? source = null,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? isGroupBooking = null,Object? groupSize = null,Object? createdAt = null,Object? updatedAt = null,Object? customer = freezed,Object? services = freezed,Object? requestedTechnicianName = freezed,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,appointmentDate: null == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedTechnicianId: freezed == requestedTechnicianId ? _self.requestedTechnicianId : requestedTechnicianId // ignore: cast_nullable_to_non_nullable
as String?,assignedTechnicianId: freezed == assignedTechnicianId ? _self.assignedTechnicianId : assignedTechnicianId // ignore: cast_nullable_to_non_nullable
as String?,serviceIds: null == serviceIds ? _self._serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderSent: null == reminderSent ? _self.reminderSent : reminderSent // ignore: cast_nullable_to_non_nullable
as bool,confirmationSent: null == confirmationSent ? _self.confirmationSent : confirmationSent // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,isGroupBooking: null == isGroupBooking ? _self.isGroupBooking : isGroupBooking // ignore: cast_nullable_to_non_nullable
as bool,groupSize: null == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,services: freezed == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<Service>?,requestedTechnicianName: freezed == requestedTechnicianName ? _self.requestedTechnicianName : requestedTechnicianName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
