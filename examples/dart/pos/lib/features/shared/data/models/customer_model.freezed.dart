// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Customer {

 String get id; String get firstName; String get lastName; String? get email; String? get phone; String? get dateOfBirth; String? get gender; String? get address; String? get city; String? get state; String? get zipCode; int get loyaltyPoints; DateTime? get lastVisit; String? get preferredTechnician; String? get notes; String? get allergies; bool get emailOptIn; bool get smsOptIn; String get status; bool get isActive; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&(identical(other.preferredTechnician, preferredTechnician) || other.preferredTechnician == preferredTechnician)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.emailOptIn, emailOptIn) || other.emailOptIn == emailOptIn)&&(identical(other.smsOptIn, smsOptIn) || other.smsOptIn == smsOptIn)&&(identical(other.status, status) || other.status == status)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,email,phone,dateOfBirth,gender,address,city,state,zipCode,loyaltyPoints,lastVisit,preferredTechnician,notes,allergies,emailOptIn,smsOptIn,status,isActive,createdAt,updatedAt]);

@override
String toString() {
  return 'Customer(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, address: $address, city: $city, state: $state, zipCode: $zipCode, loyaltyPoints: $loyaltyPoints, lastVisit: $lastVisit, preferredTechnician: $preferredTechnician, notes: $notes, allergies: $allergies, emailOptIn: $emailOptIn, smsOptIn: $smsOptIn, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, String? email, String? phone, String? dateOfBirth, String? gender, String? address, String? city, String? state, String? zipCode, int loyaltyPoints, DateTime? lastVisit, String? preferredTechnician, String? notes, String? allergies, bool emailOptIn, bool smsOptIn, String status, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? zipCode = freezed,Object? loyaltyPoints = null,Object? lastVisit = freezed,Object? preferredTechnician = freezed,Object? notes = freezed,Object? allergies = freezed,Object? emailOptIn = null,Object? smsOptIn = null,Object? status = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,preferredTechnician: freezed == preferredTechnician ? _self.preferredTechnician : preferredTechnician // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,emailOptIn: null == emailOptIn ? _self.emailOptIn : emailOptIn // ignore: cast_nullable_to_non_nullable
as bool,smsOptIn: null == smsOptIn ? _self.smsOptIn : smsOptIn // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String? email,  String? phone,  String? dateOfBirth,  String? gender,  String? address,  String? city,  String? state,  String? zipCode,  int loyaltyPoints,  DateTime? lastVisit,  String? preferredTechnician,  String? notes,  String? allergies,  bool emailOptIn,  bool smsOptIn,  String status,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.address,_that.city,_that.state,_that.zipCode,_that.loyaltyPoints,_that.lastVisit,_that.preferredTechnician,_that.notes,_that.allergies,_that.emailOptIn,_that.smsOptIn,_that.status,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String? email,  String? phone,  String? dateOfBirth,  String? gender,  String? address,  String? city,  String? state,  String? zipCode,  int loyaltyPoints,  DateTime? lastVisit,  String? preferredTechnician,  String? notes,  String? allergies,  bool emailOptIn,  bool smsOptIn,  String status,  bool isActive,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.address,_that.city,_that.state,_that.zipCode,_that.loyaltyPoints,_that.lastVisit,_that.preferredTechnician,_that.notes,_that.allergies,_that.emailOptIn,_that.smsOptIn,_that.status,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  String? email,  String? phone,  String? dateOfBirth,  String? gender,  String? address,  String? city,  String? state,  String? zipCode,  int loyaltyPoints,  DateTime? lastVisit,  String? preferredTechnician,  String? notes,  String? allergies,  bool emailOptIn,  bool smsOptIn,  String status,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.address,_that.city,_that.state,_that.zipCode,_that.loyaltyPoints,_that.lastVisit,_that.preferredTechnician,_that.notes,_that.allergies,_that.emailOptIn,_that.smsOptIn,_that.status,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer extends Customer {
  const _Customer({required this.id, required this.firstName, required this.lastName, this.email, this.phone, this.dateOfBirth, this.gender, this.address, this.city, this.state, this.zipCode, this.loyaltyPoints = 0, this.lastVisit, this.preferredTechnician, this.notes, this.allergies, this.emailOptIn = false, this.smsOptIn = false, this.status = 'active', this.isActive = true, required this.createdAt, required this.updatedAt}): super._();
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  String lastName;
@override final  String? email;
@override final  String? phone;
@override final  String? dateOfBirth;
@override final  String? gender;
@override final  String? address;
@override final  String? city;
@override final  String? state;
@override final  String? zipCode;
@override@JsonKey() final  int loyaltyPoints;
@override final  DateTime? lastVisit;
@override final  String? preferredTechnician;
@override final  String? notes;
@override final  String? allergies;
@override@JsonKey() final  bool emailOptIn;
@override@JsonKey() final  bool smsOptIn;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.loyaltyPoints, loyaltyPoints) || other.loyaltyPoints == loyaltyPoints)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&(identical(other.preferredTechnician, preferredTechnician) || other.preferredTechnician == preferredTechnician)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.emailOptIn, emailOptIn) || other.emailOptIn == emailOptIn)&&(identical(other.smsOptIn, smsOptIn) || other.smsOptIn == smsOptIn)&&(identical(other.status, status) || other.status == status)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,email,phone,dateOfBirth,gender,address,city,state,zipCode,loyaltyPoints,lastVisit,preferredTechnician,notes,allergies,emailOptIn,smsOptIn,status,isActive,createdAt,updatedAt]);

@override
String toString() {
  return 'Customer(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, address: $address, city: $city, state: $state, zipCode: $zipCode, loyaltyPoints: $loyaltyPoints, lastVisit: $lastVisit, preferredTechnician: $preferredTechnician, notes: $notes, allergies: $allergies, emailOptIn: $emailOptIn, smsOptIn: $smsOptIn, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, String? email, String? phone, String? dateOfBirth, String? gender, String? address, String? city, String? state, String? zipCode, int loyaltyPoints, DateTime? lastVisit, String? preferredTechnician, String? notes, String? allergies, bool emailOptIn, bool smsOptIn, String status, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? zipCode = freezed,Object? loyaltyPoints = null,Object? lastVisit = freezed,Object? preferredTechnician = freezed,Object? notes = freezed,Object? allergies = freezed,Object? emailOptIn = null,Object? smsOptIn = null,Object? status = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,loyaltyPoints: null == loyaltyPoints ? _self.loyaltyPoints : loyaltyPoints // ignore: cast_nullable_to_non_nullable
as int,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,preferredTechnician: freezed == preferredTechnician ? _self.preferredTechnician : preferredTechnician // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,emailOptIn: null == emailOptIn ? _self.emailOptIn : emailOptIn // ignore: cast_nullable_to_non_nullable
as bool,smsOptIn: null == smsOptIn ? _self.smsOptIn : smsOptIn // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
