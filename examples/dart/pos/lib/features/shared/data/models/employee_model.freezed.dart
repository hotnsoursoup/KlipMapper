// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Employee {

 int get id; String get firstName; String get lastName; String get email; String get phone; String? get socialSecurityNumber;// Secure field - will be encrypted/protected
 String get role; String get status; String get locationId; String get username; String? get pinHash; String? get displayName; double get commissionRate; bool get isClockedIn; DateTime? get lastClockIn; DateTime? get lastClockOut; int get hoursThisWeek; int get hoursThisMonth; String? get departmentId; String? get departmentName; bool get canAcceptWalkins; bool get canAcceptAppointments; String? get profileImageUrl; Map<String, dynamic>? get permissions; List<EmployeeCapability> get capabilities; List<String> get specializations;// Service categories this employee specializes in
 DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeCopyWith<Employee> get copyWith => _$EmployeeCopyWithImpl<Employee>(this as Employee, _$identity);

  /// Serializes this Employee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Employee&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.socialSecurityNumber, socialSecurityNumber) || other.socialSecurityNumber == socialSecurityNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.username, username) || other.username == username)&&(identical(other.pinHash, pinHash) || other.pinHash == pinHash)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.isClockedIn, isClockedIn) || other.isClockedIn == isClockedIn)&&(identical(other.lastClockIn, lastClockIn) || other.lastClockIn == lastClockIn)&&(identical(other.lastClockOut, lastClockOut) || other.lastClockOut == lastClockOut)&&(identical(other.hoursThisWeek, hoursThisWeek) || other.hoursThisWeek == hoursThisWeek)&&(identical(other.hoursThisMonth, hoursThisMonth) || other.hoursThisMonth == hoursThisMonth)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.canAcceptWalkins, canAcceptWalkins) || other.canAcceptWalkins == canAcceptWalkins)&&(identical(other.canAcceptAppointments, canAcceptAppointments) || other.canAcceptAppointments == canAcceptAppointments)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&const DeepCollectionEquality().equals(other.capabilities, capabilities)&&const DeepCollectionEquality().equals(other.specializations, specializations)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,email,phone,socialSecurityNumber,role,status,locationId,username,pinHash,displayName,commissionRate,isClockedIn,lastClockIn,lastClockOut,hoursThisWeek,hoursThisMonth,departmentId,departmentName,canAcceptWalkins,canAcceptAppointments,profileImageUrl,const DeepCollectionEquality().hash(permissions),const DeepCollectionEquality().hash(capabilities),const DeepCollectionEquality().hash(specializations),createdAt,updatedAt]);

@override
String toString() {
  return 'Employee(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, socialSecurityNumber: $socialSecurityNumber, role: $role, status: $status, locationId: $locationId, username: $username, pinHash: $pinHash, displayName: $displayName, commissionRate: $commissionRate, isClockedIn: $isClockedIn, lastClockIn: $lastClockIn, lastClockOut: $lastClockOut, hoursThisWeek: $hoursThisWeek, hoursThisMonth: $hoursThisMonth, departmentId: $departmentId, departmentName: $departmentName, canAcceptWalkins: $canAcceptWalkins, canAcceptAppointments: $canAcceptAppointments, profileImageUrl: $profileImageUrl, permissions: $permissions, capabilities: $capabilities, specializations: $specializations, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EmployeeCopyWith<$Res>  {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) _then) = _$EmployeeCopyWithImpl;
@useResult
$Res call({
 int id, String firstName, String lastName, String email, String phone, String? socialSecurityNumber, String role, String status, String locationId, String username, String? pinHash, String? displayName, double commissionRate, bool isClockedIn, DateTime? lastClockIn, DateTime? lastClockOut, int hoursThisWeek, int hoursThisMonth, String? departmentId, String? departmentName, bool canAcceptWalkins, bool canAcceptAppointments, String? profileImageUrl, Map<String, dynamic>? permissions, List<EmployeeCapability> capabilities, List<String> specializations, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$EmployeeCopyWithImpl<$Res>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._self, this._then);

  final Employee _self;
  final $Res Function(Employee) _then;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = null,Object? socialSecurityNumber = freezed,Object? role = null,Object? status = null,Object? locationId = null,Object? username = null,Object? pinHash = freezed,Object? displayName = freezed,Object? commissionRate = null,Object? isClockedIn = null,Object? lastClockIn = freezed,Object? lastClockOut = freezed,Object? hoursThisWeek = null,Object? hoursThisMonth = null,Object? departmentId = freezed,Object? departmentName = freezed,Object? canAcceptWalkins = null,Object? canAcceptAppointments = null,Object? profileImageUrl = freezed,Object? permissions = freezed,Object? capabilities = null,Object? specializations = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,socialSecurityNumber: freezed == socialSecurityNumber ? _self.socialSecurityNumber : socialSecurityNumber // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,pinHash: freezed == pinHash ? _self.pinHash : pinHash // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,isClockedIn: null == isClockedIn ? _self.isClockedIn : isClockedIn // ignore: cast_nullable_to_non_nullable
as bool,lastClockIn: freezed == lastClockIn ? _self.lastClockIn : lastClockIn // ignore: cast_nullable_to_non_nullable
as DateTime?,lastClockOut: freezed == lastClockOut ? _self.lastClockOut : lastClockOut // ignore: cast_nullable_to_non_nullable
as DateTime?,hoursThisWeek: null == hoursThisWeek ? _self.hoursThisWeek : hoursThisWeek // ignore: cast_nullable_to_non_nullable
as int,hoursThisMonth: null == hoursThisMonth ? _self.hoursThisMonth : hoursThisMonth // ignore: cast_nullable_to_non_nullable
as int,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,canAcceptWalkins: null == canAcceptWalkins ? _self.canAcceptWalkins : canAcceptWalkins // ignore: cast_nullable_to_non_nullable
as bool,canAcceptAppointments: null == canAcceptAppointments ? _self.canAcceptAppointments : canAcceptAppointments // ignore: cast_nullable_to_non_nullable
as bool,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<EmployeeCapability>,specializations: null == specializations ? _self.specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Employee].
extension EmployeePatterns on Employee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Employee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Employee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Employee value)  $default,){
final _that = this;
switch (_that) {
case _Employee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Employee value)?  $default,){
final _that = this;
switch (_that) {
case _Employee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String email,  String phone,  String? socialSecurityNumber,  String role,  String status,  String locationId,  String username,  String? pinHash,  String? displayName,  double commissionRate,  bool isClockedIn,  DateTime? lastClockIn,  DateTime? lastClockOut,  int hoursThisWeek,  int hoursThisMonth,  String? departmentId,  String? departmentName,  bool canAcceptWalkins,  bool canAcceptAppointments,  String? profileImageUrl,  Map<String, dynamic>? permissions,  List<EmployeeCapability> capabilities,  List<String> specializations,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Employee() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.socialSecurityNumber,_that.role,_that.status,_that.locationId,_that.username,_that.pinHash,_that.displayName,_that.commissionRate,_that.isClockedIn,_that.lastClockIn,_that.lastClockOut,_that.hoursThisWeek,_that.hoursThisMonth,_that.departmentId,_that.departmentName,_that.canAcceptWalkins,_that.canAcceptAppointments,_that.profileImageUrl,_that.permissions,_that.capabilities,_that.specializations,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String email,  String phone,  String? socialSecurityNumber,  String role,  String status,  String locationId,  String username,  String? pinHash,  String? displayName,  double commissionRate,  bool isClockedIn,  DateTime? lastClockIn,  DateTime? lastClockOut,  int hoursThisWeek,  int hoursThisMonth,  String? departmentId,  String? departmentName,  bool canAcceptWalkins,  bool canAcceptAppointments,  String? profileImageUrl,  Map<String, dynamic>? permissions,  List<EmployeeCapability> capabilities,  List<String> specializations,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Employee():
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.socialSecurityNumber,_that.role,_that.status,_that.locationId,_that.username,_that.pinHash,_that.displayName,_that.commissionRate,_that.isClockedIn,_that.lastClockIn,_that.lastClockOut,_that.hoursThisWeek,_that.hoursThisMonth,_that.departmentId,_that.departmentName,_that.canAcceptWalkins,_that.canAcceptAppointments,_that.profileImageUrl,_that.permissions,_that.capabilities,_that.specializations,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String firstName,  String lastName,  String email,  String phone,  String? socialSecurityNumber,  String role,  String status,  String locationId,  String username,  String? pinHash,  String? displayName,  double commissionRate,  bool isClockedIn,  DateTime? lastClockIn,  DateTime? lastClockOut,  int hoursThisWeek,  int hoursThisMonth,  String? departmentId,  String? departmentName,  bool canAcceptWalkins,  bool canAcceptAppointments,  String? profileImageUrl,  Map<String, dynamic>? permissions,  List<EmployeeCapability> capabilities,  List<String> specializations,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Employee() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.socialSecurityNumber,_that.role,_that.status,_that.locationId,_that.username,_that.pinHash,_that.displayName,_that.commissionRate,_that.isClockedIn,_that.lastClockIn,_that.lastClockOut,_that.hoursThisWeek,_that.hoursThisMonth,_that.departmentId,_that.departmentName,_that.canAcceptWalkins,_that.canAcceptAppointments,_that.profileImageUrl,_that.permissions,_that.capabilities,_that.specializations,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Employee implements Employee {
  const _Employee({required this.id, required this.firstName, required this.lastName, required this.email, required this.phone, this.socialSecurityNumber, required this.role, this.status = 'active', required this.locationId, required this.username, this.pinHash, this.displayName, this.commissionRate = 0.0, this.isClockedIn = false, this.lastClockIn, this.lastClockOut, this.hoursThisWeek = 0, this.hoursThisMonth = 0, this.departmentId, this.departmentName, this.canAcceptWalkins = true, this.canAcceptAppointments = true, this.profileImageUrl, final  Map<String, dynamic>? permissions, final  List<EmployeeCapability> capabilities = const [], final  List<String> specializations = const [], required this.createdAt, required this.updatedAt}): _permissions = permissions,_capabilities = capabilities,_specializations = specializations;
  factory _Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

@override final  int id;
@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  String phone;
@override final  String? socialSecurityNumber;
// Secure field - will be encrypted/protected
@override final  String role;
@override@JsonKey() final  String status;
@override final  String locationId;
@override final  String username;
@override final  String? pinHash;
@override final  String? displayName;
@override@JsonKey() final  double commissionRate;
@override@JsonKey() final  bool isClockedIn;
@override final  DateTime? lastClockIn;
@override final  DateTime? lastClockOut;
@override@JsonKey() final  int hoursThisWeek;
@override@JsonKey() final  int hoursThisMonth;
@override final  String? departmentId;
@override final  String? departmentName;
@override@JsonKey() final  bool canAcceptWalkins;
@override@JsonKey() final  bool canAcceptAppointments;
@override final  String? profileImageUrl;
 final  Map<String, dynamic>? _permissions;
@override Map<String, dynamic>? get permissions {
  final value = _permissions;
  if (value == null) return null;
  if (_permissions is EqualUnmodifiableMapView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<EmployeeCapability> _capabilities;
@override@JsonKey() List<EmployeeCapability> get capabilities {
  if (_capabilities is EqualUnmodifiableListView) return _capabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_capabilities);
}

 final  List<String> _specializations;
@override@JsonKey() List<String> get specializations {
  if (_specializations is EqualUnmodifiableListView) return _specializations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specializations);
}

// Service categories this employee specializes in
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeCopyWith<_Employee> get copyWith => __$EmployeeCopyWithImpl<_Employee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Employee&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.socialSecurityNumber, socialSecurityNumber) || other.socialSecurityNumber == socialSecurityNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.username, username) || other.username == username)&&(identical(other.pinHash, pinHash) || other.pinHash == pinHash)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.isClockedIn, isClockedIn) || other.isClockedIn == isClockedIn)&&(identical(other.lastClockIn, lastClockIn) || other.lastClockIn == lastClockIn)&&(identical(other.lastClockOut, lastClockOut) || other.lastClockOut == lastClockOut)&&(identical(other.hoursThisWeek, hoursThisWeek) || other.hoursThisWeek == hoursThisWeek)&&(identical(other.hoursThisMonth, hoursThisMonth) || other.hoursThisMonth == hoursThisMonth)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.canAcceptWalkins, canAcceptWalkins) || other.canAcceptWalkins == canAcceptWalkins)&&(identical(other.canAcceptAppointments, canAcceptAppointments) || other.canAcceptAppointments == canAcceptAppointments)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&const DeepCollectionEquality().equals(other._capabilities, _capabilities)&&const DeepCollectionEquality().equals(other._specializations, _specializations)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,email,phone,socialSecurityNumber,role,status,locationId,username,pinHash,displayName,commissionRate,isClockedIn,lastClockIn,lastClockOut,hoursThisWeek,hoursThisMonth,departmentId,departmentName,canAcceptWalkins,canAcceptAppointments,profileImageUrl,const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_capabilities),const DeepCollectionEquality().hash(_specializations),createdAt,updatedAt]);

@override
String toString() {
  return 'Employee(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, socialSecurityNumber: $socialSecurityNumber, role: $role, status: $status, locationId: $locationId, username: $username, pinHash: $pinHash, displayName: $displayName, commissionRate: $commissionRate, isClockedIn: $isClockedIn, lastClockIn: $lastClockIn, lastClockOut: $lastClockOut, hoursThisWeek: $hoursThisWeek, hoursThisMonth: $hoursThisMonth, departmentId: $departmentId, departmentName: $departmentName, canAcceptWalkins: $canAcceptWalkins, canAcceptAppointments: $canAcceptAppointments, profileImageUrl: $profileImageUrl, permissions: $permissions, capabilities: $capabilities, specializations: $specializations, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EmployeeCopyWith<$Res> implements $EmployeeCopyWith<$Res> {
  factory _$EmployeeCopyWith(_Employee value, $Res Function(_Employee) _then) = __$EmployeeCopyWithImpl;
@override @useResult
$Res call({
 int id, String firstName, String lastName, String email, String phone, String? socialSecurityNumber, String role, String status, String locationId, String username, String? pinHash, String? displayName, double commissionRate, bool isClockedIn, DateTime? lastClockIn, DateTime? lastClockOut, int hoursThisWeek, int hoursThisMonth, String? departmentId, String? departmentName, bool canAcceptWalkins, bool canAcceptAppointments, String? profileImageUrl, Map<String, dynamic>? permissions, List<EmployeeCapability> capabilities, List<String> specializations, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$EmployeeCopyWithImpl<$Res>
    implements _$EmployeeCopyWith<$Res> {
  __$EmployeeCopyWithImpl(this._self, this._then);

  final _Employee _self;
  final $Res Function(_Employee) _then;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = null,Object? socialSecurityNumber = freezed,Object? role = null,Object? status = null,Object? locationId = null,Object? username = null,Object? pinHash = freezed,Object? displayName = freezed,Object? commissionRate = null,Object? isClockedIn = null,Object? lastClockIn = freezed,Object? lastClockOut = freezed,Object? hoursThisWeek = null,Object? hoursThisMonth = null,Object? departmentId = freezed,Object? departmentName = freezed,Object? canAcceptWalkins = null,Object? canAcceptAppointments = null,Object? profileImageUrl = freezed,Object? permissions = freezed,Object? capabilities = null,Object? specializations = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Employee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,socialSecurityNumber: freezed == socialSecurityNumber ? _self.socialSecurityNumber : socialSecurityNumber // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,pinHash: freezed == pinHash ? _self.pinHash : pinHash // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,isClockedIn: null == isClockedIn ? _self.isClockedIn : isClockedIn // ignore: cast_nullable_to_non_nullable
as bool,lastClockIn: freezed == lastClockIn ? _self.lastClockIn : lastClockIn // ignore: cast_nullable_to_non_nullable
as DateTime?,lastClockOut: freezed == lastClockOut ? _self.lastClockOut : lastClockOut // ignore: cast_nullable_to_non_nullable
as DateTime?,hoursThisWeek: null == hoursThisWeek ? _self.hoursThisWeek : hoursThisWeek // ignore: cast_nullable_to_non_nullable
as int,hoursThisMonth: null == hoursThisMonth ? _self.hoursThisMonth : hoursThisMonth // ignore: cast_nullable_to_non_nullable
as int,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,canAcceptWalkins: null == canAcceptWalkins ? _self.canAcceptWalkins : canAcceptWalkins // ignore: cast_nullable_to_non_nullable
as bool,canAcceptAppointments: null == canAcceptAppointments ? _self.canAcceptAppointments : canAcceptAppointments // ignore: cast_nullable_to_non_nullable
as bool,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,permissions: freezed == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,capabilities: null == capabilities ? _self._capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<EmployeeCapability>,specializations: null == specializations ? _self._specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
