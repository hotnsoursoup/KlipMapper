// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_assignment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketAssignmentState {

 Map<String, String> get assignments;// ticketId -> techId
 bool get autoAssignmentEnabled; DateTime? get lastAssignmentTime; bool get isProcessing; String? get errorMessage;
/// Create a copy of TicketAssignmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketAssignmentStateCopyWith<TicketAssignmentState> get copyWith => _$TicketAssignmentStateCopyWithImpl<TicketAssignmentState>(this as TicketAssignmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketAssignmentState&&const DeepCollectionEquality().equals(other.assignments, assignments)&&(identical(other.autoAssignmentEnabled, autoAssignmentEnabled) || other.autoAssignmentEnabled == autoAssignmentEnabled)&&(identical(other.lastAssignmentTime, lastAssignmentTime) || other.lastAssignmentTime == lastAssignmentTime)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(assignments),autoAssignmentEnabled,lastAssignmentTime,isProcessing,errorMessage);

@override
String toString() {
  return 'TicketAssignmentState(assignments: $assignments, autoAssignmentEnabled: $autoAssignmentEnabled, lastAssignmentTime: $lastAssignmentTime, isProcessing: $isProcessing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TicketAssignmentStateCopyWith<$Res>  {
  factory $TicketAssignmentStateCopyWith(TicketAssignmentState value, $Res Function(TicketAssignmentState) _then) = _$TicketAssignmentStateCopyWithImpl;
@useResult
$Res call({
 Map<String, String> assignments, bool autoAssignmentEnabled, DateTime? lastAssignmentTime, bool isProcessing, String? errorMessage
});




}
/// @nodoc
class _$TicketAssignmentStateCopyWithImpl<$Res>
    implements $TicketAssignmentStateCopyWith<$Res> {
  _$TicketAssignmentStateCopyWithImpl(this._self, this._then);

  final TicketAssignmentState _self;
  final $Res Function(TicketAssignmentState) _then;

/// Create a copy of TicketAssignmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assignments = null,Object? autoAssignmentEnabled = null,Object? lastAssignmentTime = freezed,Object? isProcessing = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
assignments: null == assignments ? _self.assignments : assignments // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoAssignmentEnabled: null == autoAssignmentEnabled ? _self.autoAssignmentEnabled : autoAssignmentEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastAssignmentTime: freezed == lastAssignmentTime ? _self.lastAssignmentTime : lastAssignmentTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketAssignmentState].
extension TicketAssignmentStatePatterns on TicketAssignmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketAssignmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketAssignmentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketAssignmentState value)  $default,){
final _that = this;
switch (_that) {
case _TicketAssignmentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketAssignmentState value)?  $default,){
final _that = this;
switch (_that) {
case _TicketAssignmentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> assignments,  bool autoAssignmentEnabled,  DateTime? lastAssignmentTime,  bool isProcessing,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketAssignmentState() when $default != null:
return $default(_that.assignments,_that.autoAssignmentEnabled,_that.lastAssignmentTime,_that.isProcessing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> assignments,  bool autoAssignmentEnabled,  DateTime? lastAssignmentTime,  bool isProcessing,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TicketAssignmentState():
return $default(_that.assignments,_that.autoAssignmentEnabled,_that.lastAssignmentTime,_that.isProcessing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> assignments,  bool autoAssignmentEnabled,  DateTime? lastAssignmentTime,  bool isProcessing,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TicketAssignmentState() when $default != null:
return $default(_that.assignments,_that.autoAssignmentEnabled,_that.lastAssignmentTime,_that.isProcessing,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TicketAssignmentState implements TicketAssignmentState {
  const _TicketAssignmentState({final  Map<String, String> assignments = const {}, this.autoAssignmentEnabled = true, this.lastAssignmentTime, this.isProcessing = false, this.errorMessage}): _assignments = assignments;
  

 final  Map<String, String> _assignments;
@override@JsonKey() Map<String, String> get assignments {
  if (_assignments is EqualUnmodifiableMapView) return _assignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_assignments);
}

// ticketId -> techId
@override@JsonKey() final  bool autoAssignmentEnabled;
@override final  DateTime? lastAssignmentTime;
@override@JsonKey() final  bool isProcessing;
@override final  String? errorMessage;

/// Create a copy of TicketAssignmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketAssignmentStateCopyWith<_TicketAssignmentState> get copyWith => __$TicketAssignmentStateCopyWithImpl<_TicketAssignmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketAssignmentState&&const DeepCollectionEquality().equals(other._assignments, _assignments)&&(identical(other.autoAssignmentEnabled, autoAssignmentEnabled) || other.autoAssignmentEnabled == autoAssignmentEnabled)&&(identical(other.lastAssignmentTime, lastAssignmentTime) || other.lastAssignmentTime == lastAssignmentTime)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assignments),autoAssignmentEnabled,lastAssignmentTime,isProcessing,errorMessage);

@override
String toString() {
  return 'TicketAssignmentState(assignments: $assignments, autoAssignmentEnabled: $autoAssignmentEnabled, lastAssignmentTime: $lastAssignmentTime, isProcessing: $isProcessing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TicketAssignmentStateCopyWith<$Res> implements $TicketAssignmentStateCopyWith<$Res> {
  factory _$TicketAssignmentStateCopyWith(_TicketAssignmentState value, $Res Function(_TicketAssignmentState) _then) = __$TicketAssignmentStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> assignments, bool autoAssignmentEnabled, DateTime? lastAssignmentTime, bool isProcessing, String? errorMessage
});




}
/// @nodoc
class __$TicketAssignmentStateCopyWithImpl<$Res>
    implements _$TicketAssignmentStateCopyWith<$Res> {
  __$TicketAssignmentStateCopyWithImpl(this._self, this._then);

  final _TicketAssignmentState _self;
  final $Res Function(_TicketAssignmentState) _then;

/// Create a copy of TicketAssignmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assignments = null,Object? autoAssignmentEnabled = null,Object? lastAssignmentTime = freezed,Object? isProcessing = null,Object? errorMessage = freezed,}) {
  return _then(_TicketAssignmentState(
assignments: null == assignments ? _self._assignments : assignments // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoAssignmentEnabled: null == autoAssignmentEnabled ? _self.autoAssignmentEnabled : autoAssignmentEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastAssignmentTime: freezed == lastAssignmentTime ? _self.lastAssignmentTime : lastAssignmentTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AssignmentResult {

 String? get ticketId; String? get technicianId;
/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentResultCopyWith<AssignmentResult> get copyWith => _$AssignmentResultCopyWithImpl<AssignmentResult>(this as AssignmentResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignmentResult&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId));
}


@override
int get hashCode => Object.hash(runtimeType,ticketId,technicianId);

@override
String toString() {
  return 'AssignmentResult(ticketId: $ticketId, technicianId: $technicianId)';
}


}

/// @nodoc
abstract mixin class $AssignmentResultCopyWith<$Res>  {
  factory $AssignmentResultCopyWith(AssignmentResult value, $Res Function(AssignmentResult) _then) = _$AssignmentResultCopyWithImpl;
@useResult
$Res call({
 String ticketId, String technicianId
});




}
/// @nodoc
class _$AssignmentResultCopyWithImpl<$Res>
    implements $AssignmentResultCopyWith<$Res> {
  _$AssignmentResultCopyWithImpl(this._self, this._then);

  final AssignmentResult _self;
  final $Res Function(AssignmentResult) _then;

/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticketId = null,Object? technicianId = null,}) {
  return _then(_self.copyWith(
ticketId: null == ticketId ? _self.ticketId! : ticketId // ignore: cast_nullable_to_non_nullable
as String,technicianId: null == technicianId ? _self.technicianId! : technicianId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignmentResult].
extension AssignmentResultPatterns on AssignmentResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Success value)?  success,TResult Function( _Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Success value)  success,required TResult Function( _Failed value)  failed,}){
final _that = this;
switch (_that) {
case _Success():
return success(_that);case _Failed():
return failed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Success value)?  success,TResult? Function( _Failed value)?  failed,}){
final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String ticketId,  String technicianId,  DateTime assignedAt)?  success,TResult Function( String reason,  String? ticketId,  String? technicianId)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that.ticketId,_that.technicianId,_that.assignedAt);case _Failed() when failed != null:
return failed(_that.reason,_that.ticketId,_that.technicianId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String ticketId,  String technicianId,  DateTime assignedAt)  success,required TResult Function( String reason,  String? ticketId,  String? technicianId)  failed,}) {final _that = this;
switch (_that) {
case _Success():
return success(_that.ticketId,_that.technicianId,_that.assignedAt);case _Failed():
return failed(_that.reason,_that.ticketId,_that.technicianId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String ticketId,  String technicianId,  DateTime assignedAt)?  success,TResult? Function( String reason,  String? ticketId,  String? technicianId)?  failed,}) {final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that.ticketId,_that.technicianId,_that.assignedAt);case _Failed() when failed != null:
return failed(_that.reason,_that.ticketId,_that.technicianId);case _:
  return null;

}
}

}

/// @nodoc


class _Success implements AssignmentResult {
  const _Success({required this.ticketId, required this.technicianId, required this.assignedAt});
  

@override final  String ticketId;
@override final  String technicianId;
 final  DateTime assignedAt;

/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt));
}


@override
int get hashCode => Object.hash(runtimeType,ticketId,technicianId,assignedAt);

@override
String toString() {
  return 'AssignmentResult.success(ticketId: $ticketId, technicianId: $technicianId, assignedAt: $assignedAt)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $AssignmentResultCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@override @useResult
$Res call({
 String ticketId, String technicianId, DateTime assignedAt
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticketId = null,Object? technicianId = null,Object? assignedAt = null,}) {
  return _then(_Success(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _Failed implements AssignmentResult {
  const _Failed({required this.reason, this.ticketId, this.technicianId});
  

 final  String reason;
@override final  String? ticketId;
@override final  String? technicianId;

/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedCopyWith<_Failed> get copyWith => __$FailedCopyWithImpl<_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failed&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId));
}


@override
int get hashCode => Object.hash(runtimeType,reason,ticketId,technicianId);

@override
String toString() {
  return 'AssignmentResult.failed(reason: $reason, ticketId: $ticketId, technicianId: $technicianId)';
}


}

/// @nodoc
abstract mixin class _$FailedCopyWith<$Res> implements $AssignmentResultCopyWith<$Res> {
  factory _$FailedCopyWith(_Failed value, $Res Function(_Failed) _then) = __$FailedCopyWithImpl;
@override @useResult
$Res call({
 String reason, String? ticketId, String? technicianId
});




}
/// @nodoc
class __$FailedCopyWithImpl<$Res>
    implements _$FailedCopyWith<$Res> {
  __$FailedCopyWithImpl(this._self, this._then);

  final _Failed _self;
  final $Res Function(_Failed) _then;

/// Create a copy of AssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? ticketId = freezed,Object? technicianId = freezed,}) {
  return _then(_Failed(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
