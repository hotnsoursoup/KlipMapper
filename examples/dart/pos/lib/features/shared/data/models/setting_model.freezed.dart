// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreSetting {

 String get key; String get value; String? get category; String? get dataType; String? get description; bool get isSystem; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StoreSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSettingCopyWith<StoreSetting> get copyWith => _$StoreSettingCopyWithImpl<StoreSetting>(this as StoreSetting, _$identity);

  /// Serializes this StoreSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSetting&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.category, category) || other.category == category)&&(identical(other.dataType, dataType) || other.dataType == dataType)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,category,dataType,description,isSystem,createdAt,updatedAt);

@override
String toString() {
  return 'StoreSetting(key: $key, value: $value, category: $category, dataType: $dataType, description: $description, isSystem: $isSystem, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StoreSettingCopyWith<$Res>  {
  factory $StoreSettingCopyWith(StoreSetting value, $Res Function(StoreSetting) _then) = _$StoreSettingCopyWithImpl;
@useResult
$Res call({
 String key, String value, String? category, String? dataType, String? description, bool isSystem, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StoreSettingCopyWithImpl<$Res>
    implements $StoreSettingCopyWith<$Res> {
  _$StoreSettingCopyWithImpl(this._self, this._then);

  final StoreSetting _self;
  final $Res Function(StoreSetting) _then;

/// Create a copy of StoreSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,Object? category = freezed,Object? dataType = freezed,Object? description = freezed,Object? isSystem = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,dataType: freezed == dataType ? _self.dataType : dataType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSetting].
extension StoreSettingPatterns on StoreSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSetting value)  $default,){
final _that = this;
switch (_that) {
case _StoreSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSetting value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String value,  String? category,  String? dataType,  String? description,  bool isSystem,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSetting() when $default != null:
return $default(_that.key,_that.value,_that.category,_that.dataType,_that.description,_that.isSystem,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String value,  String? category,  String? dataType,  String? description,  bool isSystem,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StoreSetting():
return $default(_that.key,_that.value,_that.category,_that.dataType,_that.description,_that.isSystem,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String value,  String? category,  String? dataType,  String? description,  bool isSystem,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StoreSetting() when $default != null:
return $default(_that.key,_that.value,_that.category,_that.dataType,_that.description,_that.isSystem,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreSetting extends StoreSetting {
  const _StoreSetting({required this.key, required this.value, this.category, this.dataType, this.description, this.isSystem = false, required this.createdAt, required this.updatedAt}): super._();
  factory _StoreSetting.fromJson(Map<String, dynamic> json) => _$StoreSettingFromJson(json);

@override final  String key;
@override final  String value;
@override final  String? category;
@override final  String? dataType;
@override final  String? description;
@override@JsonKey() final  bool isSystem;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StoreSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSettingCopyWith<_StoreSetting> get copyWith => __$StoreSettingCopyWithImpl<_StoreSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSetting&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.category, category) || other.category == category)&&(identical(other.dataType, dataType) || other.dataType == dataType)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,category,dataType,description,isSystem,createdAt,updatedAt);

@override
String toString() {
  return 'StoreSetting(key: $key, value: $value, category: $category, dataType: $dataType, description: $description, isSystem: $isSystem, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StoreSettingCopyWith<$Res> implements $StoreSettingCopyWith<$Res> {
  factory _$StoreSettingCopyWith(_StoreSetting value, $Res Function(_StoreSetting) _then) = __$StoreSettingCopyWithImpl;
@override @useResult
$Res call({
 String key, String value, String? category, String? dataType, String? description, bool isSystem, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StoreSettingCopyWithImpl<$Res>
    implements _$StoreSettingCopyWith<$Res> {
  __$StoreSettingCopyWithImpl(this._self, this._then);

  final _StoreSetting _self;
  final $Res Function(_StoreSetting) _then;

/// Create a copy of StoreSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,Object? category = freezed,Object? dataType = freezed,Object? description = freezed,Object? isSystem = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StoreSetting(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,dataType: freezed == dataType ? _self.dataType : dataType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StoreHours {

 Map<String, DayHours> get hours;
/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreHoursCopyWith<StoreHours> get copyWith => _$StoreHoursCopyWithImpl<StoreHours>(this as StoreHours, _$identity);

  /// Serializes this StoreHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreHours&&const DeepCollectionEquality().equals(other.hours, hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(hours));

@override
String toString() {
  return 'StoreHours(hours: $hours)';
}


}

/// @nodoc
abstract mixin class $StoreHoursCopyWith<$Res>  {
  factory $StoreHoursCopyWith(StoreHours value, $Res Function(StoreHours) _then) = _$StoreHoursCopyWithImpl;
@useResult
$Res call({
 Map<String, DayHours> hours
});




}
/// @nodoc
class _$StoreHoursCopyWithImpl<$Res>
    implements $StoreHoursCopyWith<$Res> {
  _$StoreHoursCopyWithImpl(this._self, this._then);

  final StoreHours _self;
  final $Res Function(StoreHours) _then;

/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hours = null,}) {
  return _then(_self.copyWith(
hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as Map<String, DayHours>,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreHours].
extension StoreHoursPatterns on StoreHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreHours value)  $default,){
final _that = this;
switch (_that) {
case _StoreHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreHours value)?  $default,){
final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, DayHours> hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
return $default(_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, DayHours> hours)  $default,) {final _that = this;
switch (_that) {
case _StoreHours():
return $default(_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, DayHours> hours)?  $default,) {final _that = this;
switch (_that) {
case _StoreHours() when $default != null:
return $default(_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreHours extends StoreHours {
  const _StoreHours({final  Map<String, DayHours> hours = const {}}): _hours = hours,super._();
  factory _StoreHours.fromJson(Map<String, dynamic> json) => _$StoreHoursFromJson(json);

 final  Map<String, DayHours> _hours;
@override@JsonKey() Map<String, DayHours> get hours {
  if (_hours is EqualUnmodifiableMapView) return _hours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hours);
}


/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreHoursCopyWith<_StoreHours> get copyWith => __$StoreHoursCopyWithImpl<_StoreHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreHours&&const DeepCollectionEquality().equals(other._hours, _hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_hours));

@override
String toString() {
  return 'StoreHours(hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$StoreHoursCopyWith<$Res> implements $StoreHoursCopyWith<$Res> {
  factory _$StoreHoursCopyWith(_StoreHours value, $Res Function(_StoreHours) _then) = __$StoreHoursCopyWithImpl;
@override @useResult
$Res call({
 Map<String, DayHours> hours
});




}
/// @nodoc
class __$StoreHoursCopyWithImpl<$Res>
    implements _$StoreHoursCopyWith<$Res> {
  __$StoreHoursCopyWithImpl(this._self, this._then);

  final _StoreHours _self;
  final $Res Function(_StoreHours) _then;

/// Create a copy of StoreHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hours = null,}) {
  return _then(_StoreHours(
hours: null == hours ? _self._hours : hours // ignore: cast_nullable_to_non_nullable
as Map<String, DayHours>,
  ));
}


}


/// @nodoc
mixin _$DayHours {

 bool get isOpen; int? get openTime;// Minutes since midnight (e.g., 390 = 6:30 AM)
 int? get closeTime;
/// Create a copy of DayHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayHoursCopyWith<DayHours> get copyWith => _$DayHoursCopyWithImpl<DayHours>(this as DayHours, _$identity);

  /// Serializes this DayHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayHours&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOpen,openTime,closeTime);

@override
String toString() {
  return 'DayHours(isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime)';
}


}

/// @nodoc
abstract mixin class $DayHoursCopyWith<$Res>  {
  factory $DayHoursCopyWith(DayHours value, $Res Function(DayHours) _then) = _$DayHoursCopyWithImpl;
@useResult
$Res call({
 bool isOpen, int? openTime, int? closeTime
});




}
/// @nodoc
class _$DayHoursCopyWithImpl<$Res>
    implements $DayHoursCopyWith<$Res> {
  _$DayHoursCopyWithImpl(this._self, this._then);

  final DayHours _self;
  final $Res Function(DayHours) _then;

/// Create a copy of DayHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOpen = null,Object? openTime = freezed,Object? closeTime = freezed,}) {
  return _then(_self.copyWith(
isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayHours].
extension DayHoursPatterns on DayHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayHours value)  $default,){
final _that = this;
switch (_that) {
case _DayHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayHours value)?  $default,){
final _that = this;
switch (_that) {
case _DayHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOpen,  int? openTime,  int? closeTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayHours() when $default != null:
return $default(_that.isOpen,_that.openTime,_that.closeTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOpen,  int? openTime,  int? closeTime)  $default,) {final _that = this;
switch (_that) {
case _DayHours():
return $default(_that.isOpen,_that.openTime,_that.closeTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOpen,  int? openTime,  int? closeTime)?  $default,) {final _that = this;
switch (_that) {
case _DayHours() when $default != null:
return $default(_that.isOpen,_that.openTime,_that.closeTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayHours extends DayHours {
  const _DayHours({this.isOpen = false, this.openTime, this.closeTime}): super._();
  factory _DayHours.fromJson(Map<String, dynamic> json) => _$DayHoursFromJson(json);

@override@JsonKey() final  bool isOpen;
@override final  int? openTime;
// Minutes since midnight (e.g., 390 = 6:30 AM)
@override final  int? closeTime;

/// Create a copy of DayHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayHoursCopyWith<_DayHours> get copyWith => __$DayHoursCopyWithImpl<_DayHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayHours&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOpen,openTime,closeTime);

@override
String toString() {
  return 'DayHours(isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime)';
}


}

/// @nodoc
abstract mixin class _$DayHoursCopyWith<$Res> implements $DayHoursCopyWith<$Res> {
  factory _$DayHoursCopyWith(_DayHours value, $Res Function(_DayHours) _then) = __$DayHoursCopyWithImpl;
@override @useResult
$Res call({
 bool isOpen, int? openTime, int? closeTime
});




}
/// @nodoc
class __$DayHoursCopyWithImpl<$Res>
    implements _$DayHoursCopyWith<$Res> {
  __$DayHoursCopyWithImpl(this._self, this._then);

  final _DayHours _self;
  final $Res Function(_DayHours) _then;

/// Create a copy of DayHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOpen = null,Object? openTime = freezed,Object? closeTime = freezed,}) {
  return _then(_DayHours(
isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
