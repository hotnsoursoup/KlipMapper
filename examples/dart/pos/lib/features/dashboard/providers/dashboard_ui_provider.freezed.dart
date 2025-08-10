// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_ui_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardUIState {

 bool get isCheckInDialogOpen; bool get isTicketDetailsDialogOpen; String? get selectedTicketId; String? get notificationMessage; NotificationType? get notificationType; DateTime? get notificationTimestamp;
/// Create a copy of DashboardUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardUIStateCopyWith<DashboardUIState> get copyWith => _$DashboardUIStateCopyWithImpl<DashboardUIState>(this as DashboardUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardUIState&&(identical(other.isCheckInDialogOpen, isCheckInDialogOpen) || other.isCheckInDialogOpen == isCheckInDialogOpen)&&(identical(other.isTicketDetailsDialogOpen, isTicketDetailsDialogOpen) || other.isTicketDetailsDialogOpen == isTicketDetailsDialogOpen)&&(identical(other.selectedTicketId, selectedTicketId) || other.selectedTicketId == selectedTicketId)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationTimestamp, notificationTimestamp) || other.notificationTimestamp == notificationTimestamp));
}


@override
int get hashCode => Object.hash(runtimeType,isCheckInDialogOpen,isTicketDetailsDialogOpen,selectedTicketId,notificationMessage,notificationType,notificationTimestamp);

@override
String toString() {
  return 'DashboardUIState(isCheckInDialogOpen: $isCheckInDialogOpen, isTicketDetailsDialogOpen: $isTicketDetailsDialogOpen, selectedTicketId: $selectedTicketId, notificationMessage: $notificationMessage, notificationType: $notificationType, notificationTimestamp: $notificationTimestamp)';
}


}

/// @nodoc
abstract mixin class $DashboardUIStateCopyWith<$Res>  {
  factory $DashboardUIStateCopyWith(DashboardUIState value, $Res Function(DashboardUIState) _then) = _$DashboardUIStateCopyWithImpl;
@useResult
$Res call({
 bool isCheckInDialogOpen, bool isTicketDetailsDialogOpen, String? selectedTicketId, String? notificationMessage, NotificationType? notificationType, DateTime? notificationTimestamp
});




}
/// @nodoc
class _$DashboardUIStateCopyWithImpl<$Res>
    implements $DashboardUIStateCopyWith<$Res> {
  _$DashboardUIStateCopyWithImpl(this._self, this._then);

  final DashboardUIState _self;
  final $Res Function(DashboardUIState) _then;

/// Create a copy of DashboardUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCheckInDialogOpen = null,Object? isTicketDetailsDialogOpen = null,Object? selectedTicketId = freezed,Object? notificationMessage = freezed,Object? notificationType = freezed,Object? notificationTimestamp = freezed,}) {
  return _then(_self.copyWith(
isCheckInDialogOpen: null == isCheckInDialogOpen ? _self.isCheckInDialogOpen : isCheckInDialogOpen // ignore: cast_nullable_to_non_nullable
as bool,isTicketDetailsDialogOpen: null == isTicketDetailsDialogOpen ? _self.isTicketDetailsDialogOpen : isTicketDetailsDialogOpen // ignore: cast_nullable_to_non_nullable
as bool,selectedTicketId: freezed == selectedTicketId ? _self.selectedTicketId : selectedTicketId // ignore: cast_nullable_to_non_nullable
as String?,notificationMessage: freezed == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String?,notificationType: freezed == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType?,notificationTimestamp: freezed == notificationTimestamp ? _self.notificationTimestamp : notificationTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardUIState].
extension DashboardUIStatePatterns on DashboardUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardUIState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardUIState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardUIState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isCheckInDialogOpen,  bool isTicketDetailsDialogOpen,  String? selectedTicketId,  String? notificationMessage,  NotificationType? notificationType,  DateTime? notificationTimestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardUIState() when $default != null:
return $default(_that.isCheckInDialogOpen,_that.isTicketDetailsDialogOpen,_that.selectedTicketId,_that.notificationMessage,_that.notificationType,_that.notificationTimestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isCheckInDialogOpen,  bool isTicketDetailsDialogOpen,  String? selectedTicketId,  String? notificationMessage,  NotificationType? notificationType,  DateTime? notificationTimestamp)  $default,) {final _that = this;
switch (_that) {
case _DashboardUIState():
return $default(_that.isCheckInDialogOpen,_that.isTicketDetailsDialogOpen,_that.selectedTicketId,_that.notificationMessage,_that.notificationType,_that.notificationTimestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isCheckInDialogOpen,  bool isTicketDetailsDialogOpen,  String? selectedTicketId,  String? notificationMessage,  NotificationType? notificationType,  DateTime? notificationTimestamp)?  $default,) {final _that = this;
switch (_that) {
case _DashboardUIState() when $default != null:
return $default(_that.isCheckInDialogOpen,_that.isTicketDetailsDialogOpen,_that.selectedTicketId,_that.notificationMessage,_that.notificationType,_that.notificationTimestamp);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardUIState implements DashboardUIState {
  const _DashboardUIState({this.isCheckInDialogOpen = false, this.isTicketDetailsDialogOpen = false, this.selectedTicketId, this.notificationMessage, this.notificationType, this.notificationTimestamp});
  

@override@JsonKey() final  bool isCheckInDialogOpen;
@override@JsonKey() final  bool isTicketDetailsDialogOpen;
@override final  String? selectedTicketId;
@override final  String? notificationMessage;
@override final  NotificationType? notificationType;
@override final  DateTime? notificationTimestamp;

/// Create a copy of DashboardUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardUIStateCopyWith<_DashboardUIState> get copyWith => __$DashboardUIStateCopyWithImpl<_DashboardUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardUIState&&(identical(other.isCheckInDialogOpen, isCheckInDialogOpen) || other.isCheckInDialogOpen == isCheckInDialogOpen)&&(identical(other.isTicketDetailsDialogOpen, isTicketDetailsDialogOpen) || other.isTicketDetailsDialogOpen == isTicketDetailsDialogOpen)&&(identical(other.selectedTicketId, selectedTicketId) || other.selectedTicketId == selectedTicketId)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationTimestamp, notificationTimestamp) || other.notificationTimestamp == notificationTimestamp));
}


@override
int get hashCode => Object.hash(runtimeType,isCheckInDialogOpen,isTicketDetailsDialogOpen,selectedTicketId,notificationMessage,notificationType,notificationTimestamp);

@override
String toString() {
  return 'DashboardUIState(isCheckInDialogOpen: $isCheckInDialogOpen, isTicketDetailsDialogOpen: $isTicketDetailsDialogOpen, selectedTicketId: $selectedTicketId, notificationMessage: $notificationMessage, notificationType: $notificationType, notificationTimestamp: $notificationTimestamp)';
}


}

/// @nodoc
abstract mixin class _$DashboardUIStateCopyWith<$Res> implements $DashboardUIStateCopyWith<$Res> {
  factory _$DashboardUIStateCopyWith(_DashboardUIState value, $Res Function(_DashboardUIState) _then) = __$DashboardUIStateCopyWithImpl;
@override @useResult
$Res call({
 bool isCheckInDialogOpen, bool isTicketDetailsDialogOpen, String? selectedTicketId, String? notificationMessage, NotificationType? notificationType, DateTime? notificationTimestamp
});




}
/// @nodoc
class __$DashboardUIStateCopyWithImpl<$Res>
    implements _$DashboardUIStateCopyWith<$Res> {
  __$DashboardUIStateCopyWithImpl(this._self, this._then);

  final _DashboardUIState _self;
  final $Res Function(_DashboardUIState) _then;

/// Create a copy of DashboardUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCheckInDialogOpen = null,Object? isTicketDetailsDialogOpen = null,Object? selectedTicketId = freezed,Object? notificationMessage = freezed,Object? notificationType = freezed,Object? notificationTimestamp = freezed,}) {
  return _then(_DashboardUIState(
isCheckInDialogOpen: null == isCheckInDialogOpen ? _self.isCheckInDialogOpen : isCheckInDialogOpen // ignore: cast_nullable_to_non_nullable
as bool,isTicketDetailsDialogOpen: null == isTicketDetailsDialogOpen ? _self.isTicketDetailsDialogOpen : isTicketDetailsDialogOpen // ignore: cast_nullable_to_non_nullable
as bool,selectedTicketId: freezed == selectedTicketId ? _self.selectedTicketId : selectedTicketId // ignore: cast_nullable_to_non_nullable
as String?,notificationMessage: freezed == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String?,notificationType: freezed == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType?,notificationTimestamp: freezed == notificationTimestamp ? _self.notificationTimestamp : notificationTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
