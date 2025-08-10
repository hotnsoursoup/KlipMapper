// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportsTimeRangeState {

 DateTime get startDate; DateTime get endDate; ReportsTimeRangeType get selectedRange;
/// Create a copy of ReportsTimeRangeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsTimeRangeStateCopyWith<ReportsTimeRangeState> get copyWith => _$ReportsTimeRangeStateCopyWithImpl<ReportsTimeRangeState>(this as ReportsTimeRangeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsTimeRangeState&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,selectedRange);

@override
String toString() {
  return 'ReportsTimeRangeState(startDate: $startDate, endDate: $endDate, selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class $ReportsTimeRangeStateCopyWith<$Res>  {
  factory $ReportsTimeRangeStateCopyWith(ReportsTimeRangeState value, $Res Function(ReportsTimeRangeState) _then) = _$ReportsTimeRangeStateCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate, ReportsTimeRangeType selectedRange
});




}
/// @nodoc
class _$ReportsTimeRangeStateCopyWithImpl<$Res>
    implements $ReportsTimeRangeStateCopyWith<$Res> {
  _$ReportsTimeRangeStateCopyWithImpl(this._self, this._then);

  final ReportsTimeRangeState _self;
  final $Res Function(ReportsTimeRangeState) _then;

/// Create a copy of ReportsTimeRangeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? selectedRange = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ReportsTimeRangeType,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportsTimeRangeState].
extension ReportsTimeRangeStatePatterns on ReportsTimeRangeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportsTimeRangeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportsTimeRangeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportsTimeRangeState value)  $default,){
final _that = this;
switch (_that) {
case _ReportsTimeRangeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportsTimeRangeState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportsTimeRangeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  ReportsTimeRangeType selectedRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportsTimeRangeState() when $default != null:
return $default(_that.startDate,_that.endDate,_that.selectedRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  ReportsTimeRangeType selectedRange)  $default,) {final _that = this;
switch (_that) {
case _ReportsTimeRangeState():
return $default(_that.startDate,_that.endDate,_that.selectedRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startDate,  DateTime endDate,  ReportsTimeRangeType selectedRange)?  $default,) {final _that = this;
switch (_that) {
case _ReportsTimeRangeState() when $default != null:
return $default(_that.startDate,_that.endDate,_that.selectedRange);case _:
  return null;

}
}

}

/// @nodoc


class _ReportsTimeRangeState implements ReportsTimeRangeState {
  const _ReportsTimeRangeState({required this.startDate, required this.endDate, required this.selectedRange});
  

@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  ReportsTimeRangeType selectedRange;

/// Create a copy of ReportsTimeRangeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportsTimeRangeStateCopyWith<_ReportsTimeRangeState> get copyWith => __$ReportsTimeRangeStateCopyWithImpl<_ReportsTimeRangeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportsTimeRangeState&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,selectedRange);

@override
String toString() {
  return 'ReportsTimeRangeState(startDate: $startDate, endDate: $endDate, selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class _$ReportsTimeRangeStateCopyWith<$Res> implements $ReportsTimeRangeStateCopyWith<$Res> {
  factory _$ReportsTimeRangeStateCopyWith(_ReportsTimeRangeState value, $Res Function(_ReportsTimeRangeState) _then) = __$ReportsTimeRangeStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, DateTime endDate, ReportsTimeRangeType selectedRange
});




}
/// @nodoc
class __$ReportsTimeRangeStateCopyWithImpl<$Res>
    implements _$ReportsTimeRangeStateCopyWith<$Res> {
  __$ReportsTimeRangeStateCopyWithImpl(this._self, this._then);

  final _ReportsTimeRangeState _self;
  final $Res Function(_ReportsTimeRangeState) _then;

/// Create a copy of ReportsTimeRangeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? selectedRange = null,}) {
  return _then(_ReportsTimeRangeState(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ReportsTimeRangeType,
  ));
}


}

// dart format on
