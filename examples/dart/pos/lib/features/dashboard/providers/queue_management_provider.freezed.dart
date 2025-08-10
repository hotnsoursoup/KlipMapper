// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_management_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueManagementState {

 List<Ticket> get queueTickets; QueueFilter get currentFilter; String? get errorMessage; DateTime? get lastUpdated;
/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueManagementStateCopyWith<QueueManagementState> get copyWith => _$QueueManagementStateCopyWithImpl<QueueManagementState>(this as QueueManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueManagementState&&const DeepCollectionEquality().equals(other.queueTickets, queueTickets)&&(identical(other.currentFilter, currentFilter) || other.currentFilter == currentFilter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(queueTickets),currentFilter,errorMessage,lastUpdated);

@override
String toString() {
  return 'QueueManagementState(queueTickets: $queueTickets, currentFilter: $currentFilter, errorMessage: $errorMessage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $QueueManagementStateCopyWith<$Res>  {
  factory $QueueManagementStateCopyWith(QueueManagementState value, $Res Function(QueueManagementState) _then) = _$QueueManagementStateCopyWithImpl;
@useResult
$Res call({
 List<Ticket> queueTickets, QueueFilter currentFilter, String? errorMessage, DateTime? lastUpdated
});


$QueueFilterCopyWith<$Res> get currentFilter;

}
/// @nodoc
class _$QueueManagementStateCopyWithImpl<$Res>
    implements $QueueManagementStateCopyWith<$Res> {
  _$QueueManagementStateCopyWithImpl(this._self, this._then);

  final QueueManagementState _self;
  final $Res Function(QueueManagementState) _then;

/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? queueTickets = null,Object? currentFilter = null,Object? errorMessage = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
queueTickets: null == queueTickets ? _self.queueTickets : queueTickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,currentFilter: null == currentFilter ? _self.currentFilter : currentFilter // ignore: cast_nullable_to_non_nullable
as QueueFilter,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueueFilterCopyWith<$Res> get currentFilter {
  
  return $QueueFilterCopyWith<$Res>(_self.currentFilter, (value) {
    return _then(_self.copyWith(currentFilter: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueManagementState].
extension QueueManagementStatePatterns on QueueManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueManagementState value)  $default,){
final _that = this;
switch (_that) {
case _QueueManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _QueueManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Ticket> queueTickets,  QueueFilter currentFilter,  String? errorMessage,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueManagementState() when $default != null:
return $default(_that.queueTickets,_that.currentFilter,_that.errorMessage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Ticket> queueTickets,  QueueFilter currentFilter,  String? errorMessage,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _QueueManagementState():
return $default(_that.queueTickets,_that.currentFilter,_that.errorMessage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Ticket> queueTickets,  QueueFilter currentFilter,  String? errorMessage,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _QueueManagementState() when $default != null:
return $default(_that.queueTickets,_that.currentFilter,_that.errorMessage,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _QueueManagementState implements QueueManagementState {
  const _QueueManagementState({final  List<Ticket> queueTickets = const [], this.currentFilter = const QueueFilter.all(), this.errorMessage, this.lastUpdated}): _queueTickets = queueTickets;
  

 final  List<Ticket> _queueTickets;
@override@JsonKey() List<Ticket> get queueTickets {
  if (_queueTickets is EqualUnmodifiableListView) return _queueTickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queueTickets);
}

@override@JsonKey() final  QueueFilter currentFilter;
@override final  String? errorMessage;
@override final  DateTime? lastUpdated;

/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueManagementStateCopyWith<_QueueManagementState> get copyWith => __$QueueManagementStateCopyWithImpl<_QueueManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueManagementState&&const DeepCollectionEquality().equals(other._queueTickets, _queueTickets)&&(identical(other.currentFilter, currentFilter) || other.currentFilter == currentFilter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_queueTickets),currentFilter,errorMessage,lastUpdated);

@override
String toString() {
  return 'QueueManagementState(queueTickets: $queueTickets, currentFilter: $currentFilter, errorMessage: $errorMessage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$QueueManagementStateCopyWith<$Res> implements $QueueManagementStateCopyWith<$Res> {
  factory _$QueueManagementStateCopyWith(_QueueManagementState value, $Res Function(_QueueManagementState) _then) = __$QueueManagementStateCopyWithImpl;
@override @useResult
$Res call({
 List<Ticket> queueTickets, QueueFilter currentFilter, String? errorMessage, DateTime? lastUpdated
});


@override $QueueFilterCopyWith<$Res> get currentFilter;

}
/// @nodoc
class __$QueueManagementStateCopyWithImpl<$Res>
    implements _$QueueManagementStateCopyWith<$Res> {
  __$QueueManagementStateCopyWithImpl(this._self, this._then);

  final _QueueManagementState _self;
  final $Res Function(_QueueManagementState) _then;

/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? queueTickets = null,Object? currentFilter = null,Object? errorMessage = freezed,Object? lastUpdated = freezed,}) {
  return _then(_QueueManagementState(
queueTickets: null == queueTickets ? _self._queueTickets : queueTickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,currentFilter: null == currentFilter ? _self.currentFilter : currentFilter // ignore: cast_nullable_to_non_nullable
as QueueFilter,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of QueueManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueueFilterCopyWith<$Res> get currentFilter {
  
  return $QueueFilterCopyWith<$Res>(_self.currentFilter, (value) {
    return _then(_self.copyWith(currentFilter: value));
  });
}
}

/// @nodoc
mixin _$QueueFilter {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueFilter);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QueueFilter()';
}


}

/// @nodoc
class $QueueFilterCopyWith<$Res>  {
$QueueFilterCopyWith(QueueFilter _, $Res Function(QueueFilter) __);
}


/// Adds pattern-matching-related methods to [QueueFilter].
extension QueueFilterPatterns on QueueFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _All value)?  all,TResult Function( _WalkIn value)?  walkIn,TResult Function( _Appointment value)?  appointment,TResult Function( _Completed value)?  completed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _All() when all != null:
return all(_that);case _WalkIn() when walkIn != null:
return walkIn(_that);case _Appointment() when appointment != null:
return appointment(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _All value)  all,required TResult Function( _WalkIn value)  walkIn,required TResult Function( _Appointment value)  appointment,required TResult Function( _Completed value)  completed,}){
final _that = this;
switch (_that) {
case _All():
return all(_that);case _WalkIn():
return walkIn(_that);case _Appointment():
return appointment(_that);case _Completed():
return completed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _All value)?  all,TResult? Function( _WalkIn value)?  walkIn,TResult? Function( _Appointment value)?  appointment,TResult? Function( _Completed value)?  completed,}){
final _that = this;
switch (_that) {
case _All() when all != null:
return all(_that);case _WalkIn() when walkIn != null:
return walkIn(_that);case _Appointment() when appointment != null:
return appointment(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function()?  walkIn,TResult Function()?  appointment,TResult Function()?  completed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _All() when all != null:
return all();case _WalkIn() when walkIn != null:
return walkIn();case _Appointment() when appointment != null:
return appointment();case _Completed() when completed != null:
return completed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function()  walkIn,required TResult Function()  appointment,required TResult Function()  completed,}) {final _that = this;
switch (_that) {
case _All():
return all();case _WalkIn():
return walkIn();case _Appointment():
return appointment();case _Completed():
return completed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function()?  walkIn,TResult? Function()?  appointment,TResult? Function()?  completed,}) {final _that = this;
switch (_that) {
case _All() when all != null:
return all();case _WalkIn() when walkIn != null:
return walkIn();case _Appointment() when appointment != null:
return appointment();case _Completed() when completed != null:
return completed();case _:
  return null;

}
}

}

/// @nodoc


class _All implements QueueFilter {
  const _All();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _All);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QueueFilter.all()';
}


}




/// @nodoc


class _WalkIn implements QueueFilter {
  const _WalkIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalkIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QueueFilter.walkIn()';
}


}




/// @nodoc


class _Appointment implements QueueFilter {
  const _Appointment();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QueueFilter.appointment()';
}


}




/// @nodoc


class _Completed implements QueueFilter {
  const _Completed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QueueFilter.completed()';
}


}




// dart format on
