// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_status_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmployeeStatusState implements DiagnosticableTreeMixin {

 Map<String, EmployeeState> get employeeStates; Map<String, String?> get currentTickets; String? get errorMessage; DateTime? get lastUpdated;
/// Create a copy of EmployeeStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeStatusStateCopyWith<EmployeeStatusState> get copyWith => _$EmployeeStatusStateCopyWithImpl<EmployeeStatusState>(this as EmployeeStatusState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeStatusState'))
    ..add(DiagnosticsProperty('employeeStates', employeeStates))..add(DiagnosticsProperty('currentTickets', currentTickets))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('lastUpdated', lastUpdated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeStatusState&&const DeepCollectionEquality().equals(other.employeeStates, employeeStates)&&const DeepCollectionEquality().equals(other.currentTickets, currentTickets)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(employeeStates),const DeepCollectionEquality().hash(currentTickets),errorMessage,lastUpdated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeStatusState(employeeStates: $employeeStates, currentTickets: $currentTickets, errorMessage: $errorMessage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $EmployeeStatusStateCopyWith<$Res>  {
  factory $EmployeeStatusStateCopyWith(EmployeeStatusState value, $Res Function(EmployeeStatusState) _then) = _$EmployeeStatusStateCopyWithImpl;
@useResult
$Res call({
 Map<String, EmployeeState> employeeStates, Map<String, String?> currentTickets, String? errorMessage, DateTime? lastUpdated
});




}
/// @nodoc
class _$EmployeeStatusStateCopyWithImpl<$Res>
    implements $EmployeeStatusStateCopyWith<$Res> {
  _$EmployeeStatusStateCopyWithImpl(this._self, this._then);

  final EmployeeStatusState _self;
  final $Res Function(EmployeeStatusState) _then;

/// Create a copy of EmployeeStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeStates = null,Object? currentTickets = null,Object? errorMessage = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
employeeStates: null == employeeStates ? _self.employeeStates : employeeStates // ignore: cast_nullable_to_non_nullable
as Map<String, EmployeeState>,currentTickets: null == currentTickets ? _self.currentTickets : currentTickets // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeStatusState].
extension EmployeeStatusStatePatterns on EmployeeStatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeStatusState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeStatusState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeStatusState value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeStatusState value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, EmployeeState> employeeStates,  Map<String, String?> currentTickets,  String? errorMessage,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeStatusState() when $default != null:
return $default(_that.employeeStates,_that.currentTickets,_that.errorMessage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, EmployeeState> employeeStates,  Map<String, String?> currentTickets,  String? errorMessage,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusState():
return $default(_that.employeeStates,_that.currentTickets,_that.errorMessage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, EmployeeState> employeeStates,  Map<String, String?> currentTickets,  String? errorMessage,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusState() when $default != null:
return $default(_that.employeeStates,_that.currentTickets,_that.errorMessage,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeStatusState with DiagnosticableTreeMixin implements EmployeeStatusState {
  const _EmployeeStatusState({final  Map<String, EmployeeState> employeeStates = const {}, final  Map<String, String?> currentTickets = const {}, this.errorMessage, this.lastUpdated}): _employeeStates = employeeStates,_currentTickets = currentTickets;
  

 final  Map<String, EmployeeState> _employeeStates;
@override@JsonKey() Map<String, EmployeeState> get employeeStates {
  if (_employeeStates is EqualUnmodifiableMapView) return _employeeStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_employeeStates);
}

 final  Map<String, String?> _currentTickets;
@override@JsonKey() Map<String, String?> get currentTickets {
  if (_currentTickets is EqualUnmodifiableMapView) return _currentTickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currentTickets);
}

@override final  String? errorMessage;
@override final  DateTime? lastUpdated;

/// Create a copy of EmployeeStatusState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeStatusStateCopyWith<_EmployeeStatusState> get copyWith => __$EmployeeStatusStateCopyWithImpl<_EmployeeStatusState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeStatusState'))
    ..add(DiagnosticsProperty('employeeStates', employeeStates))..add(DiagnosticsProperty('currentTickets', currentTickets))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('lastUpdated', lastUpdated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeStatusState&&const DeepCollectionEquality().equals(other._employeeStates, _employeeStates)&&const DeepCollectionEquality().equals(other._currentTickets, _currentTickets)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_employeeStates),const DeepCollectionEquality().hash(_currentTickets),errorMessage,lastUpdated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeStatusState(employeeStates: $employeeStates, currentTickets: $currentTickets, errorMessage: $errorMessage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$EmployeeStatusStateCopyWith<$Res> implements $EmployeeStatusStateCopyWith<$Res> {
  factory _$EmployeeStatusStateCopyWith(_EmployeeStatusState value, $Res Function(_EmployeeStatusState) _then) = __$EmployeeStatusStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, EmployeeState> employeeStates, Map<String, String?> currentTickets, String? errorMessage, DateTime? lastUpdated
});




}
/// @nodoc
class __$EmployeeStatusStateCopyWithImpl<$Res>
    implements _$EmployeeStatusStateCopyWith<$Res> {
  __$EmployeeStatusStateCopyWithImpl(this._self, this._then);

  final _EmployeeStatusState _self;
  final $Res Function(_EmployeeStatusState) _then;

/// Create a copy of EmployeeStatusState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeStates = null,Object? currentTickets = null,Object? errorMessage = freezed,Object? lastUpdated = freezed,}) {
  return _then(_EmployeeStatusState(
employeeStates: null == employeeStates ? _self._employeeStates : employeeStates // ignore: cast_nullable_to_non_nullable
as Map<String, EmployeeState>,currentTickets: null == currentTickets ? _self._currentTickets : currentTickets // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$EmployeeState implements DiagnosticableTreeMixin {

 Technician get employee;// Using Technician model for dashboard representation
 String get status;// 'available', 'assigned', 'busy', 'off'
 String? get currentTicketId; bool get isOff; List<String> get specializations; DateTime get lastUpdated;
/// Create a copy of EmployeeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeStateCopyWith<EmployeeState> get copyWith => _$EmployeeStateCopyWithImpl<EmployeeState>(this as EmployeeState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeState'))
    ..add(DiagnosticsProperty('employee', employee))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('currentTicketId', currentTicketId))..add(DiagnosticsProperty('isOff', isOff))..add(DiagnosticsProperty('specializations', specializations))..add(DiagnosticsProperty('lastUpdated', lastUpdated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeState&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentTicketId, currentTicketId) || other.currentTicketId == currentTicketId)&&(identical(other.isOff, isOff) || other.isOff == isOff)&&const DeepCollectionEquality().equals(other.specializations, specializations)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,employee,status,currentTicketId,isOff,const DeepCollectionEquality().hash(specializations),lastUpdated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeState(employee: $employee, status: $status, currentTicketId: $currentTicketId, isOff: $isOff, specializations: $specializations, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $EmployeeStateCopyWith<$Res>  {
  factory $EmployeeStateCopyWith(EmployeeState value, $Res Function(EmployeeState) _then) = _$EmployeeStateCopyWithImpl;
@useResult
$Res call({
 Technician employee, String status, String? currentTicketId, bool isOff, List<String> specializations, DateTime lastUpdated
});




}
/// @nodoc
class _$EmployeeStateCopyWithImpl<$Res>
    implements $EmployeeStateCopyWith<$Res> {
  _$EmployeeStateCopyWithImpl(this._self, this._then);

  final EmployeeState _self;
  final $Res Function(EmployeeState) _then;

/// Create a copy of EmployeeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employee = null,Object? status = null,Object? currentTicketId = freezed,Object? isOff = null,Object? specializations = null,Object? lastUpdated = null,}) {
  return _then(_self.copyWith(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as Technician,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentTicketId: freezed == currentTicketId ? _self.currentTicketId : currentTicketId // ignore: cast_nullable_to_non_nullable
as String?,isOff: null == isOff ? _self.isOff : isOff // ignore: cast_nullable_to_non_nullable
as bool,specializations: null == specializations ? _self.specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeState].
extension EmployeeStatePatterns on EmployeeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeState value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeState value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Technician employee,  String status,  String? currentTicketId,  bool isOff,  List<String> specializations,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeState() when $default != null:
return $default(_that.employee,_that.status,_that.currentTicketId,_that.isOff,_that.specializations,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Technician employee,  String status,  String? currentTicketId,  bool isOff,  List<String> specializations,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _EmployeeState():
return $default(_that.employee,_that.status,_that.currentTicketId,_that.isOff,_that.specializations,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Technician employee,  String status,  String? currentTicketId,  bool isOff,  List<String> specializations,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeState() when $default != null:
return $default(_that.employee,_that.status,_that.currentTicketId,_that.isOff,_that.specializations,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeState extends EmployeeState with DiagnosticableTreeMixin {
  const _EmployeeState({required this.employee, required this.status, this.currentTicketId, this.isOff = false, final  List<String> specializations = const [], required this.lastUpdated}): _specializations = specializations,super._();
  

@override final  Technician employee;
// Using Technician model for dashboard representation
@override final  String status;
// 'available', 'assigned', 'busy', 'off'
@override final  String? currentTicketId;
@override@JsonKey() final  bool isOff;
 final  List<String> _specializations;
@override@JsonKey() List<String> get specializations {
  if (_specializations is EqualUnmodifiableListView) return _specializations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specializations);
}

@override final  DateTime lastUpdated;

/// Create a copy of EmployeeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeStateCopyWith<_EmployeeState> get copyWith => __$EmployeeStateCopyWithImpl<_EmployeeState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeState'))
    ..add(DiagnosticsProperty('employee', employee))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('currentTicketId', currentTicketId))..add(DiagnosticsProperty('isOff', isOff))..add(DiagnosticsProperty('specializations', specializations))..add(DiagnosticsProperty('lastUpdated', lastUpdated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeState&&(identical(other.employee, employee) || other.employee == employee)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentTicketId, currentTicketId) || other.currentTicketId == currentTicketId)&&(identical(other.isOff, isOff) || other.isOff == isOff)&&const DeepCollectionEquality().equals(other._specializations, _specializations)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,employee,status,currentTicketId,isOff,const DeepCollectionEquality().hash(_specializations),lastUpdated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeState(employee: $employee, status: $status, currentTicketId: $currentTicketId, isOff: $isOff, specializations: $specializations, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$EmployeeStateCopyWith<$Res> implements $EmployeeStateCopyWith<$Res> {
  factory _$EmployeeStateCopyWith(_EmployeeState value, $Res Function(_EmployeeState) _then) = __$EmployeeStateCopyWithImpl;
@override @useResult
$Res call({
 Technician employee, String status, String? currentTicketId, bool isOff, List<String> specializations, DateTime lastUpdated
});




}
/// @nodoc
class __$EmployeeStateCopyWithImpl<$Res>
    implements _$EmployeeStateCopyWith<$Res> {
  __$EmployeeStateCopyWithImpl(this._self, this._then);

  final _EmployeeState _self;
  final $Res Function(_EmployeeState) _then;

/// Create a copy of EmployeeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employee = null,Object? status = null,Object? currentTicketId = freezed,Object? isOff = null,Object? specializations = null,Object? lastUpdated = null,}) {
  return _then(_EmployeeState(
employee: null == employee ? _self.employee : employee // ignore: cast_nullable_to_non_nullable
as Technician,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentTicketId: freezed == currentTicketId ? _self.currentTicketId : currentTicketId // ignore: cast_nullable_to_non_nullable
as String?,isOff: null == isOff ? _self.isOff : isOff // ignore: cast_nullable_to_non_nullable
as bool,specializations: null == specializations ? _self._specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$EmployeeStatusCalculation implements DiagnosticableTreeMixin {

 String get status; String? get ticketId; String get reason;
/// Create a copy of EmployeeStatusCalculation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeStatusCalculationCopyWith<EmployeeStatusCalculation> get copyWith => _$EmployeeStatusCalculationCopyWithImpl<EmployeeStatusCalculation>(this as EmployeeStatusCalculation, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeStatusCalculation'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('ticketId', ticketId))..add(DiagnosticsProperty('reason', reason));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeStatusCalculation&&(identical(other.status, status) || other.status == status)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,status,ticketId,reason);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeStatusCalculation(status: $status, ticketId: $ticketId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $EmployeeStatusCalculationCopyWith<$Res>  {
  factory $EmployeeStatusCalculationCopyWith(EmployeeStatusCalculation value, $Res Function(EmployeeStatusCalculation) _then) = _$EmployeeStatusCalculationCopyWithImpl;
@useResult
$Res call({
 String status, String? ticketId, String reason
});




}
/// @nodoc
class _$EmployeeStatusCalculationCopyWithImpl<$Res>
    implements $EmployeeStatusCalculationCopyWith<$Res> {
  _$EmployeeStatusCalculationCopyWithImpl(this._self, this._then);

  final EmployeeStatusCalculation _self;
  final $Res Function(EmployeeStatusCalculation) _then;

/// Create a copy of EmployeeStatusCalculation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? ticketId = freezed,Object? reason = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeStatusCalculation].
extension EmployeeStatusCalculationPatterns on EmployeeStatusCalculation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeStatusCalculation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeStatusCalculation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeStatusCalculation value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusCalculation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeStatusCalculation value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeStatusCalculation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? ticketId,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeStatusCalculation() when $default != null:
return $default(_that.status,_that.ticketId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? ticketId,  String reason)  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusCalculation():
return $default(_that.status,_that.ticketId,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? ticketId,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeStatusCalculation() when $default != null:
return $default(_that.status,_that.ticketId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeStatusCalculation with DiagnosticableTreeMixin implements EmployeeStatusCalculation {
  const _EmployeeStatusCalculation({required this.status, this.ticketId, required this.reason});
  

@override final  String status;
@override final  String? ticketId;
@override final  String reason;

/// Create a copy of EmployeeStatusCalculation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeStatusCalculationCopyWith<_EmployeeStatusCalculation> get copyWith => __$EmployeeStatusCalculationCopyWithImpl<_EmployeeStatusCalculation>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EmployeeStatusCalculation'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('ticketId', ticketId))..add(DiagnosticsProperty('reason', reason));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeStatusCalculation&&(identical(other.status, status) || other.status == status)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,status,ticketId,reason);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EmployeeStatusCalculation(status: $status, ticketId: $ticketId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$EmployeeStatusCalculationCopyWith<$Res> implements $EmployeeStatusCalculationCopyWith<$Res> {
  factory _$EmployeeStatusCalculationCopyWith(_EmployeeStatusCalculation value, $Res Function(_EmployeeStatusCalculation) _then) = __$EmployeeStatusCalculationCopyWithImpl;
@override @useResult
$Res call({
 String status, String? ticketId, String reason
});




}
/// @nodoc
class __$EmployeeStatusCalculationCopyWithImpl<$Res>
    implements _$EmployeeStatusCalculationCopyWith<$Res> {
  __$EmployeeStatusCalculationCopyWithImpl(this._self, this._then);

  final _EmployeeStatusCalculation _self;
  final $Res Function(_EmployeeStatusCalculation) _then;

/// Create a copy of EmployeeStatusCalculation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? ticketId = freezed,Object? reason = null,}) {
  return _then(_EmployeeStatusCalculation(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
