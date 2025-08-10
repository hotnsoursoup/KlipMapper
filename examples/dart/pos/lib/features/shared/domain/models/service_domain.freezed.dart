// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceDomain {

 String get id; String get name; String get description; int get durationMinutes; double get basePrice; int get categoryId;// Changed to int to match database schema
 bool get isActive; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of ServiceDomain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceDomainCopyWith<ServiceDomain> get copyWith => _$ServiceDomainCopyWithImpl<ServiceDomain>(this as ServiceDomain, _$identity);

  /// Serializes this ServiceDomain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,durationMinutes,basePrice,categoryId,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ServiceDomain(id: $id, name: $name, description: $description, durationMinutes: $durationMinutes, basePrice: $basePrice, categoryId: $categoryId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ServiceDomainCopyWith<$Res>  {
  factory $ServiceDomainCopyWith(ServiceDomain value, $Res Function(ServiceDomain) _then) = _$ServiceDomainCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int durationMinutes, double basePrice, int categoryId, bool isActive, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ServiceDomainCopyWithImpl<$Res>
    implements $ServiceDomainCopyWith<$Res> {
  _$ServiceDomainCopyWithImpl(this._self, this._then);

  final ServiceDomain _self;
  final $Res Function(ServiceDomain) _then;

/// Create a copy of ServiceDomain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? durationMinutes = null,Object? basePrice = null,Object? categoryId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceDomain].
extension ServiceDomainPatterns on ServiceDomain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceDomain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceDomain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceDomain value)  $default,){
final _that = this;
switch (_that) {
case _ServiceDomain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceDomain value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceDomain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int durationMinutes,  double basePrice,  int categoryId,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceDomain() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.durationMinutes,_that.basePrice,_that.categoryId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int durationMinutes,  double basePrice,  int categoryId,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceDomain():
return $default(_that.id,_that.name,_that.description,_that.durationMinutes,_that.basePrice,_that.categoryId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int durationMinutes,  double basePrice,  int categoryId,  bool isActive,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceDomain() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.durationMinutes,_that.basePrice,_that.categoryId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceDomain extends ServiceDomain {
  const _ServiceDomain({required this.id, required this.name, required this.description, required this.durationMinutes, required this.basePrice, required this.categoryId, this.isActive = true, required this.createdAt, this.updatedAt}): super._();
  factory _ServiceDomain.fromJson(Map<String, dynamic> json) => _$ServiceDomainFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  int durationMinutes;
@override final  double basePrice;
@override final  int categoryId;
// Changed to int to match database schema
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ServiceDomain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceDomainCopyWith<_ServiceDomain> get copyWith => __$ServiceDomainCopyWithImpl<_ServiceDomain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceDomainToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,durationMinutes,basePrice,categoryId,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ServiceDomain(id: $id, name: $name, description: $description, durationMinutes: $durationMinutes, basePrice: $basePrice, categoryId: $categoryId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceDomainCopyWith<$Res> implements $ServiceDomainCopyWith<$Res> {
  factory _$ServiceDomainCopyWith(_ServiceDomain value, $Res Function(_ServiceDomain) _then) = __$ServiceDomainCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int durationMinutes, double basePrice, int categoryId, bool isActive, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ServiceDomainCopyWithImpl<$Res>
    implements _$ServiceDomainCopyWith<$Res> {
  __$ServiceDomainCopyWithImpl(this._self, this._then);

  final _ServiceDomain _self;
  final $Res Function(_ServiceDomain) _then;

/// Create a copy of ServiceDomain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? durationMinutes = null,Object? basePrice = null,Object? categoryId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_ServiceDomain(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
