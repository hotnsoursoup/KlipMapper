// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSettings {

 bool get showCustomerPhone; bool get enableCheckoutNotifications; String get fontSize; String get technicianLayout; String get serviceDisplayMode; bool get showTodaysSchedule; bool get showUpcomingAppointments;// Background and UI settings
 String get dashboardBackground; double get backgroundOpacity; double get containerOpacity; double get widgetOpacity;
/// Create a copy of DashboardSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSettingsCopyWith<DashboardSettings> get copyWith => _$DashboardSettingsCopyWithImpl<DashboardSettings>(this as DashboardSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSettings&&(identical(other.showCustomerPhone, showCustomerPhone) || other.showCustomerPhone == showCustomerPhone)&&(identical(other.enableCheckoutNotifications, enableCheckoutNotifications) || other.enableCheckoutNotifications == enableCheckoutNotifications)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.technicianLayout, technicianLayout) || other.technicianLayout == technicianLayout)&&(identical(other.serviceDisplayMode, serviceDisplayMode) || other.serviceDisplayMode == serviceDisplayMode)&&(identical(other.showTodaysSchedule, showTodaysSchedule) || other.showTodaysSchedule == showTodaysSchedule)&&(identical(other.showUpcomingAppointments, showUpcomingAppointments) || other.showUpcomingAppointments == showUpcomingAppointments)&&(identical(other.dashboardBackground, dashboardBackground) || other.dashboardBackground == dashboardBackground)&&(identical(other.backgroundOpacity, backgroundOpacity) || other.backgroundOpacity == backgroundOpacity)&&(identical(other.containerOpacity, containerOpacity) || other.containerOpacity == containerOpacity)&&(identical(other.widgetOpacity, widgetOpacity) || other.widgetOpacity == widgetOpacity));
}


@override
int get hashCode => Object.hash(runtimeType,showCustomerPhone,enableCheckoutNotifications,fontSize,technicianLayout,serviceDisplayMode,showTodaysSchedule,showUpcomingAppointments,dashboardBackground,backgroundOpacity,containerOpacity,widgetOpacity);

@override
String toString() {
  return 'DashboardSettings(showCustomerPhone: $showCustomerPhone, enableCheckoutNotifications: $enableCheckoutNotifications, fontSize: $fontSize, technicianLayout: $technicianLayout, serviceDisplayMode: $serviceDisplayMode, showTodaysSchedule: $showTodaysSchedule, showUpcomingAppointments: $showUpcomingAppointments, dashboardBackground: $dashboardBackground, backgroundOpacity: $backgroundOpacity, containerOpacity: $containerOpacity, widgetOpacity: $widgetOpacity)';
}


}

/// @nodoc
abstract mixin class $DashboardSettingsCopyWith<$Res>  {
  factory $DashboardSettingsCopyWith(DashboardSettings value, $Res Function(DashboardSettings) _then) = _$DashboardSettingsCopyWithImpl;
@useResult
$Res call({
 bool showCustomerPhone, bool enableCheckoutNotifications, String fontSize, String technicianLayout, String serviceDisplayMode, bool showTodaysSchedule, bool showUpcomingAppointments, String dashboardBackground, double backgroundOpacity, double containerOpacity, double widgetOpacity
});




}
/// @nodoc
class _$DashboardSettingsCopyWithImpl<$Res>
    implements $DashboardSettingsCopyWith<$Res> {
  _$DashboardSettingsCopyWithImpl(this._self, this._then);

  final DashboardSettings _self;
  final $Res Function(DashboardSettings) _then;

/// Create a copy of DashboardSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showCustomerPhone = null,Object? enableCheckoutNotifications = null,Object? fontSize = null,Object? technicianLayout = null,Object? serviceDisplayMode = null,Object? showTodaysSchedule = null,Object? showUpcomingAppointments = null,Object? dashboardBackground = null,Object? backgroundOpacity = null,Object? containerOpacity = null,Object? widgetOpacity = null,}) {
  return _then(_self.copyWith(
showCustomerPhone: null == showCustomerPhone ? _self.showCustomerPhone : showCustomerPhone // ignore: cast_nullable_to_non_nullable
as bool,enableCheckoutNotifications: null == enableCheckoutNotifications ? _self.enableCheckoutNotifications : enableCheckoutNotifications // ignore: cast_nullable_to_non_nullable
as bool,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as String,technicianLayout: null == technicianLayout ? _self.technicianLayout : technicianLayout // ignore: cast_nullable_to_non_nullable
as String,serviceDisplayMode: null == serviceDisplayMode ? _self.serviceDisplayMode : serviceDisplayMode // ignore: cast_nullable_to_non_nullable
as String,showTodaysSchedule: null == showTodaysSchedule ? _self.showTodaysSchedule : showTodaysSchedule // ignore: cast_nullable_to_non_nullable
as bool,showUpcomingAppointments: null == showUpcomingAppointments ? _self.showUpcomingAppointments : showUpcomingAppointments // ignore: cast_nullable_to_non_nullable
as bool,dashboardBackground: null == dashboardBackground ? _self.dashboardBackground : dashboardBackground // ignore: cast_nullable_to_non_nullable
as String,backgroundOpacity: null == backgroundOpacity ? _self.backgroundOpacity : backgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,containerOpacity: null == containerOpacity ? _self.containerOpacity : containerOpacity // ignore: cast_nullable_to_non_nullable
as double,widgetOpacity: null == widgetOpacity ? _self.widgetOpacity : widgetOpacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSettings].
extension DashboardSettingsPatterns on DashboardSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSettings value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSettings value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showCustomerPhone,  bool enableCheckoutNotifications,  String fontSize,  String technicianLayout,  String serviceDisplayMode,  bool showTodaysSchedule,  bool showUpcomingAppointments,  String dashboardBackground,  double backgroundOpacity,  double containerOpacity,  double widgetOpacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSettings() when $default != null:
return $default(_that.showCustomerPhone,_that.enableCheckoutNotifications,_that.fontSize,_that.technicianLayout,_that.serviceDisplayMode,_that.showTodaysSchedule,_that.showUpcomingAppointments,_that.dashboardBackground,_that.backgroundOpacity,_that.containerOpacity,_that.widgetOpacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showCustomerPhone,  bool enableCheckoutNotifications,  String fontSize,  String technicianLayout,  String serviceDisplayMode,  bool showTodaysSchedule,  bool showUpcomingAppointments,  String dashboardBackground,  double backgroundOpacity,  double containerOpacity,  double widgetOpacity)  $default,) {final _that = this;
switch (_that) {
case _DashboardSettings():
return $default(_that.showCustomerPhone,_that.enableCheckoutNotifications,_that.fontSize,_that.technicianLayout,_that.serviceDisplayMode,_that.showTodaysSchedule,_that.showUpcomingAppointments,_that.dashboardBackground,_that.backgroundOpacity,_that.containerOpacity,_that.widgetOpacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showCustomerPhone,  bool enableCheckoutNotifications,  String fontSize,  String technicianLayout,  String serviceDisplayMode,  bool showTodaysSchedule,  bool showUpcomingAppointments,  String dashboardBackground,  double backgroundOpacity,  double containerOpacity,  double widgetOpacity)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSettings() when $default != null:
return $default(_that.showCustomerPhone,_that.enableCheckoutNotifications,_that.fontSize,_that.technicianLayout,_that.serviceDisplayMode,_that.showTodaysSchedule,_that.showUpcomingAppointments,_that.dashboardBackground,_that.backgroundOpacity,_that.containerOpacity,_that.widgetOpacity);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSettings extends DashboardSettings {
  const _DashboardSettings({this.showCustomerPhone = true, this.enableCheckoutNotifications = true, this.fontSize = 'medium', this.technicianLayout = 'grid2', this.serviceDisplayMode = 'pills', this.showTodaysSchedule = false, this.showUpcomingAppointments = true, this.dashboardBackground = 'none', this.backgroundOpacity = 1.0, this.containerOpacity = 0.65, this.widgetOpacity = 0.7}): super._();
  

@override@JsonKey() final  bool showCustomerPhone;
@override@JsonKey() final  bool enableCheckoutNotifications;
@override@JsonKey() final  String fontSize;
@override@JsonKey() final  String technicianLayout;
@override@JsonKey() final  String serviceDisplayMode;
@override@JsonKey() final  bool showTodaysSchedule;
@override@JsonKey() final  bool showUpcomingAppointments;
// Background and UI settings
@override@JsonKey() final  String dashboardBackground;
@override@JsonKey() final  double backgroundOpacity;
@override@JsonKey() final  double containerOpacity;
@override@JsonKey() final  double widgetOpacity;

/// Create a copy of DashboardSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSettingsCopyWith<_DashboardSettings> get copyWith => __$DashboardSettingsCopyWithImpl<_DashboardSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSettings&&(identical(other.showCustomerPhone, showCustomerPhone) || other.showCustomerPhone == showCustomerPhone)&&(identical(other.enableCheckoutNotifications, enableCheckoutNotifications) || other.enableCheckoutNotifications == enableCheckoutNotifications)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.technicianLayout, technicianLayout) || other.technicianLayout == technicianLayout)&&(identical(other.serviceDisplayMode, serviceDisplayMode) || other.serviceDisplayMode == serviceDisplayMode)&&(identical(other.showTodaysSchedule, showTodaysSchedule) || other.showTodaysSchedule == showTodaysSchedule)&&(identical(other.showUpcomingAppointments, showUpcomingAppointments) || other.showUpcomingAppointments == showUpcomingAppointments)&&(identical(other.dashboardBackground, dashboardBackground) || other.dashboardBackground == dashboardBackground)&&(identical(other.backgroundOpacity, backgroundOpacity) || other.backgroundOpacity == backgroundOpacity)&&(identical(other.containerOpacity, containerOpacity) || other.containerOpacity == containerOpacity)&&(identical(other.widgetOpacity, widgetOpacity) || other.widgetOpacity == widgetOpacity));
}


@override
int get hashCode => Object.hash(runtimeType,showCustomerPhone,enableCheckoutNotifications,fontSize,technicianLayout,serviceDisplayMode,showTodaysSchedule,showUpcomingAppointments,dashboardBackground,backgroundOpacity,containerOpacity,widgetOpacity);

@override
String toString() {
  return 'DashboardSettings(showCustomerPhone: $showCustomerPhone, enableCheckoutNotifications: $enableCheckoutNotifications, fontSize: $fontSize, technicianLayout: $technicianLayout, serviceDisplayMode: $serviceDisplayMode, showTodaysSchedule: $showTodaysSchedule, showUpcomingAppointments: $showUpcomingAppointments, dashboardBackground: $dashboardBackground, backgroundOpacity: $backgroundOpacity, containerOpacity: $containerOpacity, widgetOpacity: $widgetOpacity)';
}


}

/// @nodoc
abstract mixin class _$DashboardSettingsCopyWith<$Res> implements $DashboardSettingsCopyWith<$Res> {
  factory _$DashboardSettingsCopyWith(_DashboardSettings value, $Res Function(_DashboardSettings) _then) = __$DashboardSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool showCustomerPhone, bool enableCheckoutNotifications, String fontSize, String technicianLayout, String serviceDisplayMode, bool showTodaysSchedule, bool showUpcomingAppointments, String dashboardBackground, double backgroundOpacity, double containerOpacity, double widgetOpacity
});




}
/// @nodoc
class __$DashboardSettingsCopyWithImpl<$Res>
    implements _$DashboardSettingsCopyWith<$Res> {
  __$DashboardSettingsCopyWithImpl(this._self, this._then);

  final _DashboardSettings _self;
  final $Res Function(_DashboardSettings) _then;

/// Create a copy of DashboardSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showCustomerPhone = null,Object? enableCheckoutNotifications = null,Object? fontSize = null,Object? technicianLayout = null,Object? serviceDisplayMode = null,Object? showTodaysSchedule = null,Object? showUpcomingAppointments = null,Object? dashboardBackground = null,Object? backgroundOpacity = null,Object? containerOpacity = null,Object? widgetOpacity = null,}) {
  return _then(_DashboardSettings(
showCustomerPhone: null == showCustomerPhone ? _self.showCustomerPhone : showCustomerPhone // ignore: cast_nullable_to_non_nullable
as bool,enableCheckoutNotifications: null == enableCheckoutNotifications ? _self.enableCheckoutNotifications : enableCheckoutNotifications // ignore: cast_nullable_to_non_nullable
as bool,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as String,technicianLayout: null == technicianLayout ? _self.technicianLayout : technicianLayout // ignore: cast_nullable_to_non_nullable
as String,serviceDisplayMode: null == serviceDisplayMode ? _self.serviceDisplayMode : serviceDisplayMode // ignore: cast_nullable_to_non_nullable
as String,showTodaysSchedule: null == showTodaysSchedule ? _self.showTodaysSchedule : showTodaysSchedule // ignore: cast_nullable_to_non_nullable
as bool,showUpcomingAppointments: null == showUpcomingAppointments ? _self.showUpcomingAppointments : showUpcomingAppointments // ignore: cast_nullable_to_non_nullable
as bool,dashboardBackground: null == dashboardBackground ? _self.dashboardBackground : dashboardBackground // ignore: cast_nullable_to_non_nullable
as String,backgroundOpacity: null == backgroundOpacity ? _self.backgroundOpacity : backgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,containerOpacity: null == containerOpacity ? _self.containerOpacity : containerOpacity // ignore: cast_nullable_to_non_nullable
as double,widgetOpacity: null == widgetOpacity ? _self.widgetOpacity : widgetOpacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$StoreSettings {

 Map<String, dynamic> get storeHours; bool get onlineBooking; String get location; String get timezone; int get appointmentBuffer; bool get walkInsEnabled; int get maxDailyAppointments;
/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSettingsCopyWith<StoreSettings> get copyWith => _$StoreSettingsCopyWithImpl<StoreSettings>(this as StoreSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSettings&&const DeepCollectionEquality().equals(other.storeHours, storeHours)&&(identical(other.onlineBooking, onlineBooking) || other.onlineBooking == onlineBooking)&&(identical(other.location, location) || other.location == location)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.appointmentBuffer, appointmentBuffer) || other.appointmentBuffer == appointmentBuffer)&&(identical(other.walkInsEnabled, walkInsEnabled) || other.walkInsEnabled == walkInsEnabled)&&(identical(other.maxDailyAppointments, maxDailyAppointments) || other.maxDailyAppointments == maxDailyAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(storeHours),onlineBooking,location,timezone,appointmentBuffer,walkInsEnabled,maxDailyAppointments);

@override
String toString() {
  return 'StoreSettings(storeHours: $storeHours, onlineBooking: $onlineBooking, location: $location, timezone: $timezone, appointmentBuffer: $appointmentBuffer, walkInsEnabled: $walkInsEnabled, maxDailyAppointments: $maxDailyAppointments)';
}


}

/// @nodoc
abstract mixin class $StoreSettingsCopyWith<$Res>  {
  factory $StoreSettingsCopyWith(StoreSettings value, $Res Function(StoreSettings) _then) = _$StoreSettingsCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> storeHours, bool onlineBooking, String location, String timezone, int appointmentBuffer, bool walkInsEnabled, int maxDailyAppointments
});




}
/// @nodoc
class _$StoreSettingsCopyWithImpl<$Res>
    implements $StoreSettingsCopyWith<$Res> {
  _$StoreSettingsCopyWithImpl(this._self, this._then);

  final StoreSettings _self;
  final $Res Function(StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeHours = null,Object? onlineBooking = null,Object? location = null,Object? timezone = null,Object? appointmentBuffer = null,Object? walkInsEnabled = null,Object? maxDailyAppointments = null,}) {
  return _then(_self.copyWith(
storeHours: null == storeHours ? _self.storeHours : storeHours // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,onlineBooking: null == onlineBooking ? _self.onlineBooking : onlineBooking // ignore: cast_nullable_to_non_nullable
as bool,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,appointmentBuffer: null == appointmentBuffer ? _self.appointmentBuffer : appointmentBuffer // ignore: cast_nullable_to_non_nullable
as int,walkInsEnabled: null == walkInsEnabled ? _self.walkInsEnabled : walkInsEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxDailyAppointments: null == maxDailyAppointments ? _self.maxDailyAppointments : maxDailyAppointments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSettings].
extension StoreSettingsPatterns on StoreSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSettings value)  $default,){
final _that = this;
switch (_that) {
case _StoreSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> storeHours,  bool onlineBooking,  String location,  String timezone,  int appointmentBuffer,  bool walkInsEnabled,  int maxDailyAppointments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.storeHours,_that.onlineBooking,_that.location,_that.timezone,_that.appointmentBuffer,_that.walkInsEnabled,_that.maxDailyAppointments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> storeHours,  bool onlineBooking,  String location,  String timezone,  int appointmentBuffer,  bool walkInsEnabled,  int maxDailyAppointments)  $default,) {final _that = this;
switch (_that) {
case _StoreSettings():
return $default(_that.storeHours,_that.onlineBooking,_that.location,_that.timezone,_that.appointmentBuffer,_that.walkInsEnabled,_that.maxDailyAppointments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> storeHours,  bool onlineBooking,  String location,  String timezone,  int appointmentBuffer,  bool walkInsEnabled,  int maxDailyAppointments)?  $default,) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.storeHours,_that.onlineBooking,_that.location,_that.timezone,_that.appointmentBuffer,_that.walkInsEnabled,_that.maxDailyAppointments);case _:
  return null;

}
}

}

/// @nodoc


class _StoreSettings extends StoreSettings {
  const _StoreSettings({final  Map<String, dynamic> storeHours = const {}, this.onlineBooking = false, this.location = 'Main Location', this.timezone = 'America/New_York', this.appointmentBuffer = 15, this.walkInsEnabled = true, this.maxDailyAppointments = 50}): _storeHours = storeHours,super._();
  

 final  Map<String, dynamic> _storeHours;
@override@JsonKey() Map<String, dynamic> get storeHours {
  if (_storeHours is EqualUnmodifiableMapView) return _storeHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_storeHours);
}

@override@JsonKey() final  bool onlineBooking;
@override@JsonKey() final  String location;
@override@JsonKey() final  String timezone;
@override@JsonKey() final  int appointmentBuffer;
@override@JsonKey() final  bool walkInsEnabled;
@override@JsonKey() final  int maxDailyAppointments;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSettingsCopyWith<_StoreSettings> get copyWith => __$StoreSettingsCopyWithImpl<_StoreSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSettings&&const DeepCollectionEquality().equals(other._storeHours, _storeHours)&&(identical(other.onlineBooking, onlineBooking) || other.onlineBooking == onlineBooking)&&(identical(other.location, location) || other.location == location)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.appointmentBuffer, appointmentBuffer) || other.appointmentBuffer == appointmentBuffer)&&(identical(other.walkInsEnabled, walkInsEnabled) || other.walkInsEnabled == walkInsEnabled)&&(identical(other.maxDailyAppointments, maxDailyAppointments) || other.maxDailyAppointments == maxDailyAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_storeHours),onlineBooking,location,timezone,appointmentBuffer,walkInsEnabled,maxDailyAppointments);

@override
String toString() {
  return 'StoreSettings(storeHours: $storeHours, onlineBooking: $onlineBooking, location: $location, timezone: $timezone, appointmentBuffer: $appointmentBuffer, walkInsEnabled: $walkInsEnabled, maxDailyAppointments: $maxDailyAppointments)';
}


}

/// @nodoc
abstract mixin class _$StoreSettingsCopyWith<$Res> implements $StoreSettingsCopyWith<$Res> {
  factory _$StoreSettingsCopyWith(_StoreSettings value, $Res Function(_StoreSettings) _then) = __$StoreSettingsCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> storeHours, bool onlineBooking, String location, String timezone, int appointmentBuffer, bool walkInsEnabled, int maxDailyAppointments
});




}
/// @nodoc
class __$StoreSettingsCopyWithImpl<$Res>
    implements _$StoreSettingsCopyWith<$Res> {
  __$StoreSettingsCopyWithImpl(this._self, this._then);

  final _StoreSettings _self;
  final $Res Function(_StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeHours = null,Object? onlineBooking = null,Object? location = null,Object? timezone = null,Object? appointmentBuffer = null,Object? walkInsEnabled = null,Object? maxDailyAppointments = null,}) {
  return _then(_StoreSettings(
storeHours: null == storeHours ? _self._storeHours : storeHours // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,onlineBooking: null == onlineBooking ? _self.onlineBooking : onlineBooking // ignore: cast_nullable_to_non_nullable
as bool,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,appointmentBuffer: null == appointmentBuffer ? _self.appointmentBuffer : appointmentBuffer // ignore: cast_nullable_to_non_nullable
as int,walkInsEnabled: null == walkInsEnabled ? _self.walkInsEnabled : walkInsEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxDailyAppointments: null == maxDailyAppointments ? _self.maxDailyAppointments : maxDailyAppointments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$GeneralSettings {

 String get theme; bool get soundEffects; bool get animations; String get language; String get currency; String get dateFormat; String get timeFormat; int get defaultItemsPerPage;
/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralSettingsCopyWith<GeneralSettings> get copyWith => _$GeneralSettingsCopyWithImpl<GeneralSettings>(this as GeneralSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.soundEffects, soundEffects) || other.soundEffects == soundEffects)&&(identical(other.animations, animations) || other.animations == animations)&&(identical(other.language, language) || other.language == language)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.timeFormat, timeFormat) || other.timeFormat == timeFormat)&&(identical(other.defaultItemsPerPage, defaultItemsPerPage) || other.defaultItemsPerPage == defaultItemsPerPage));
}


@override
int get hashCode => Object.hash(runtimeType,theme,soundEffects,animations,language,currency,dateFormat,timeFormat,defaultItemsPerPage);

@override
String toString() {
  return 'GeneralSettings(theme: $theme, soundEffects: $soundEffects, animations: $animations, language: $language, currency: $currency, dateFormat: $dateFormat, timeFormat: $timeFormat, defaultItemsPerPage: $defaultItemsPerPage)';
}


}

/// @nodoc
abstract mixin class $GeneralSettingsCopyWith<$Res>  {
  factory $GeneralSettingsCopyWith(GeneralSettings value, $Res Function(GeneralSettings) _then) = _$GeneralSettingsCopyWithImpl;
@useResult
$Res call({
 String theme, bool soundEffects, bool animations, String language, String currency, String dateFormat, String timeFormat, int defaultItemsPerPage
});




}
/// @nodoc
class _$GeneralSettingsCopyWithImpl<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  _$GeneralSettingsCopyWithImpl(this._self, this._then);

  final GeneralSettings _self;
  final $Res Function(GeneralSettings) _then;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? soundEffects = null,Object? animations = null,Object? language = null,Object? currency = null,Object? dateFormat = null,Object? timeFormat = null,Object? defaultItemsPerPage = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,soundEffects: null == soundEffects ? _self.soundEffects : soundEffects // ignore: cast_nullable_to_non_nullable
as bool,animations: null == animations ? _self.animations : animations // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,timeFormat: null == timeFormat ? _self.timeFormat : timeFormat // ignore: cast_nullable_to_non_nullable
as String,defaultItemsPerPage: null == defaultItemsPerPage ? _self.defaultItemsPerPage : defaultItemsPerPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralSettings].
extension GeneralSettingsPatterns on GeneralSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralSettings value)  $default,){
final _that = this;
switch (_that) {
case _GeneralSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String theme,  bool soundEffects,  bool animations,  String language,  String currency,  String dateFormat,  String timeFormat,  int defaultItemsPerPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that.theme,_that.soundEffects,_that.animations,_that.language,_that.currency,_that.dateFormat,_that.timeFormat,_that.defaultItemsPerPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String theme,  bool soundEffects,  bool animations,  String language,  String currency,  String dateFormat,  String timeFormat,  int defaultItemsPerPage)  $default,) {final _that = this;
switch (_that) {
case _GeneralSettings():
return $default(_that.theme,_that.soundEffects,_that.animations,_that.language,_that.currency,_that.dateFormat,_that.timeFormat,_that.defaultItemsPerPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String theme,  bool soundEffects,  bool animations,  String language,  String currency,  String dateFormat,  String timeFormat,  int defaultItemsPerPage)?  $default,) {final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that.theme,_that.soundEffects,_that.animations,_that.language,_that.currency,_that.dateFormat,_that.timeFormat,_that.defaultItemsPerPage);case _:
  return null;

}
}

}

/// @nodoc


class _GeneralSettings extends GeneralSettings {
  const _GeneralSettings({this.theme = 'light', this.soundEffects = true, this.animations = true, this.language = 'en', this.currency = 'USD', this.dateFormat = 'MM/dd/yyyy', this.timeFormat = '12h', this.defaultItemsPerPage = 25}): super._();
  

@override@JsonKey() final  String theme;
@override@JsonKey() final  bool soundEffects;
@override@JsonKey() final  bool animations;
@override@JsonKey() final  String language;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String dateFormat;
@override@JsonKey() final  String timeFormat;
@override@JsonKey() final  int defaultItemsPerPage;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralSettingsCopyWith<_GeneralSettings> get copyWith => __$GeneralSettingsCopyWithImpl<_GeneralSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.soundEffects, soundEffects) || other.soundEffects == soundEffects)&&(identical(other.animations, animations) || other.animations == animations)&&(identical(other.language, language) || other.language == language)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.timeFormat, timeFormat) || other.timeFormat == timeFormat)&&(identical(other.defaultItemsPerPage, defaultItemsPerPage) || other.defaultItemsPerPage == defaultItemsPerPage));
}


@override
int get hashCode => Object.hash(runtimeType,theme,soundEffects,animations,language,currency,dateFormat,timeFormat,defaultItemsPerPage);

@override
String toString() {
  return 'GeneralSettings(theme: $theme, soundEffects: $soundEffects, animations: $animations, language: $language, currency: $currency, dateFormat: $dateFormat, timeFormat: $timeFormat, defaultItemsPerPage: $defaultItemsPerPage)';
}


}

/// @nodoc
abstract mixin class _$GeneralSettingsCopyWith<$Res> implements $GeneralSettingsCopyWith<$Res> {
  factory _$GeneralSettingsCopyWith(_GeneralSettings value, $Res Function(_GeneralSettings) _then) = __$GeneralSettingsCopyWithImpl;
@override @useResult
$Res call({
 String theme, bool soundEffects, bool animations, String language, String currency, String dateFormat, String timeFormat, int defaultItemsPerPage
});




}
/// @nodoc
class __$GeneralSettingsCopyWithImpl<$Res>
    implements _$GeneralSettingsCopyWith<$Res> {
  __$GeneralSettingsCopyWithImpl(this._self, this._then);

  final _GeneralSettings _self;
  final $Res Function(_GeneralSettings) _then;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? soundEffects = null,Object? animations = null,Object? language = null,Object? currency = null,Object? dateFormat = null,Object? timeFormat = null,Object? defaultItemsPerPage = null,}) {
  return _then(_GeneralSettings(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,soundEffects: null == soundEffects ? _self.soundEffects : soundEffects // ignore: cast_nullable_to_non_nullable
as bool,animations: null == animations ? _self.animations : animations // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,timeFormat: null == timeFormat ? _self.timeFormat : timeFormat // ignore: cast_nullable_to_non_nullable
as String,defaultItemsPerPage: null == defaultItemsPerPage ? _self.defaultItemsPerPage : defaultItemsPerPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SalonSettings {

 int get serviceDurationBuffer; bool get requireTechnicianSpecialization; bool get autoCheckoutCompleted; bool get loyaltyPointsEnabled; double get loyaltyPointsRatio; bool get requireAppointmentConfirmation; int get reminderHoursBefore; bool get groupBookingEnabled; int get maxGroupSize; String get priceDisplayMode;// Customer data collection settings (moved from separate provider)
 bool get collectCustomerAddress; bool get collectCustomerDateOfBirth; bool get collectCustomerGender; bool get collectCustomerAllergies;
/// Create a copy of SalonSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonSettingsCopyWith<SalonSettings> get copyWith => _$SalonSettingsCopyWithImpl<SalonSettings>(this as SalonSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonSettings&&(identical(other.serviceDurationBuffer, serviceDurationBuffer) || other.serviceDurationBuffer == serviceDurationBuffer)&&(identical(other.requireTechnicianSpecialization, requireTechnicianSpecialization) || other.requireTechnicianSpecialization == requireTechnicianSpecialization)&&(identical(other.autoCheckoutCompleted, autoCheckoutCompleted) || other.autoCheckoutCompleted == autoCheckoutCompleted)&&(identical(other.loyaltyPointsEnabled, loyaltyPointsEnabled) || other.loyaltyPointsEnabled == loyaltyPointsEnabled)&&(identical(other.loyaltyPointsRatio, loyaltyPointsRatio) || other.loyaltyPointsRatio == loyaltyPointsRatio)&&(identical(other.requireAppointmentConfirmation, requireAppointmentConfirmation) || other.requireAppointmentConfirmation == requireAppointmentConfirmation)&&(identical(other.reminderHoursBefore, reminderHoursBefore) || other.reminderHoursBefore == reminderHoursBefore)&&(identical(other.groupBookingEnabled, groupBookingEnabled) || other.groupBookingEnabled == groupBookingEnabled)&&(identical(other.maxGroupSize, maxGroupSize) || other.maxGroupSize == maxGroupSize)&&(identical(other.priceDisplayMode, priceDisplayMode) || other.priceDisplayMode == priceDisplayMode)&&(identical(other.collectCustomerAddress, collectCustomerAddress) || other.collectCustomerAddress == collectCustomerAddress)&&(identical(other.collectCustomerDateOfBirth, collectCustomerDateOfBirth) || other.collectCustomerDateOfBirth == collectCustomerDateOfBirth)&&(identical(other.collectCustomerGender, collectCustomerGender) || other.collectCustomerGender == collectCustomerGender)&&(identical(other.collectCustomerAllergies, collectCustomerAllergies) || other.collectCustomerAllergies == collectCustomerAllergies));
}


@override
int get hashCode => Object.hash(runtimeType,serviceDurationBuffer,requireTechnicianSpecialization,autoCheckoutCompleted,loyaltyPointsEnabled,loyaltyPointsRatio,requireAppointmentConfirmation,reminderHoursBefore,groupBookingEnabled,maxGroupSize,priceDisplayMode,collectCustomerAddress,collectCustomerDateOfBirth,collectCustomerGender,collectCustomerAllergies);

@override
String toString() {
  return 'SalonSettings(serviceDurationBuffer: $serviceDurationBuffer, requireTechnicianSpecialization: $requireTechnicianSpecialization, autoCheckoutCompleted: $autoCheckoutCompleted, loyaltyPointsEnabled: $loyaltyPointsEnabled, loyaltyPointsRatio: $loyaltyPointsRatio, requireAppointmentConfirmation: $requireAppointmentConfirmation, reminderHoursBefore: $reminderHoursBefore, groupBookingEnabled: $groupBookingEnabled, maxGroupSize: $maxGroupSize, priceDisplayMode: $priceDisplayMode, collectCustomerAddress: $collectCustomerAddress, collectCustomerDateOfBirth: $collectCustomerDateOfBirth, collectCustomerGender: $collectCustomerGender, collectCustomerAllergies: $collectCustomerAllergies)';
}


}

/// @nodoc
abstract mixin class $SalonSettingsCopyWith<$Res>  {
  factory $SalonSettingsCopyWith(SalonSettings value, $Res Function(SalonSettings) _then) = _$SalonSettingsCopyWithImpl;
@useResult
$Res call({
 int serviceDurationBuffer, bool requireTechnicianSpecialization, bool autoCheckoutCompleted, bool loyaltyPointsEnabled, double loyaltyPointsRatio, bool requireAppointmentConfirmation, int reminderHoursBefore, bool groupBookingEnabled, int maxGroupSize, String priceDisplayMode, bool collectCustomerAddress, bool collectCustomerDateOfBirth, bool collectCustomerGender, bool collectCustomerAllergies
});




}
/// @nodoc
class _$SalonSettingsCopyWithImpl<$Res>
    implements $SalonSettingsCopyWith<$Res> {
  _$SalonSettingsCopyWithImpl(this._self, this._then);

  final SalonSettings _self;
  final $Res Function(SalonSettings) _then;

/// Create a copy of SalonSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceDurationBuffer = null,Object? requireTechnicianSpecialization = null,Object? autoCheckoutCompleted = null,Object? loyaltyPointsEnabled = null,Object? loyaltyPointsRatio = null,Object? requireAppointmentConfirmation = null,Object? reminderHoursBefore = null,Object? groupBookingEnabled = null,Object? maxGroupSize = null,Object? priceDisplayMode = null,Object? collectCustomerAddress = null,Object? collectCustomerDateOfBirth = null,Object? collectCustomerGender = null,Object? collectCustomerAllergies = null,}) {
  return _then(_self.copyWith(
serviceDurationBuffer: null == serviceDurationBuffer ? _self.serviceDurationBuffer : serviceDurationBuffer // ignore: cast_nullable_to_non_nullable
as int,requireTechnicianSpecialization: null == requireTechnicianSpecialization ? _self.requireTechnicianSpecialization : requireTechnicianSpecialization // ignore: cast_nullable_to_non_nullable
as bool,autoCheckoutCompleted: null == autoCheckoutCompleted ? _self.autoCheckoutCompleted : autoCheckoutCompleted // ignore: cast_nullable_to_non_nullable
as bool,loyaltyPointsEnabled: null == loyaltyPointsEnabled ? _self.loyaltyPointsEnabled : loyaltyPointsEnabled // ignore: cast_nullable_to_non_nullable
as bool,loyaltyPointsRatio: null == loyaltyPointsRatio ? _self.loyaltyPointsRatio : loyaltyPointsRatio // ignore: cast_nullable_to_non_nullable
as double,requireAppointmentConfirmation: null == requireAppointmentConfirmation ? _self.requireAppointmentConfirmation : requireAppointmentConfirmation // ignore: cast_nullable_to_non_nullable
as bool,reminderHoursBefore: null == reminderHoursBefore ? _self.reminderHoursBefore : reminderHoursBefore // ignore: cast_nullable_to_non_nullable
as int,groupBookingEnabled: null == groupBookingEnabled ? _self.groupBookingEnabled : groupBookingEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxGroupSize: null == maxGroupSize ? _self.maxGroupSize : maxGroupSize // ignore: cast_nullable_to_non_nullable
as int,priceDisplayMode: null == priceDisplayMode ? _self.priceDisplayMode : priceDisplayMode // ignore: cast_nullable_to_non_nullable
as String,collectCustomerAddress: null == collectCustomerAddress ? _self.collectCustomerAddress : collectCustomerAddress // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerDateOfBirth: null == collectCustomerDateOfBirth ? _self.collectCustomerDateOfBirth : collectCustomerDateOfBirth // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerGender: null == collectCustomerGender ? _self.collectCustomerGender : collectCustomerGender // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerAllergies: null == collectCustomerAllergies ? _self.collectCustomerAllergies : collectCustomerAllergies // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonSettings].
extension SalonSettingsPatterns on SalonSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonSettings value)  $default,){
final _that = this;
switch (_that) {
case _SalonSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SalonSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int serviceDurationBuffer,  bool requireTechnicianSpecialization,  bool autoCheckoutCompleted,  bool loyaltyPointsEnabled,  double loyaltyPointsRatio,  bool requireAppointmentConfirmation,  int reminderHoursBefore,  bool groupBookingEnabled,  int maxGroupSize,  String priceDisplayMode,  bool collectCustomerAddress,  bool collectCustomerDateOfBirth,  bool collectCustomerGender,  bool collectCustomerAllergies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonSettings() when $default != null:
return $default(_that.serviceDurationBuffer,_that.requireTechnicianSpecialization,_that.autoCheckoutCompleted,_that.loyaltyPointsEnabled,_that.loyaltyPointsRatio,_that.requireAppointmentConfirmation,_that.reminderHoursBefore,_that.groupBookingEnabled,_that.maxGroupSize,_that.priceDisplayMode,_that.collectCustomerAddress,_that.collectCustomerDateOfBirth,_that.collectCustomerGender,_that.collectCustomerAllergies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int serviceDurationBuffer,  bool requireTechnicianSpecialization,  bool autoCheckoutCompleted,  bool loyaltyPointsEnabled,  double loyaltyPointsRatio,  bool requireAppointmentConfirmation,  int reminderHoursBefore,  bool groupBookingEnabled,  int maxGroupSize,  String priceDisplayMode,  bool collectCustomerAddress,  bool collectCustomerDateOfBirth,  bool collectCustomerGender,  bool collectCustomerAllergies)  $default,) {final _that = this;
switch (_that) {
case _SalonSettings():
return $default(_that.serviceDurationBuffer,_that.requireTechnicianSpecialization,_that.autoCheckoutCompleted,_that.loyaltyPointsEnabled,_that.loyaltyPointsRatio,_that.requireAppointmentConfirmation,_that.reminderHoursBefore,_that.groupBookingEnabled,_that.maxGroupSize,_that.priceDisplayMode,_that.collectCustomerAddress,_that.collectCustomerDateOfBirth,_that.collectCustomerGender,_that.collectCustomerAllergies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int serviceDurationBuffer,  bool requireTechnicianSpecialization,  bool autoCheckoutCompleted,  bool loyaltyPointsEnabled,  double loyaltyPointsRatio,  bool requireAppointmentConfirmation,  int reminderHoursBefore,  bool groupBookingEnabled,  int maxGroupSize,  String priceDisplayMode,  bool collectCustomerAddress,  bool collectCustomerDateOfBirth,  bool collectCustomerGender,  bool collectCustomerAllergies)?  $default,) {final _that = this;
switch (_that) {
case _SalonSettings() when $default != null:
return $default(_that.serviceDurationBuffer,_that.requireTechnicianSpecialization,_that.autoCheckoutCompleted,_that.loyaltyPointsEnabled,_that.loyaltyPointsRatio,_that.requireAppointmentConfirmation,_that.reminderHoursBefore,_that.groupBookingEnabled,_that.maxGroupSize,_that.priceDisplayMode,_that.collectCustomerAddress,_that.collectCustomerDateOfBirth,_that.collectCustomerGender,_that.collectCustomerAllergies);case _:
  return null;

}
}

}

/// @nodoc


class _SalonSettings extends SalonSettings {
  const _SalonSettings({this.serviceDurationBuffer = 5, this.requireTechnicianSpecialization = false, this.autoCheckoutCompleted = false, this.loyaltyPointsEnabled = true, this.loyaltyPointsRatio = 1.0, this.requireAppointmentConfirmation = true, this.reminderHoursBefore = 24, this.groupBookingEnabled = true, this.maxGroupSize = 8, this.priceDisplayMode = 'individual', this.collectCustomerAddress = true, this.collectCustomerDateOfBirth = true, this.collectCustomerGender = true, this.collectCustomerAllergies = true}): super._();
  

@override@JsonKey() final  int serviceDurationBuffer;
@override@JsonKey() final  bool requireTechnicianSpecialization;
@override@JsonKey() final  bool autoCheckoutCompleted;
@override@JsonKey() final  bool loyaltyPointsEnabled;
@override@JsonKey() final  double loyaltyPointsRatio;
@override@JsonKey() final  bool requireAppointmentConfirmation;
@override@JsonKey() final  int reminderHoursBefore;
@override@JsonKey() final  bool groupBookingEnabled;
@override@JsonKey() final  int maxGroupSize;
@override@JsonKey() final  String priceDisplayMode;
// Customer data collection settings (moved from separate provider)
@override@JsonKey() final  bool collectCustomerAddress;
@override@JsonKey() final  bool collectCustomerDateOfBirth;
@override@JsonKey() final  bool collectCustomerGender;
@override@JsonKey() final  bool collectCustomerAllergies;

/// Create a copy of SalonSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonSettingsCopyWith<_SalonSettings> get copyWith => __$SalonSettingsCopyWithImpl<_SalonSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonSettings&&(identical(other.serviceDurationBuffer, serviceDurationBuffer) || other.serviceDurationBuffer == serviceDurationBuffer)&&(identical(other.requireTechnicianSpecialization, requireTechnicianSpecialization) || other.requireTechnicianSpecialization == requireTechnicianSpecialization)&&(identical(other.autoCheckoutCompleted, autoCheckoutCompleted) || other.autoCheckoutCompleted == autoCheckoutCompleted)&&(identical(other.loyaltyPointsEnabled, loyaltyPointsEnabled) || other.loyaltyPointsEnabled == loyaltyPointsEnabled)&&(identical(other.loyaltyPointsRatio, loyaltyPointsRatio) || other.loyaltyPointsRatio == loyaltyPointsRatio)&&(identical(other.requireAppointmentConfirmation, requireAppointmentConfirmation) || other.requireAppointmentConfirmation == requireAppointmentConfirmation)&&(identical(other.reminderHoursBefore, reminderHoursBefore) || other.reminderHoursBefore == reminderHoursBefore)&&(identical(other.groupBookingEnabled, groupBookingEnabled) || other.groupBookingEnabled == groupBookingEnabled)&&(identical(other.maxGroupSize, maxGroupSize) || other.maxGroupSize == maxGroupSize)&&(identical(other.priceDisplayMode, priceDisplayMode) || other.priceDisplayMode == priceDisplayMode)&&(identical(other.collectCustomerAddress, collectCustomerAddress) || other.collectCustomerAddress == collectCustomerAddress)&&(identical(other.collectCustomerDateOfBirth, collectCustomerDateOfBirth) || other.collectCustomerDateOfBirth == collectCustomerDateOfBirth)&&(identical(other.collectCustomerGender, collectCustomerGender) || other.collectCustomerGender == collectCustomerGender)&&(identical(other.collectCustomerAllergies, collectCustomerAllergies) || other.collectCustomerAllergies == collectCustomerAllergies));
}


@override
int get hashCode => Object.hash(runtimeType,serviceDurationBuffer,requireTechnicianSpecialization,autoCheckoutCompleted,loyaltyPointsEnabled,loyaltyPointsRatio,requireAppointmentConfirmation,reminderHoursBefore,groupBookingEnabled,maxGroupSize,priceDisplayMode,collectCustomerAddress,collectCustomerDateOfBirth,collectCustomerGender,collectCustomerAllergies);

@override
String toString() {
  return 'SalonSettings(serviceDurationBuffer: $serviceDurationBuffer, requireTechnicianSpecialization: $requireTechnicianSpecialization, autoCheckoutCompleted: $autoCheckoutCompleted, loyaltyPointsEnabled: $loyaltyPointsEnabled, loyaltyPointsRatio: $loyaltyPointsRatio, requireAppointmentConfirmation: $requireAppointmentConfirmation, reminderHoursBefore: $reminderHoursBefore, groupBookingEnabled: $groupBookingEnabled, maxGroupSize: $maxGroupSize, priceDisplayMode: $priceDisplayMode, collectCustomerAddress: $collectCustomerAddress, collectCustomerDateOfBirth: $collectCustomerDateOfBirth, collectCustomerGender: $collectCustomerGender, collectCustomerAllergies: $collectCustomerAllergies)';
}


}

/// @nodoc
abstract mixin class _$SalonSettingsCopyWith<$Res> implements $SalonSettingsCopyWith<$Res> {
  factory _$SalonSettingsCopyWith(_SalonSettings value, $Res Function(_SalonSettings) _then) = __$SalonSettingsCopyWithImpl;
@override @useResult
$Res call({
 int serviceDurationBuffer, bool requireTechnicianSpecialization, bool autoCheckoutCompleted, bool loyaltyPointsEnabled, double loyaltyPointsRatio, bool requireAppointmentConfirmation, int reminderHoursBefore, bool groupBookingEnabled, int maxGroupSize, String priceDisplayMode, bool collectCustomerAddress, bool collectCustomerDateOfBirth, bool collectCustomerGender, bool collectCustomerAllergies
});




}
/// @nodoc
class __$SalonSettingsCopyWithImpl<$Res>
    implements _$SalonSettingsCopyWith<$Res> {
  __$SalonSettingsCopyWithImpl(this._self, this._then);

  final _SalonSettings _self;
  final $Res Function(_SalonSettings) _then;

/// Create a copy of SalonSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceDurationBuffer = null,Object? requireTechnicianSpecialization = null,Object? autoCheckoutCompleted = null,Object? loyaltyPointsEnabled = null,Object? loyaltyPointsRatio = null,Object? requireAppointmentConfirmation = null,Object? reminderHoursBefore = null,Object? groupBookingEnabled = null,Object? maxGroupSize = null,Object? priceDisplayMode = null,Object? collectCustomerAddress = null,Object? collectCustomerDateOfBirth = null,Object? collectCustomerGender = null,Object? collectCustomerAllergies = null,}) {
  return _then(_SalonSettings(
serviceDurationBuffer: null == serviceDurationBuffer ? _self.serviceDurationBuffer : serviceDurationBuffer // ignore: cast_nullable_to_non_nullable
as int,requireTechnicianSpecialization: null == requireTechnicianSpecialization ? _self.requireTechnicianSpecialization : requireTechnicianSpecialization // ignore: cast_nullable_to_non_nullable
as bool,autoCheckoutCompleted: null == autoCheckoutCompleted ? _self.autoCheckoutCompleted : autoCheckoutCompleted // ignore: cast_nullable_to_non_nullable
as bool,loyaltyPointsEnabled: null == loyaltyPointsEnabled ? _self.loyaltyPointsEnabled : loyaltyPointsEnabled // ignore: cast_nullable_to_non_nullable
as bool,loyaltyPointsRatio: null == loyaltyPointsRatio ? _self.loyaltyPointsRatio : loyaltyPointsRatio // ignore: cast_nullable_to_non_nullable
as double,requireAppointmentConfirmation: null == requireAppointmentConfirmation ? _self.requireAppointmentConfirmation : requireAppointmentConfirmation // ignore: cast_nullable_to_non_nullable
as bool,reminderHoursBefore: null == reminderHoursBefore ? _self.reminderHoursBefore : reminderHoursBefore // ignore: cast_nullable_to_non_nullable
as int,groupBookingEnabled: null == groupBookingEnabled ? _self.groupBookingEnabled : groupBookingEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxGroupSize: null == maxGroupSize ? _self.maxGroupSize : maxGroupSize // ignore: cast_nullable_to_non_nullable
as int,priceDisplayMode: null == priceDisplayMode ? _self.priceDisplayMode : priceDisplayMode // ignore: cast_nullable_to_non_nullable
as String,collectCustomerAddress: null == collectCustomerAddress ? _self.collectCustomerAddress : collectCustomerAddress // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerDateOfBirth: null == collectCustomerDateOfBirth ? _self.collectCustomerDateOfBirth : collectCustomerDateOfBirth // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerGender: null == collectCustomerGender ? _self.collectCustomerGender : collectCustomerGender // ignore: cast_nullable_to_non_nullable
as bool,collectCustomerAllergies: null == collectCustomerAllergies ? _self.collectCustomerAllergies : collectCustomerAllergies // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
