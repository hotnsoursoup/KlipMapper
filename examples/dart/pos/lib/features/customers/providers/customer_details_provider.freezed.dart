// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_details_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerDetails {

 double get totalSpent; int get visitCount; double get averageSpent; DateTime? get lastVisit; Map<String, int> get serviceFrequency; List<Ticket> get tickets; bool get isLoading;
/// Create a copy of CustomerDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDetailsCopyWith<CustomerDetails> get copyWith => _$CustomerDetailsCopyWithImpl<CustomerDetails>(this as CustomerDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerDetails&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount)&&(identical(other.averageSpent, averageSpent) || other.averageSpent == averageSpent)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&const DeepCollectionEquality().equals(other.serviceFrequency, serviceFrequency)&&const DeepCollectionEquality().equals(other.tickets, tickets)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpent,visitCount,averageSpent,lastVisit,const DeepCollectionEquality().hash(serviceFrequency),const DeepCollectionEquality().hash(tickets),isLoading);

@override
String toString() {
  return 'CustomerDetails(totalSpent: $totalSpent, visitCount: $visitCount, averageSpent: $averageSpent, lastVisit: $lastVisit, serviceFrequency: $serviceFrequency, tickets: $tickets, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $CustomerDetailsCopyWith<$Res>  {
  factory $CustomerDetailsCopyWith(CustomerDetails value, $Res Function(CustomerDetails) _then) = _$CustomerDetailsCopyWithImpl;
@useResult
$Res call({
 double totalSpent, int visitCount, double averageSpent, DateTime? lastVisit, Map<String, int> serviceFrequency, List<Ticket> tickets, bool isLoading
});




}
/// @nodoc
class _$CustomerDetailsCopyWithImpl<$Res>
    implements $CustomerDetailsCopyWith<$Res> {
  _$CustomerDetailsCopyWithImpl(this._self, this._then);

  final CustomerDetails _self;
  final $Res Function(CustomerDetails) _then;

/// Create a copy of CustomerDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSpent = null,Object? visitCount = null,Object? averageSpent = null,Object? lastVisit = freezed,Object? serviceFrequency = null,Object? tickets = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,averageSpent: null == averageSpent ? _self.averageSpent : averageSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,serviceFrequency: null == serviceFrequency ? _self.serviceFrequency : serviceFrequency // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerDetails].
extension CustomerDetailsPatterns on CustomerDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerDetails value)  $default,){
final _that = this;
switch (_that) {
case _CustomerDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency,  List<Ticket> tickets,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerDetails() when $default != null:
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency,_that.tickets,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency,  List<Ticket> tickets,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _CustomerDetails():
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency,_that.tickets,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency,  List<Ticket> tickets,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _CustomerDetails() when $default != null:
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency,_that.tickets,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerDetails implements CustomerDetails {
  const _CustomerDetails({this.totalSpent = 0.0, this.visitCount = 0, this.averageSpent = 0.0, this.lastVisit, final  Map<String, int> serviceFrequency = const {}, final  List<Ticket> tickets = const [], this.isLoading = false}): _serviceFrequency = serviceFrequency,_tickets = tickets;
  

@override@JsonKey() final  double totalSpent;
@override@JsonKey() final  int visitCount;
@override@JsonKey() final  double averageSpent;
@override final  DateTime? lastVisit;
 final  Map<String, int> _serviceFrequency;
@override@JsonKey() Map<String, int> get serviceFrequency {
  if (_serviceFrequency is EqualUnmodifiableMapView) return _serviceFrequency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_serviceFrequency);
}

 final  List<Ticket> _tickets;
@override@JsonKey() List<Ticket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

@override@JsonKey() final  bool isLoading;

/// Create a copy of CustomerDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDetailsCopyWith<_CustomerDetails> get copyWith => __$CustomerDetailsCopyWithImpl<_CustomerDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerDetails&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount)&&(identical(other.averageSpent, averageSpent) || other.averageSpent == averageSpent)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&const DeepCollectionEquality().equals(other._serviceFrequency, _serviceFrequency)&&const DeepCollectionEquality().equals(other._tickets, _tickets)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpent,visitCount,averageSpent,lastVisit,const DeepCollectionEquality().hash(_serviceFrequency),const DeepCollectionEquality().hash(_tickets),isLoading);

@override
String toString() {
  return 'CustomerDetails(totalSpent: $totalSpent, visitCount: $visitCount, averageSpent: $averageSpent, lastVisit: $lastVisit, serviceFrequency: $serviceFrequency, tickets: $tickets, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$CustomerDetailsCopyWith<$Res> implements $CustomerDetailsCopyWith<$Res> {
  factory _$CustomerDetailsCopyWith(_CustomerDetails value, $Res Function(_CustomerDetails) _then) = __$CustomerDetailsCopyWithImpl;
@override @useResult
$Res call({
 double totalSpent, int visitCount, double averageSpent, DateTime? lastVisit, Map<String, int> serviceFrequency, List<Ticket> tickets, bool isLoading
});




}
/// @nodoc
class __$CustomerDetailsCopyWithImpl<$Res>
    implements _$CustomerDetailsCopyWith<$Res> {
  __$CustomerDetailsCopyWithImpl(this._self, this._then);

  final _CustomerDetails _self;
  final $Res Function(_CustomerDetails) _then;

/// Create a copy of CustomerDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSpent = null,Object? visitCount = null,Object? averageSpent = null,Object? lastVisit = freezed,Object? serviceFrequency = null,Object? tickets = null,Object? isLoading = null,}) {
  return _then(_CustomerDetails(
totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,averageSpent: null == averageSpent ? _self.averageSpent : averageSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,serviceFrequency: null == serviceFrequency ? _self._serviceFrequency : serviceFrequency // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
