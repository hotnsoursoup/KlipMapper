// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_category_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCategoryDomain {

 String get id; String get name; String get colorHex; bool get isActive; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of ServiceCategoryDomain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCategoryDomainCopyWith<ServiceCategoryDomain> get copyWith => _$ServiceCategoryDomainCopyWithImpl<ServiceCategoryDomain>(this as ServiceCategoryDomain, _$identity);

  /// Serializes this ServiceCategoryDomain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCategoryDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,colorHex,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ServiceCategoryDomain(id: $id, name: $name, colorHex: $colorHex, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ServiceCategoryDomainCopyWith<$Res>  {
  factory $ServiceCategoryDomainCopyWith(ServiceCategoryDomain value, $Res Function(ServiceCategoryDomain) _then) = _$ServiceCategoryDomainCopyWithImpl;
@useResult
$Res call({
 String id, String name, String colorHex, bool isActive, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ServiceCategoryDomainCopyWithImpl<$Res>
    implements $ServiceCategoryDomainCopyWith<$Res> {
  _$ServiceCategoryDomainCopyWithImpl(this._self, this._then);

  final ServiceCategoryDomain _self;
  final $Res Function(ServiceCategoryDomain) _then;

/// Create a copy of ServiceCategoryDomain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorHex = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCategoryDomain].
extension ServiceCategoryDomainPatterns on ServiceCategoryDomain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCategoryDomain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCategoryDomain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCategoryDomain value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoryDomain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCategoryDomain value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoryDomain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String colorHex,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCategoryDomain() when $default != null:
return $default(_that.id,_that.name,_that.colorHex,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String colorHex,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoryDomain():
return $default(_that.id,_that.name,_that.colorHex,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String colorHex,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoryDomain() when $default != null:
return $default(_that.id,_that.name,_that.colorHex,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCategoryDomain extends ServiceCategoryDomain {
  const _ServiceCategoryDomain({required this.id, required this.name, this.colorHex = '#6B7280', this.isActive = true, required this.createdAt, this.updatedAt}): super._();
  factory _ServiceCategoryDomain.fromJson(Map<String, dynamic> json) => _$ServiceCategoryDomainFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String colorHex;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ServiceCategoryDomain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCategoryDomainCopyWith<_ServiceCategoryDomain> get copyWith => __$ServiceCategoryDomainCopyWithImpl<_ServiceCategoryDomain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCategoryDomainToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCategoryDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,colorHex,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ServiceCategoryDomain(id: $id, name: $name, colorHex: $colorHex, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceCategoryDomainCopyWith<$Res> implements $ServiceCategoryDomainCopyWith<$Res> {
  factory _$ServiceCategoryDomainCopyWith(_ServiceCategoryDomain value, $Res Function(_ServiceCategoryDomain) _then) = __$ServiceCategoryDomainCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String colorHex, bool isActive, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ServiceCategoryDomainCopyWithImpl<$Res>
    implements _$ServiceCategoryDomainCopyWith<$Res> {
  __$ServiceCategoryDomainCopyWithImpl(this._self, this._then);

  final _ServiceCategoryDomain _self;
  final $Res Function(_ServiceCategoryDomain) _then;

/// Create a copy of ServiceCategoryDomain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorHex = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_ServiceCategoryDomain(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
