// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seed_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCategorySeed {

 int get id; String get name; String get color; String get icon; String? get description;
/// Create a copy of ServiceCategorySeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCategorySeedCopyWith<ServiceCategorySeed> get copyWith => _$ServiceCategorySeedCopyWithImpl<ServiceCategorySeed>(this as ServiceCategorySeed, _$identity);

  /// Serializes this ServiceCategorySeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCategorySeed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,icon,description);

@override
String toString() {
  return 'ServiceCategorySeed(id: $id, name: $name, color: $color, icon: $icon, description: $description)';
}


}

/// @nodoc
abstract mixin class $ServiceCategorySeedCopyWith<$Res>  {
  factory $ServiceCategorySeedCopyWith(ServiceCategorySeed value, $Res Function(ServiceCategorySeed) _then) = _$ServiceCategorySeedCopyWithImpl;
@useResult
$Res call({
 int id, String name, String color, String icon, String? description
});




}
/// @nodoc
class _$ServiceCategorySeedCopyWithImpl<$Res>
    implements $ServiceCategorySeedCopyWith<$Res> {
  _$ServiceCategorySeedCopyWithImpl(this._self, this._then);

  final ServiceCategorySeed _self;
  final $Res Function(ServiceCategorySeed) _then;

/// Create a copy of ServiceCategorySeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? icon = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCategorySeed].
extension ServiceCategorySeedPatterns on ServiceCategorySeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCategorySeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCategorySeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCategorySeed value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCategorySeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCategorySeed value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCategorySeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String color,  String icon,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCategorySeed() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.icon,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String color,  String icon,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ServiceCategorySeed():
return $default(_that.id,_that.name,_that.color,_that.icon,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String color,  String icon,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCategorySeed() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.icon,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCategorySeed implements ServiceCategorySeed {
  const _ServiceCategorySeed({required this.id, required this.name, required this.color, required this.icon, this.description});
  factory _ServiceCategorySeed.fromJson(Map<String, dynamic> json) => _$ServiceCategorySeedFromJson(json);

@override final  int id;
@override final  String name;
@override final  String color;
@override final  String icon;
@override final  String? description;

/// Create a copy of ServiceCategorySeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCategorySeedCopyWith<_ServiceCategorySeed> get copyWith => __$ServiceCategorySeedCopyWithImpl<_ServiceCategorySeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCategorySeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCategorySeed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,icon,description);

@override
String toString() {
  return 'ServiceCategorySeed(id: $id, name: $name, color: $color, icon: $icon, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ServiceCategorySeedCopyWith<$Res> implements $ServiceCategorySeedCopyWith<$Res> {
  factory _$ServiceCategorySeedCopyWith(_ServiceCategorySeed value, $Res Function(_ServiceCategorySeed) _then) = __$ServiceCategorySeedCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String color, String icon, String? description
});




}
/// @nodoc
class __$ServiceCategorySeedCopyWithImpl<$Res>
    implements _$ServiceCategorySeedCopyWith<$Res> {
  __$ServiceCategorySeedCopyWithImpl(this._self, this._then);

  final _ServiceCategorySeed _self;
  final $Res Function(_ServiceCategorySeed) _then;

/// Create a copy of ServiceCategorySeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? icon = null,Object? description = freezed,}) {
  return _then(_ServiceCategorySeed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ServiceCategoriesSchema {

@JsonKey(name: 'schema_version') String get schemaVersion;@JsonKey(name: 'created_date') DateTime get createdDate; String get description; List<ServiceCategorySeed> get categories; ServiceCategoriesValidation? get validation;
/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCategoriesSchemaCopyWith<ServiceCategoriesSchema> get copyWith => _$ServiceCategoriesSchemaCopyWithImpl<ServiceCategoriesSchema>(this as ServiceCategoriesSchema, _$identity);

  /// Serializes this ServiceCategoriesSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCategoriesSchema&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.validation, validation) || other.validation == validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,createdDate,description,const DeepCollectionEquality().hash(categories),validation);

@override
String toString() {
  return 'ServiceCategoriesSchema(schemaVersion: $schemaVersion, createdDate: $createdDate, description: $description, categories: $categories, validation: $validation)';
}


}

/// @nodoc
abstract mixin class $ServiceCategoriesSchemaCopyWith<$Res>  {
  factory $ServiceCategoriesSchemaCopyWith(ServiceCategoriesSchema value, $Res Function(ServiceCategoriesSchema) _then) = _$ServiceCategoriesSchemaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'schema_version') String schemaVersion,@JsonKey(name: 'created_date') DateTime createdDate, String description, List<ServiceCategorySeed> categories, ServiceCategoriesValidation? validation
});


$ServiceCategoriesValidationCopyWith<$Res>? get validation;

}
/// @nodoc
class _$ServiceCategoriesSchemaCopyWithImpl<$Res>
    implements $ServiceCategoriesSchemaCopyWith<$Res> {
  _$ServiceCategoriesSchemaCopyWithImpl(this._self, this._then);

  final ServiceCategoriesSchema _self;
  final $Res Function(ServiceCategoriesSchema) _then;

/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? createdDate = null,Object? description = null,Object? categories = null,Object? validation = freezed,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<ServiceCategorySeed>,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as ServiceCategoriesValidation?,
  ));
}
/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCategoriesValidationCopyWith<$Res>? get validation {
    if (_self.validation == null) {
    return null;
  }

  return $ServiceCategoriesValidationCopyWith<$Res>(_self.validation!, (value) {
    return _then(_self.copyWith(validation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServiceCategoriesSchema].
extension ServiceCategoriesSchemaPatterns on ServiceCategoriesSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCategoriesSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCategoriesSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCategoriesSchema value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoriesSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCategoriesSchema value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoriesSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceCategorySeed> categories,  ServiceCategoriesValidation? validation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCategoriesSchema() when $default != null:
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.categories,_that.validation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceCategorySeed> categories,  ServiceCategoriesValidation? validation)  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoriesSchema():
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.categories,_that.validation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceCategorySeed> categories,  ServiceCategoriesValidation? validation)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoriesSchema() when $default != null:
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.categories,_that.validation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCategoriesSchema implements ServiceCategoriesSchema {
  const _ServiceCategoriesSchema({@JsonKey(name: 'schema_version') required this.schemaVersion, @JsonKey(name: 'created_date') required this.createdDate, required this.description, required final  List<ServiceCategorySeed> categories, this.validation}): _categories = categories;
  factory _ServiceCategoriesSchema.fromJson(Map<String, dynamic> json) => _$ServiceCategoriesSchemaFromJson(json);

@override@JsonKey(name: 'schema_version') final  String schemaVersion;
@override@JsonKey(name: 'created_date') final  DateTime createdDate;
@override final  String description;
 final  List<ServiceCategorySeed> _categories;
@override List<ServiceCategorySeed> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  ServiceCategoriesValidation? validation;

/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCategoriesSchemaCopyWith<_ServiceCategoriesSchema> get copyWith => __$ServiceCategoriesSchemaCopyWithImpl<_ServiceCategoriesSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCategoriesSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCategoriesSchema&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.validation, validation) || other.validation == validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,createdDate,description,const DeepCollectionEquality().hash(_categories),validation);

@override
String toString() {
  return 'ServiceCategoriesSchema(schemaVersion: $schemaVersion, createdDate: $createdDate, description: $description, categories: $categories, validation: $validation)';
}


}

/// @nodoc
abstract mixin class _$ServiceCategoriesSchemaCopyWith<$Res> implements $ServiceCategoriesSchemaCopyWith<$Res> {
  factory _$ServiceCategoriesSchemaCopyWith(_ServiceCategoriesSchema value, $Res Function(_ServiceCategoriesSchema) _then) = __$ServiceCategoriesSchemaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'schema_version') String schemaVersion,@JsonKey(name: 'created_date') DateTime createdDate, String description, List<ServiceCategorySeed> categories, ServiceCategoriesValidation? validation
});


@override $ServiceCategoriesValidationCopyWith<$Res>? get validation;

}
/// @nodoc
class __$ServiceCategoriesSchemaCopyWithImpl<$Res>
    implements _$ServiceCategoriesSchemaCopyWith<$Res> {
  __$ServiceCategoriesSchemaCopyWithImpl(this._self, this._then);

  final _ServiceCategoriesSchema _self;
  final $Res Function(_ServiceCategoriesSchema) _then;

/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? createdDate = null,Object? description = null,Object? categories = null,Object? validation = freezed,}) {
  return _then(_ServiceCategoriesSchema(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ServiceCategorySeed>,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as ServiceCategoriesValidation?,
  ));
}

/// Create a copy of ServiceCategoriesSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCategoriesValidationCopyWith<$Res>? get validation {
    if (_self.validation == null) {
    return null;
  }

  return $ServiceCategoriesValidationCopyWith<$Res>(_self.validation!, (value) {
    return _then(_self.copyWith(validation: value));
  });
}
}


/// @nodoc
mixin _$ServiceSeed {

 String get name; String? get description;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'duration_minutes') int get durationMinutes;@JsonKey(name: 'base_price_cents') int get basePriceCents;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ServiceSeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceSeedCopyWith<ServiceSeed> get copyWith => _$ServiceSeedCopyWithImpl<ServiceSeed>(this as ServiceSeed, _$identity);

  /// Serializes this ServiceSeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceSeed&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.basePriceCents, basePriceCents) || other.basePriceCents == basePriceCents)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,categoryId,durationMinutes,basePriceCents,isActive);

@override
String toString() {
  return 'ServiceSeed(name: $name, description: $description, categoryId: $categoryId, durationMinutes: $durationMinutes, basePriceCents: $basePriceCents, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ServiceSeedCopyWith<$Res>  {
  factory $ServiceSeedCopyWith(ServiceSeed value, $Res Function(ServiceSeed) _then) = _$ServiceSeedCopyWithImpl;
@useResult
$Res call({
 String name, String? description,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'base_price_cents') int basePriceCents,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ServiceSeedCopyWithImpl<$Res>
    implements $ServiceSeedCopyWith<$Res> {
  _$ServiceSeedCopyWithImpl(this._self, this._then);

  final ServiceSeed _self;
  final $Res Function(ServiceSeed) _then;

/// Create a copy of ServiceSeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? categoryId = null,Object? durationMinutes = null,Object? basePriceCents = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,basePriceCents: null == basePriceCents ? _self.basePriceCents : basePriceCents // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceSeed].
extension ServiceSeedPatterns on ServiceSeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceSeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceSeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceSeed value)  $default,){
final _that = this;
switch (_that) {
case _ServiceSeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceSeed value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceSeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'base_price_cents')  int basePriceCents, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceSeed() when $default != null:
return $default(_that.name,_that.description,_that.categoryId,_that.durationMinutes,_that.basePriceCents,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'base_price_cents')  int basePriceCents, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ServiceSeed():
return $default(_that.name,_that.description,_that.categoryId,_that.durationMinutes,_that.basePriceCents,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'base_price_cents')  int basePriceCents, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ServiceSeed() when $default != null:
return $default(_that.name,_that.description,_that.categoryId,_that.durationMinutes,_that.basePriceCents,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceSeed implements ServiceSeed {
  const _ServiceSeed({required this.name, this.description, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'duration_minutes') required this.durationMinutes, @JsonKey(name: 'base_price_cents') required this.basePriceCents, @JsonKey(name: 'is_active') this.isActive = true});
  factory _ServiceSeed.fromJson(Map<String, dynamic> json) => _$ServiceSeedFromJson(json);

@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'duration_minutes') final  int durationMinutes;
@override@JsonKey(name: 'base_price_cents') final  int basePriceCents;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ServiceSeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceSeedCopyWith<_ServiceSeed> get copyWith => __$ServiceSeedCopyWithImpl<_ServiceSeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceSeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceSeed&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.basePriceCents, basePriceCents) || other.basePriceCents == basePriceCents)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,categoryId,durationMinutes,basePriceCents,isActive);

@override
String toString() {
  return 'ServiceSeed(name: $name, description: $description, categoryId: $categoryId, durationMinutes: $durationMinutes, basePriceCents: $basePriceCents, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ServiceSeedCopyWith<$Res> implements $ServiceSeedCopyWith<$Res> {
  factory _$ServiceSeedCopyWith(_ServiceSeed value, $Res Function(_ServiceSeed) _then) = __$ServiceSeedCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'base_price_cents') int basePriceCents,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ServiceSeedCopyWithImpl<$Res>
    implements _$ServiceSeedCopyWith<$Res> {
  __$ServiceSeedCopyWithImpl(this._self, this._then);

  final _ServiceSeed _self;
  final $Res Function(_ServiceSeed) _then;

/// Create a copy of ServiceSeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? categoryId = null,Object? durationMinutes = null,Object? basePriceCents = null,Object? isActive = null,}) {
  return _then(_ServiceSeed(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,basePriceCents: null == basePriceCents ? _self.basePriceCents : basePriceCents // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ServicesSchema {

@JsonKey(name: 'schema_version') String get schemaVersion;@JsonKey(name: 'created_date') DateTime get createdDate; String get description; List<ServiceSeed> get services; ServicesValidation? get validation;
/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServicesSchemaCopyWith<ServicesSchema> get copyWith => _$ServicesSchemaCopyWithImpl<ServicesSchema>(this as ServicesSchema, _$identity);

  /// Serializes this ServicesSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServicesSchema&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.validation, validation) || other.validation == validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,createdDate,description,const DeepCollectionEquality().hash(services),validation);

@override
String toString() {
  return 'ServicesSchema(schemaVersion: $schemaVersion, createdDate: $createdDate, description: $description, services: $services, validation: $validation)';
}


}

/// @nodoc
abstract mixin class $ServicesSchemaCopyWith<$Res>  {
  factory $ServicesSchemaCopyWith(ServicesSchema value, $Res Function(ServicesSchema) _then) = _$ServicesSchemaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'schema_version') String schemaVersion,@JsonKey(name: 'created_date') DateTime createdDate, String description, List<ServiceSeed> services, ServicesValidation? validation
});


$ServicesValidationCopyWith<$Res>? get validation;

}
/// @nodoc
class _$ServicesSchemaCopyWithImpl<$Res>
    implements $ServicesSchemaCopyWith<$Res> {
  _$ServicesSchemaCopyWithImpl(this._self, this._then);

  final ServicesSchema _self;
  final $Res Function(ServicesSchema) _then;

/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? createdDate = null,Object? description = null,Object? services = null,Object? validation = freezed,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<ServiceSeed>,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as ServicesValidation?,
  ));
}
/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServicesValidationCopyWith<$Res>? get validation {
    if (_self.validation == null) {
    return null;
  }

  return $ServicesValidationCopyWith<$Res>(_self.validation!, (value) {
    return _then(_self.copyWith(validation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServicesSchema].
extension ServicesSchemaPatterns on ServicesSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServicesSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServicesSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServicesSchema value)  $default,){
final _that = this;
switch (_that) {
case _ServicesSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServicesSchema value)?  $default,){
final _that = this;
switch (_that) {
case _ServicesSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceSeed> services,  ServicesValidation? validation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServicesSchema() when $default != null:
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.services,_that.validation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceSeed> services,  ServicesValidation? validation)  $default,) {final _that = this;
switch (_that) {
case _ServicesSchema():
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.services,_that.validation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'schema_version')  String schemaVersion, @JsonKey(name: 'created_date')  DateTime createdDate,  String description,  List<ServiceSeed> services,  ServicesValidation? validation)?  $default,) {final _that = this;
switch (_that) {
case _ServicesSchema() when $default != null:
return $default(_that.schemaVersion,_that.createdDate,_that.description,_that.services,_that.validation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServicesSchema implements ServicesSchema {
  const _ServicesSchema({@JsonKey(name: 'schema_version') required this.schemaVersion, @JsonKey(name: 'created_date') required this.createdDate, required this.description, required final  List<ServiceSeed> services, this.validation}): _services = services;
  factory _ServicesSchema.fromJson(Map<String, dynamic> json) => _$ServicesSchemaFromJson(json);

@override@JsonKey(name: 'schema_version') final  String schemaVersion;
@override@JsonKey(name: 'created_date') final  DateTime createdDate;
@override final  String description;
 final  List<ServiceSeed> _services;
@override List<ServiceSeed> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override final  ServicesValidation? validation;

/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServicesSchemaCopyWith<_ServicesSchema> get copyWith => __$ServicesSchemaCopyWithImpl<_ServicesSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServicesSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServicesSchema&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.validation, validation) || other.validation == validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,createdDate,description,const DeepCollectionEquality().hash(_services),validation);

@override
String toString() {
  return 'ServicesSchema(schemaVersion: $schemaVersion, createdDate: $createdDate, description: $description, services: $services, validation: $validation)';
}


}

/// @nodoc
abstract mixin class _$ServicesSchemaCopyWith<$Res> implements $ServicesSchemaCopyWith<$Res> {
  factory _$ServicesSchemaCopyWith(_ServicesSchema value, $Res Function(_ServicesSchema) _then) = __$ServicesSchemaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'schema_version') String schemaVersion,@JsonKey(name: 'created_date') DateTime createdDate, String description, List<ServiceSeed> services, ServicesValidation? validation
});


@override $ServicesValidationCopyWith<$Res>? get validation;

}
/// @nodoc
class __$ServicesSchemaCopyWithImpl<$Res>
    implements _$ServicesSchemaCopyWith<$Res> {
  __$ServicesSchemaCopyWithImpl(this._self, this._then);

  final _ServicesSchema _self;
  final $Res Function(_ServicesSchema) _then;

/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? createdDate = null,Object? description = null,Object? services = null,Object? validation = freezed,}) {
  return _then(_ServicesSchema(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<ServiceSeed>,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as ServicesValidation?,
  ));
}

/// Create a copy of ServicesSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServicesValidationCopyWith<$Res>? get validation {
    if (_self.validation == null) {
    return null;
  }

  return $ServicesValidationCopyWith<$Res>(_self.validation!, (value) {
    return _then(_self.copyWith(validation: value));
  });
}
}


/// @nodoc
mixin _$ServiceCategoriesValidation {

@JsonKey(name: 'required_fields') List<String>? get requiredFields;@JsonKey(name: 'color_format') String? get colorFormat;@JsonKey(name: 'name_max_length') int? get nameMaxLength;@JsonKey(name: 'description_max_length') int? get descriptionMaxLength;@JsonKey(name: 'unique_constraints') List<String>? get uniqueConstraints;
/// Create a copy of ServiceCategoriesValidation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCategoriesValidationCopyWith<ServiceCategoriesValidation> get copyWith => _$ServiceCategoriesValidationCopyWithImpl<ServiceCategoriesValidation>(this as ServiceCategoriesValidation, _$identity);

  /// Serializes this ServiceCategoriesValidation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCategoriesValidation&&const DeepCollectionEquality().equals(other.requiredFields, requiredFields)&&(identical(other.colorFormat, colorFormat) || other.colorFormat == colorFormat)&&(identical(other.nameMaxLength, nameMaxLength) || other.nameMaxLength == nameMaxLength)&&(identical(other.descriptionMaxLength, descriptionMaxLength) || other.descriptionMaxLength == descriptionMaxLength)&&const DeepCollectionEquality().equals(other.uniqueConstraints, uniqueConstraints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(requiredFields),colorFormat,nameMaxLength,descriptionMaxLength,const DeepCollectionEquality().hash(uniqueConstraints));

@override
String toString() {
  return 'ServiceCategoriesValidation(requiredFields: $requiredFields, colorFormat: $colorFormat, nameMaxLength: $nameMaxLength, descriptionMaxLength: $descriptionMaxLength, uniqueConstraints: $uniqueConstraints)';
}


}

/// @nodoc
abstract mixin class $ServiceCategoriesValidationCopyWith<$Res>  {
  factory $ServiceCategoriesValidationCopyWith(ServiceCategoriesValidation value, $Res Function(ServiceCategoriesValidation) _then) = _$ServiceCategoriesValidationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'required_fields') List<String>? requiredFields,@JsonKey(name: 'color_format') String? colorFormat,@JsonKey(name: 'name_max_length') int? nameMaxLength,@JsonKey(name: 'description_max_length') int? descriptionMaxLength,@JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints
});




}
/// @nodoc
class _$ServiceCategoriesValidationCopyWithImpl<$Res>
    implements $ServiceCategoriesValidationCopyWith<$Res> {
  _$ServiceCategoriesValidationCopyWithImpl(this._self, this._then);

  final ServiceCategoriesValidation _self;
  final $Res Function(ServiceCategoriesValidation) _then;

/// Create a copy of ServiceCategoriesValidation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiredFields = freezed,Object? colorFormat = freezed,Object? nameMaxLength = freezed,Object? descriptionMaxLength = freezed,Object? uniqueConstraints = freezed,}) {
  return _then(_self.copyWith(
requiredFields: freezed == requiredFields ? _self.requiredFields : requiredFields // ignore: cast_nullable_to_non_nullable
as List<String>?,colorFormat: freezed == colorFormat ? _self.colorFormat : colorFormat // ignore: cast_nullable_to_non_nullable
as String?,nameMaxLength: freezed == nameMaxLength ? _self.nameMaxLength : nameMaxLength // ignore: cast_nullable_to_non_nullable
as int?,descriptionMaxLength: freezed == descriptionMaxLength ? _self.descriptionMaxLength : descriptionMaxLength // ignore: cast_nullable_to_non_nullable
as int?,uniqueConstraints: freezed == uniqueConstraints ? _self.uniqueConstraints : uniqueConstraints // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCategoriesValidation].
extension ServiceCategoriesValidationPatterns on ServiceCategoriesValidation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCategoriesValidation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCategoriesValidation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCategoriesValidation value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoriesValidation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCategoriesValidation value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCategoriesValidation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'color_format')  String? colorFormat, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCategoriesValidation() when $default != null:
return $default(_that.requiredFields,_that.colorFormat,_that.nameMaxLength,_that.descriptionMaxLength,_that.uniqueConstraints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'color_format')  String? colorFormat, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints)  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoriesValidation():
return $default(_that.requiredFields,_that.colorFormat,_that.nameMaxLength,_that.descriptionMaxLength,_that.uniqueConstraints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'color_format')  String? colorFormat, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCategoriesValidation() when $default != null:
return $default(_that.requiredFields,_that.colorFormat,_that.nameMaxLength,_that.descriptionMaxLength,_that.uniqueConstraints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCategoriesValidation implements ServiceCategoriesValidation {
  const _ServiceCategoriesValidation({@JsonKey(name: 'required_fields') final  List<String>? requiredFields, @JsonKey(name: 'color_format') this.colorFormat, @JsonKey(name: 'name_max_length') this.nameMaxLength, @JsonKey(name: 'description_max_length') this.descriptionMaxLength, @JsonKey(name: 'unique_constraints') final  List<String>? uniqueConstraints}): _requiredFields = requiredFields,_uniqueConstraints = uniqueConstraints;
  factory _ServiceCategoriesValidation.fromJson(Map<String, dynamic> json) => _$ServiceCategoriesValidationFromJson(json);

 final  List<String>? _requiredFields;
@override@JsonKey(name: 'required_fields') List<String>? get requiredFields {
  final value = _requiredFields;
  if (value == null) return null;
  if (_requiredFields is EqualUnmodifiableListView) return _requiredFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'color_format') final  String? colorFormat;
@override@JsonKey(name: 'name_max_length') final  int? nameMaxLength;
@override@JsonKey(name: 'description_max_length') final  int? descriptionMaxLength;
 final  List<String>? _uniqueConstraints;
@override@JsonKey(name: 'unique_constraints') List<String>? get uniqueConstraints {
  final value = _uniqueConstraints;
  if (value == null) return null;
  if (_uniqueConstraints is EqualUnmodifiableListView) return _uniqueConstraints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ServiceCategoriesValidation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCategoriesValidationCopyWith<_ServiceCategoriesValidation> get copyWith => __$ServiceCategoriesValidationCopyWithImpl<_ServiceCategoriesValidation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCategoriesValidationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCategoriesValidation&&const DeepCollectionEquality().equals(other._requiredFields, _requiredFields)&&(identical(other.colorFormat, colorFormat) || other.colorFormat == colorFormat)&&(identical(other.nameMaxLength, nameMaxLength) || other.nameMaxLength == nameMaxLength)&&(identical(other.descriptionMaxLength, descriptionMaxLength) || other.descriptionMaxLength == descriptionMaxLength)&&const DeepCollectionEquality().equals(other._uniqueConstraints, _uniqueConstraints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requiredFields),colorFormat,nameMaxLength,descriptionMaxLength,const DeepCollectionEquality().hash(_uniqueConstraints));

@override
String toString() {
  return 'ServiceCategoriesValidation(requiredFields: $requiredFields, colorFormat: $colorFormat, nameMaxLength: $nameMaxLength, descriptionMaxLength: $descriptionMaxLength, uniqueConstraints: $uniqueConstraints)';
}


}

/// @nodoc
abstract mixin class _$ServiceCategoriesValidationCopyWith<$Res> implements $ServiceCategoriesValidationCopyWith<$Res> {
  factory _$ServiceCategoriesValidationCopyWith(_ServiceCategoriesValidation value, $Res Function(_ServiceCategoriesValidation) _then) = __$ServiceCategoriesValidationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'required_fields') List<String>? requiredFields,@JsonKey(name: 'color_format') String? colorFormat,@JsonKey(name: 'name_max_length') int? nameMaxLength,@JsonKey(name: 'description_max_length') int? descriptionMaxLength,@JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints
});




}
/// @nodoc
class __$ServiceCategoriesValidationCopyWithImpl<$Res>
    implements _$ServiceCategoriesValidationCopyWith<$Res> {
  __$ServiceCategoriesValidationCopyWithImpl(this._self, this._then);

  final _ServiceCategoriesValidation _self;
  final $Res Function(_ServiceCategoriesValidation) _then;

/// Create a copy of ServiceCategoriesValidation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiredFields = freezed,Object? colorFormat = freezed,Object? nameMaxLength = freezed,Object? descriptionMaxLength = freezed,Object? uniqueConstraints = freezed,}) {
  return _then(_ServiceCategoriesValidation(
requiredFields: freezed == requiredFields ? _self._requiredFields : requiredFields // ignore: cast_nullable_to_non_nullable
as List<String>?,colorFormat: freezed == colorFormat ? _self.colorFormat : colorFormat // ignore: cast_nullable_to_non_nullable
as String?,nameMaxLength: freezed == nameMaxLength ? _self.nameMaxLength : nameMaxLength // ignore: cast_nullable_to_non_nullable
as int?,descriptionMaxLength: freezed == descriptionMaxLength ? _self.descriptionMaxLength : descriptionMaxLength // ignore: cast_nullable_to_non_nullable
as int?,uniqueConstraints: freezed == uniqueConstraints ? _self._uniqueConstraints : uniqueConstraints // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ServicesValidation {

@JsonKey(name: 'required_fields') List<String>? get requiredFields;@JsonKey(name: 'name_max_length') int? get nameMaxLength;@JsonKey(name: 'description_max_length') int? get descriptionMaxLength;@JsonKey(name: 'duration_range') List<int>? get durationRange;@JsonKey(name: 'price_range') List<int>? get priceRange;@JsonKey(name: 'unique_constraints') List<String>? get uniqueConstraints;@JsonKey(name: 'foreign_keys') Map<String, String>? get foreignKeys;
/// Create a copy of ServicesValidation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServicesValidationCopyWith<ServicesValidation> get copyWith => _$ServicesValidationCopyWithImpl<ServicesValidation>(this as ServicesValidation, _$identity);

  /// Serializes this ServicesValidation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServicesValidation&&const DeepCollectionEquality().equals(other.requiredFields, requiredFields)&&(identical(other.nameMaxLength, nameMaxLength) || other.nameMaxLength == nameMaxLength)&&(identical(other.descriptionMaxLength, descriptionMaxLength) || other.descriptionMaxLength == descriptionMaxLength)&&const DeepCollectionEquality().equals(other.durationRange, durationRange)&&const DeepCollectionEquality().equals(other.priceRange, priceRange)&&const DeepCollectionEquality().equals(other.uniqueConstraints, uniqueConstraints)&&const DeepCollectionEquality().equals(other.foreignKeys, foreignKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(requiredFields),nameMaxLength,descriptionMaxLength,const DeepCollectionEquality().hash(durationRange),const DeepCollectionEquality().hash(priceRange),const DeepCollectionEquality().hash(uniqueConstraints),const DeepCollectionEquality().hash(foreignKeys));

@override
String toString() {
  return 'ServicesValidation(requiredFields: $requiredFields, nameMaxLength: $nameMaxLength, descriptionMaxLength: $descriptionMaxLength, durationRange: $durationRange, priceRange: $priceRange, uniqueConstraints: $uniqueConstraints, foreignKeys: $foreignKeys)';
}


}

/// @nodoc
abstract mixin class $ServicesValidationCopyWith<$Res>  {
  factory $ServicesValidationCopyWith(ServicesValidation value, $Res Function(ServicesValidation) _then) = _$ServicesValidationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'required_fields') List<String>? requiredFields,@JsonKey(name: 'name_max_length') int? nameMaxLength,@JsonKey(name: 'description_max_length') int? descriptionMaxLength,@JsonKey(name: 'duration_range') List<int>? durationRange,@JsonKey(name: 'price_range') List<int>? priceRange,@JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints,@JsonKey(name: 'foreign_keys') Map<String, String>? foreignKeys
});




}
/// @nodoc
class _$ServicesValidationCopyWithImpl<$Res>
    implements $ServicesValidationCopyWith<$Res> {
  _$ServicesValidationCopyWithImpl(this._self, this._then);

  final ServicesValidation _self;
  final $Res Function(ServicesValidation) _then;

/// Create a copy of ServicesValidation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiredFields = freezed,Object? nameMaxLength = freezed,Object? descriptionMaxLength = freezed,Object? durationRange = freezed,Object? priceRange = freezed,Object? uniqueConstraints = freezed,Object? foreignKeys = freezed,}) {
  return _then(_self.copyWith(
requiredFields: freezed == requiredFields ? _self.requiredFields : requiredFields // ignore: cast_nullable_to_non_nullable
as List<String>?,nameMaxLength: freezed == nameMaxLength ? _self.nameMaxLength : nameMaxLength // ignore: cast_nullable_to_non_nullable
as int?,descriptionMaxLength: freezed == descriptionMaxLength ? _self.descriptionMaxLength : descriptionMaxLength // ignore: cast_nullable_to_non_nullable
as int?,durationRange: freezed == durationRange ? _self.durationRange : durationRange // ignore: cast_nullable_to_non_nullable
as List<int>?,priceRange: freezed == priceRange ? _self.priceRange : priceRange // ignore: cast_nullable_to_non_nullable
as List<int>?,uniqueConstraints: freezed == uniqueConstraints ? _self.uniqueConstraints : uniqueConstraints // ignore: cast_nullable_to_non_nullable
as List<String>?,foreignKeys: freezed == foreignKeys ? _self.foreignKeys : foreignKeys // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServicesValidation].
extension ServicesValidationPatterns on ServicesValidation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServicesValidation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServicesValidation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServicesValidation value)  $default,){
final _that = this;
switch (_that) {
case _ServicesValidation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServicesValidation value)?  $default,){
final _that = this;
switch (_that) {
case _ServicesValidation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'duration_range')  List<int>? durationRange, @JsonKey(name: 'price_range')  List<int>? priceRange, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints, @JsonKey(name: 'foreign_keys')  Map<String, String>? foreignKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServicesValidation() when $default != null:
return $default(_that.requiredFields,_that.nameMaxLength,_that.descriptionMaxLength,_that.durationRange,_that.priceRange,_that.uniqueConstraints,_that.foreignKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'duration_range')  List<int>? durationRange, @JsonKey(name: 'price_range')  List<int>? priceRange, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints, @JsonKey(name: 'foreign_keys')  Map<String, String>? foreignKeys)  $default,) {final _that = this;
switch (_that) {
case _ServicesValidation():
return $default(_that.requiredFields,_that.nameMaxLength,_that.descriptionMaxLength,_that.durationRange,_that.priceRange,_that.uniqueConstraints,_that.foreignKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'required_fields')  List<String>? requiredFields, @JsonKey(name: 'name_max_length')  int? nameMaxLength, @JsonKey(name: 'description_max_length')  int? descriptionMaxLength, @JsonKey(name: 'duration_range')  List<int>? durationRange, @JsonKey(name: 'price_range')  List<int>? priceRange, @JsonKey(name: 'unique_constraints')  List<String>? uniqueConstraints, @JsonKey(name: 'foreign_keys')  Map<String, String>? foreignKeys)?  $default,) {final _that = this;
switch (_that) {
case _ServicesValidation() when $default != null:
return $default(_that.requiredFields,_that.nameMaxLength,_that.descriptionMaxLength,_that.durationRange,_that.priceRange,_that.uniqueConstraints,_that.foreignKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServicesValidation implements ServicesValidation {
  const _ServicesValidation({@JsonKey(name: 'required_fields') final  List<String>? requiredFields, @JsonKey(name: 'name_max_length') this.nameMaxLength, @JsonKey(name: 'description_max_length') this.descriptionMaxLength, @JsonKey(name: 'duration_range') final  List<int>? durationRange, @JsonKey(name: 'price_range') final  List<int>? priceRange, @JsonKey(name: 'unique_constraints') final  List<String>? uniqueConstraints, @JsonKey(name: 'foreign_keys') final  Map<String, String>? foreignKeys}): _requiredFields = requiredFields,_durationRange = durationRange,_priceRange = priceRange,_uniqueConstraints = uniqueConstraints,_foreignKeys = foreignKeys;
  factory _ServicesValidation.fromJson(Map<String, dynamic> json) => _$ServicesValidationFromJson(json);

 final  List<String>? _requiredFields;
@override@JsonKey(name: 'required_fields') List<String>? get requiredFields {
  final value = _requiredFields;
  if (value == null) return null;
  if (_requiredFields is EqualUnmodifiableListView) return _requiredFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'name_max_length') final  int? nameMaxLength;
@override@JsonKey(name: 'description_max_length') final  int? descriptionMaxLength;
 final  List<int>? _durationRange;
@override@JsonKey(name: 'duration_range') List<int>? get durationRange {
  final value = _durationRange;
  if (value == null) return null;
  if (_durationRange is EqualUnmodifiableListView) return _durationRange;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _priceRange;
@override@JsonKey(name: 'price_range') List<int>? get priceRange {
  final value = _priceRange;
  if (value == null) return null;
  if (_priceRange is EqualUnmodifiableListView) return _priceRange;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _uniqueConstraints;
@override@JsonKey(name: 'unique_constraints') List<String>? get uniqueConstraints {
  final value = _uniqueConstraints;
  if (value == null) return null;
  if (_uniqueConstraints is EqualUnmodifiableListView) return _uniqueConstraints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, String>? _foreignKeys;
@override@JsonKey(name: 'foreign_keys') Map<String, String>? get foreignKeys {
  final value = _foreignKeys;
  if (value == null) return null;
  if (_foreignKeys is EqualUnmodifiableMapView) return _foreignKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ServicesValidation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServicesValidationCopyWith<_ServicesValidation> get copyWith => __$ServicesValidationCopyWithImpl<_ServicesValidation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServicesValidationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServicesValidation&&const DeepCollectionEquality().equals(other._requiredFields, _requiredFields)&&(identical(other.nameMaxLength, nameMaxLength) || other.nameMaxLength == nameMaxLength)&&(identical(other.descriptionMaxLength, descriptionMaxLength) || other.descriptionMaxLength == descriptionMaxLength)&&const DeepCollectionEquality().equals(other._durationRange, _durationRange)&&const DeepCollectionEquality().equals(other._priceRange, _priceRange)&&const DeepCollectionEquality().equals(other._uniqueConstraints, _uniqueConstraints)&&const DeepCollectionEquality().equals(other._foreignKeys, _foreignKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requiredFields),nameMaxLength,descriptionMaxLength,const DeepCollectionEquality().hash(_durationRange),const DeepCollectionEquality().hash(_priceRange),const DeepCollectionEquality().hash(_uniqueConstraints),const DeepCollectionEquality().hash(_foreignKeys));

@override
String toString() {
  return 'ServicesValidation(requiredFields: $requiredFields, nameMaxLength: $nameMaxLength, descriptionMaxLength: $descriptionMaxLength, durationRange: $durationRange, priceRange: $priceRange, uniqueConstraints: $uniqueConstraints, foreignKeys: $foreignKeys)';
}


}

/// @nodoc
abstract mixin class _$ServicesValidationCopyWith<$Res> implements $ServicesValidationCopyWith<$Res> {
  factory _$ServicesValidationCopyWith(_ServicesValidation value, $Res Function(_ServicesValidation) _then) = __$ServicesValidationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'required_fields') List<String>? requiredFields,@JsonKey(name: 'name_max_length') int? nameMaxLength,@JsonKey(name: 'description_max_length') int? descriptionMaxLength,@JsonKey(name: 'duration_range') List<int>? durationRange,@JsonKey(name: 'price_range') List<int>? priceRange,@JsonKey(name: 'unique_constraints') List<String>? uniqueConstraints,@JsonKey(name: 'foreign_keys') Map<String, String>? foreignKeys
});




}
/// @nodoc
class __$ServicesValidationCopyWithImpl<$Res>
    implements _$ServicesValidationCopyWith<$Res> {
  __$ServicesValidationCopyWithImpl(this._self, this._then);

  final _ServicesValidation _self;
  final $Res Function(_ServicesValidation) _then;

/// Create a copy of ServicesValidation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiredFields = freezed,Object? nameMaxLength = freezed,Object? descriptionMaxLength = freezed,Object? durationRange = freezed,Object? priceRange = freezed,Object? uniqueConstraints = freezed,Object? foreignKeys = freezed,}) {
  return _then(_ServicesValidation(
requiredFields: freezed == requiredFields ? _self._requiredFields : requiredFields // ignore: cast_nullable_to_non_nullable
as List<String>?,nameMaxLength: freezed == nameMaxLength ? _self.nameMaxLength : nameMaxLength // ignore: cast_nullable_to_non_nullable
as int?,descriptionMaxLength: freezed == descriptionMaxLength ? _self.descriptionMaxLength : descriptionMaxLength // ignore: cast_nullable_to_non_nullable
as int?,durationRange: freezed == durationRange ? _self._durationRange : durationRange // ignore: cast_nullable_to_non_nullable
as List<int>?,priceRange: freezed == priceRange ? _self._priceRange : priceRange // ignore: cast_nullable_to_non_nullable
as List<int>?,uniqueConstraints: freezed == uniqueConstraints ? _self._uniqueConstraints : uniqueConstraints // ignore: cast_nullable_to_non_nullable
as List<String>?,foreignKeys: freezed == foreignKeys ? _self._foreignKeys : foreignKeys // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$SeedImportResult {

 bool get success; String get message; int get itemsProcessed; int get itemsImported; int get itemsSkipped; List<String> get errors; List<String> get warnings; String? get backupPath; DateTime? get importedAt;
/// Create a copy of SeedImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeedImportResultCopyWith<SeedImportResult> get copyWith => _$SeedImportResultCopyWithImpl<SeedImportResult>(this as SeedImportResult, _$identity);

  /// Serializes this SeedImportResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeedImportResult&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsImported, itemsImported) || other.itemsImported == itemsImported)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&const DeepCollectionEquality().equals(other.errors, errors)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.backupPath, backupPath) || other.backupPath == backupPath)&&(identical(other.importedAt, importedAt) || other.importedAt == importedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,itemsProcessed,itemsImported,itemsSkipped,const DeepCollectionEquality().hash(errors),const DeepCollectionEquality().hash(warnings),backupPath,importedAt);

@override
String toString() {
  return 'SeedImportResult(success: $success, message: $message, itemsProcessed: $itemsProcessed, itemsImported: $itemsImported, itemsSkipped: $itemsSkipped, errors: $errors, warnings: $warnings, backupPath: $backupPath, importedAt: $importedAt)';
}


}

/// @nodoc
abstract mixin class $SeedImportResultCopyWith<$Res>  {
  factory $SeedImportResultCopyWith(SeedImportResult value, $Res Function(SeedImportResult) _then) = _$SeedImportResultCopyWithImpl;
@useResult
$Res call({
 bool success, String message, int itemsProcessed, int itemsImported, int itemsSkipped, List<String> errors, List<String> warnings, String? backupPath, DateTime? importedAt
});




}
/// @nodoc
class _$SeedImportResultCopyWithImpl<$Res>
    implements $SeedImportResultCopyWith<$Res> {
  _$SeedImportResultCopyWithImpl(this._self, this._then);

  final SeedImportResult _self;
  final $Res Function(SeedImportResult) _then;

/// Create a copy of SeedImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? itemsProcessed = null,Object? itemsImported = null,Object? itemsSkipped = null,Object? errors = null,Object? warnings = null,Object? backupPath = freezed,Object? importedAt = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsImported: null == itemsImported ? _self.itemsImported : itemsImported // ignore: cast_nullable_to_non_nullable
as int,itemsSkipped: null == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,backupPath: freezed == backupPath ? _self.backupPath : backupPath // ignore: cast_nullable_to_non_nullable
as String?,importedAt: freezed == importedAt ? _self.importedAt : importedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeedImportResult].
extension SeedImportResultPatterns on SeedImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeedImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeedImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeedImportResult value)  $default,){
final _that = this;
switch (_that) {
case _SeedImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeedImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _SeedImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  int itemsProcessed,  int itemsImported,  int itemsSkipped,  List<String> errors,  List<String> warnings,  String? backupPath,  DateTime? importedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeedImportResult() when $default != null:
return $default(_that.success,_that.message,_that.itemsProcessed,_that.itemsImported,_that.itemsSkipped,_that.errors,_that.warnings,_that.backupPath,_that.importedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  int itemsProcessed,  int itemsImported,  int itemsSkipped,  List<String> errors,  List<String> warnings,  String? backupPath,  DateTime? importedAt)  $default,) {final _that = this;
switch (_that) {
case _SeedImportResult():
return $default(_that.success,_that.message,_that.itemsProcessed,_that.itemsImported,_that.itemsSkipped,_that.errors,_that.warnings,_that.backupPath,_that.importedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  int itemsProcessed,  int itemsImported,  int itemsSkipped,  List<String> errors,  List<String> warnings,  String? backupPath,  DateTime? importedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeedImportResult() when $default != null:
return $default(_that.success,_that.message,_that.itemsProcessed,_that.itemsImported,_that.itemsSkipped,_that.errors,_that.warnings,_that.backupPath,_that.importedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeedImportResult implements SeedImportResult {
  const _SeedImportResult({required this.success, required this.message, required this.itemsProcessed, required this.itemsImported, required this.itemsSkipped, required final  List<String> errors, required final  List<String> warnings, this.backupPath, this.importedAt}): _errors = errors,_warnings = warnings;
  factory _SeedImportResult.fromJson(Map<String, dynamic> json) => _$SeedImportResultFromJson(json);

@override final  bool success;
@override final  String message;
@override final  int itemsProcessed;
@override final  int itemsImported;
@override final  int itemsSkipped;
 final  List<String> _errors;
@override List<String> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override final  String? backupPath;
@override final  DateTime? importedAt;

/// Create a copy of SeedImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeedImportResultCopyWith<_SeedImportResult> get copyWith => __$SeedImportResultCopyWithImpl<_SeedImportResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeedImportResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeedImportResult&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsImported, itemsImported) || other.itemsImported == itemsImported)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&const DeepCollectionEquality().equals(other._errors, _errors)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&(identical(other.backupPath, backupPath) || other.backupPath == backupPath)&&(identical(other.importedAt, importedAt) || other.importedAt == importedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,itemsProcessed,itemsImported,itemsSkipped,const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_warnings),backupPath,importedAt);

@override
String toString() {
  return 'SeedImportResult(success: $success, message: $message, itemsProcessed: $itemsProcessed, itemsImported: $itemsImported, itemsSkipped: $itemsSkipped, errors: $errors, warnings: $warnings, backupPath: $backupPath, importedAt: $importedAt)';
}


}

/// @nodoc
abstract mixin class _$SeedImportResultCopyWith<$Res> implements $SeedImportResultCopyWith<$Res> {
  factory _$SeedImportResultCopyWith(_SeedImportResult value, $Res Function(_SeedImportResult) _then) = __$SeedImportResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, int itemsProcessed, int itemsImported, int itemsSkipped, List<String> errors, List<String> warnings, String? backupPath, DateTime? importedAt
});




}
/// @nodoc
class __$SeedImportResultCopyWithImpl<$Res>
    implements _$SeedImportResultCopyWith<$Res> {
  __$SeedImportResultCopyWithImpl(this._self, this._then);

  final _SeedImportResult _self;
  final $Res Function(_SeedImportResult) _then;

/// Create a copy of SeedImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? itemsProcessed = null,Object? itemsImported = null,Object? itemsSkipped = null,Object? errors = null,Object? warnings = null,Object? backupPath = freezed,Object? importedAt = freezed,}) {
  return _then(_SeedImportResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsImported: null == itemsImported ? _self.itemsImported : itemsImported // ignore: cast_nullable_to_non_nullable
as int,itemsSkipped: null == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,backupPath: freezed == backupPath ? _self.backupPath : backupPath // ignore: cast_nullable_to_non_nullable
as String?,importedAt: freezed == importedAt ? _self.importedAt : importedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SeedBackup {

 String get id; String get seedType; String get version; String get filePath; DateTime get createdAt; int get itemCount; String? get description; String? get createdBy;
/// Create a copy of SeedBackup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeedBackupCopyWith<SeedBackup> get copyWith => _$SeedBackupCopyWithImpl<SeedBackup>(this as SeedBackup, _$identity);

  /// Serializes this SeedBackup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeedBackup&&(identical(other.id, id) || other.id == id)&&(identical(other.seedType, seedType) || other.seedType == seedType)&&(identical(other.version, version) || other.version == version)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seedType,version,filePath,createdAt,itemCount,description,createdBy);

@override
String toString() {
  return 'SeedBackup(id: $id, seedType: $seedType, version: $version, filePath: $filePath, createdAt: $createdAt, itemCount: $itemCount, description: $description, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $SeedBackupCopyWith<$Res>  {
  factory $SeedBackupCopyWith(SeedBackup value, $Res Function(SeedBackup) _then) = _$SeedBackupCopyWithImpl;
@useResult
$Res call({
 String id, String seedType, String version, String filePath, DateTime createdAt, int itemCount, String? description, String? createdBy
});




}
/// @nodoc
class _$SeedBackupCopyWithImpl<$Res>
    implements $SeedBackupCopyWith<$Res> {
  _$SeedBackupCopyWithImpl(this._self, this._then);

  final SeedBackup _self;
  final $Res Function(SeedBackup) _then;

/// Create a copy of SeedBackup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seedType = null,Object? version = null,Object? filePath = null,Object? createdAt = null,Object? itemCount = null,Object? description = freezed,Object? createdBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seedType: null == seedType ? _self.seedType : seedType // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeedBackup].
extension SeedBackupPatterns on SeedBackup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeedBackup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeedBackup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeedBackup value)  $default,){
final _that = this;
switch (_that) {
case _SeedBackup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeedBackup value)?  $default,){
final _that = this;
switch (_that) {
case _SeedBackup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seedType,  String version,  String filePath,  DateTime createdAt,  int itemCount,  String? description,  String? createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeedBackup() when $default != null:
return $default(_that.id,_that.seedType,_that.version,_that.filePath,_that.createdAt,_that.itemCount,_that.description,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seedType,  String version,  String filePath,  DateTime createdAt,  int itemCount,  String? description,  String? createdBy)  $default,) {final _that = this;
switch (_that) {
case _SeedBackup():
return $default(_that.id,_that.seedType,_that.version,_that.filePath,_that.createdAt,_that.itemCount,_that.description,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seedType,  String version,  String filePath,  DateTime createdAt,  int itemCount,  String? description,  String? createdBy)?  $default,) {final _that = this;
switch (_that) {
case _SeedBackup() when $default != null:
return $default(_that.id,_that.seedType,_that.version,_that.filePath,_that.createdAt,_that.itemCount,_that.description,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeedBackup implements SeedBackup {
  const _SeedBackup({required this.id, required this.seedType, required this.version, required this.filePath, required this.createdAt, required this.itemCount, this.description, this.createdBy});
  factory _SeedBackup.fromJson(Map<String, dynamic> json) => _$SeedBackupFromJson(json);

@override final  String id;
@override final  String seedType;
@override final  String version;
@override final  String filePath;
@override final  DateTime createdAt;
@override final  int itemCount;
@override final  String? description;
@override final  String? createdBy;

/// Create a copy of SeedBackup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeedBackupCopyWith<_SeedBackup> get copyWith => __$SeedBackupCopyWithImpl<_SeedBackup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeedBackupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeedBackup&&(identical(other.id, id) || other.id == id)&&(identical(other.seedType, seedType) || other.seedType == seedType)&&(identical(other.version, version) || other.version == version)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seedType,version,filePath,createdAt,itemCount,description,createdBy);

@override
String toString() {
  return 'SeedBackup(id: $id, seedType: $seedType, version: $version, filePath: $filePath, createdAt: $createdAt, itemCount: $itemCount, description: $description, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$SeedBackupCopyWith<$Res> implements $SeedBackupCopyWith<$Res> {
  factory _$SeedBackupCopyWith(_SeedBackup value, $Res Function(_SeedBackup) _then) = __$SeedBackupCopyWithImpl;
@override @useResult
$Res call({
 String id, String seedType, String version, String filePath, DateTime createdAt, int itemCount, String? description, String? createdBy
});




}
/// @nodoc
class __$SeedBackupCopyWithImpl<$Res>
    implements _$SeedBackupCopyWith<$Res> {
  __$SeedBackupCopyWithImpl(this._self, this._then);

  final _SeedBackup _self;
  final $Res Function(_SeedBackup) _then;

/// Create a copy of SeedBackup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seedType = null,Object? version = null,Object? filePath = null,Object? createdAt = null,Object? itemCount = null,Object? description = freezed,Object? createdBy = freezed,}) {
  return _then(_SeedBackup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seedType: null == seedType ? _self.seedType : seedType // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
