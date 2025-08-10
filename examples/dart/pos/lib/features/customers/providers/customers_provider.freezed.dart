// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customers_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerFiltersState {

 String get searchQuery; String? get membershipFilter; DateTimeRange? get dateFilter; String get nameFilterType;// 'First Name' or 'Last Name'
 String? get letterFilter;// A-Z filter
 String get sortBy;// 'name', 'totalSpend', 'totalVisits', 'lastVisit'
 bool get sortAscending;
/// Create a copy of CustomerFiltersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerFiltersStateCopyWith<CustomerFiltersState> get copyWith => _$CustomerFiltersStateCopyWithImpl<CustomerFiltersState>(this as CustomerFiltersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerFiltersState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.membershipFilter, membershipFilter) || other.membershipFilter == membershipFilter)&&(identical(other.dateFilter, dateFilter) || other.dateFilter == dateFilter)&&(identical(other.nameFilterType, nameFilterType) || other.nameFilterType == nameFilterType)&&(identical(other.letterFilter, letterFilter) || other.letterFilter == letterFilter)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,membershipFilter,dateFilter,nameFilterType,letterFilter,sortBy,sortAscending);

@override
String toString() {
  return 'CustomerFiltersState(searchQuery: $searchQuery, membershipFilter: $membershipFilter, dateFilter: $dateFilter, nameFilterType: $nameFilterType, letterFilter: $letterFilter, sortBy: $sortBy, sortAscending: $sortAscending)';
}


}

/// @nodoc
abstract mixin class $CustomerFiltersStateCopyWith<$Res>  {
  factory $CustomerFiltersStateCopyWith(CustomerFiltersState value, $Res Function(CustomerFiltersState) _then) = _$CustomerFiltersStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, String? membershipFilter, DateTimeRange? dateFilter, String nameFilterType, String? letterFilter, String sortBy, bool sortAscending
});




}
/// @nodoc
class _$CustomerFiltersStateCopyWithImpl<$Res>
    implements $CustomerFiltersStateCopyWith<$Res> {
  _$CustomerFiltersStateCopyWithImpl(this._self, this._then);

  final CustomerFiltersState _self;
  final $Res Function(CustomerFiltersState) _then;

/// Create a copy of CustomerFiltersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? membershipFilter = freezed,Object? dateFilter = freezed,Object? nameFilterType = null,Object? letterFilter = freezed,Object? sortBy = null,Object? sortAscending = null,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,membershipFilter: freezed == membershipFilter ? _self.membershipFilter : membershipFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFilter: freezed == dateFilter ? _self.dateFilter : dateFilter // ignore: cast_nullable_to_non_nullable
as DateTimeRange?,nameFilterType: null == nameFilterType ? _self.nameFilterType : nameFilterType // ignore: cast_nullable_to_non_nullable
as String,letterFilter: freezed == letterFilter ? _self.letterFilter : letterFilter // ignore: cast_nullable_to_non_nullable
as String?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerFiltersState].
extension CustomerFiltersStatePatterns on CustomerFiltersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerFiltersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerFiltersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerFiltersState value)  $default,){
final _that = this;
switch (_that) {
case _CustomerFiltersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerFiltersState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerFiltersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  String? membershipFilter,  DateTimeRange? dateFilter,  String nameFilterType,  String? letterFilter,  String sortBy,  bool sortAscending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerFiltersState() when $default != null:
return $default(_that.searchQuery,_that.membershipFilter,_that.dateFilter,_that.nameFilterType,_that.letterFilter,_that.sortBy,_that.sortAscending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  String? membershipFilter,  DateTimeRange? dateFilter,  String nameFilterType,  String? letterFilter,  String sortBy,  bool sortAscending)  $default,) {final _that = this;
switch (_that) {
case _CustomerFiltersState():
return $default(_that.searchQuery,_that.membershipFilter,_that.dateFilter,_that.nameFilterType,_that.letterFilter,_that.sortBy,_that.sortAscending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  String? membershipFilter,  DateTimeRange? dateFilter,  String nameFilterType,  String? letterFilter,  String sortBy,  bool sortAscending)?  $default,) {final _that = this;
switch (_that) {
case _CustomerFiltersState() when $default != null:
return $default(_that.searchQuery,_that.membershipFilter,_that.dateFilter,_that.nameFilterType,_that.letterFilter,_that.sortBy,_that.sortAscending);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerFiltersState implements CustomerFiltersState {
  const _CustomerFiltersState({this.searchQuery = '', this.membershipFilter, this.dateFilter, this.nameFilterType = 'Last Name', this.letterFilter, this.sortBy = 'name', this.sortAscending = true});
  

@override@JsonKey() final  String searchQuery;
@override final  String? membershipFilter;
@override final  DateTimeRange? dateFilter;
@override@JsonKey() final  String nameFilterType;
// 'First Name' or 'Last Name'
@override final  String? letterFilter;
// A-Z filter
@override@JsonKey() final  String sortBy;
// 'name', 'totalSpend', 'totalVisits', 'lastVisit'
@override@JsonKey() final  bool sortAscending;

/// Create a copy of CustomerFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerFiltersStateCopyWith<_CustomerFiltersState> get copyWith => __$CustomerFiltersStateCopyWithImpl<_CustomerFiltersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerFiltersState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.membershipFilter, membershipFilter) || other.membershipFilter == membershipFilter)&&(identical(other.dateFilter, dateFilter) || other.dateFilter == dateFilter)&&(identical(other.nameFilterType, nameFilterType) || other.nameFilterType == nameFilterType)&&(identical(other.letterFilter, letterFilter) || other.letterFilter == letterFilter)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,membershipFilter,dateFilter,nameFilterType,letterFilter,sortBy,sortAscending);

@override
String toString() {
  return 'CustomerFiltersState(searchQuery: $searchQuery, membershipFilter: $membershipFilter, dateFilter: $dateFilter, nameFilterType: $nameFilterType, letterFilter: $letterFilter, sortBy: $sortBy, sortAscending: $sortAscending)';
}


}

/// @nodoc
abstract mixin class _$CustomerFiltersStateCopyWith<$Res> implements $CustomerFiltersStateCopyWith<$Res> {
  factory _$CustomerFiltersStateCopyWith(_CustomerFiltersState value, $Res Function(_CustomerFiltersState) _then) = __$CustomerFiltersStateCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, String? membershipFilter, DateTimeRange? dateFilter, String nameFilterType, String? letterFilter, String sortBy, bool sortAscending
});




}
/// @nodoc
class __$CustomerFiltersStateCopyWithImpl<$Res>
    implements _$CustomerFiltersStateCopyWith<$Res> {
  __$CustomerFiltersStateCopyWithImpl(this._self, this._then);

  final _CustomerFiltersState _self;
  final $Res Function(_CustomerFiltersState) _then;

/// Create a copy of CustomerFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? membershipFilter = freezed,Object? dateFilter = freezed,Object? nameFilterType = null,Object? letterFilter = freezed,Object? sortBy = null,Object? sortAscending = null,}) {
  return _then(_CustomerFiltersState(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,membershipFilter: freezed == membershipFilter ? _self.membershipFilter : membershipFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFilter: freezed == dateFilter ? _self.dateFilter : dateFilter // ignore: cast_nullable_to_non_nullable
as DateTimeRange?,nameFilterType: null == nameFilterType ? _self.nameFilterType : nameFilterType // ignore: cast_nullable_to_non_nullable
as String,letterFilter: freezed == letterFilter ? _self.letterFilter : letterFilter // ignore: cast_nullable_to_non_nullable
as String?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CustomerStatistics {

 int get totalCount; int get activeCount; int get inactiveCount; double get totalRevenue; Map<String, int> get membershipBreakdown;
/// Create a copy of CustomerStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerStatisticsCopyWith<CustomerStatistics> get copyWith => _$CustomerStatisticsCopyWithImpl<CustomerStatistics>(this as CustomerStatistics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerStatistics&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.inactiveCount, inactiveCount) || other.inactiveCount == inactiveCount)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&const DeepCollectionEquality().equals(other.membershipBreakdown, membershipBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,activeCount,inactiveCount,totalRevenue,const DeepCollectionEquality().hash(membershipBreakdown));

@override
String toString() {
  return 'CustomerStatistics(totalCount: $totalCount, activeCount: $activeCount, inactiveCount: $inactiveCount, totalRevenue: $totalRevenue, membershipBreakdown: $membershipBreakdown)';
}


}

/// @nodoc
abstract mixin class $CustomerStatisticsCopyWith<$Res>  {
  factory $CustomerStatisticsCopyWith(CustomerStatistics value, $Res Function(CustomerStatistics) _then) = _$CustomerStatisticsCopyWithImpl;
@useResult
$Res call({
 int totalCount, int activeCount, int inactiveCount, double totalRevenue, Map<String, int> membershipBreakdown
});




}
/// @nodoc
class _$CustomerStatisticsCopyWithImpl<$Res>
    implements $CustomerStatisticsCopyWith<$Res> {
  _$CustomerStatisticsCopyWithImpl(this._self, this._then);

  final CustomerStatistics _self;
  final $Res Function(CustomerStatistics) _then;

/// Create a copy of CustomerStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? activeCount = null,Object? inactiveCount = null,Object? totalRevenue = null,Object? membershipBreakdown = null,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,inactiveCount: null == inactiveCount ? _self.inactiveCount : inactiveCount // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,membershipBreakdown: null == membershipBreakdown ? _self.membershipBreakdown : membershipBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerStatistics].
extension CustomerStatisticsPatterns on CustomerStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerStatistics value)  $default,){
final _that = this;
switch (_that) {
case _CustomerStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  int activeCount,  int inactiveCount,  double totalRevenue,  Map<String, int> membershipBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerStatistics() when $default != null:
return $default(_that.totalCount,_that.activeCount,_that.inactiveCount,_that.totalRevenue,_that.membershipBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  int activeCount,  int inactiveCount,  double totalRevenue,  Map<String, int> membershipBreakdown)  $default,) {final _that = this;
switch (_that) {
case _CustomerStatistics():
return $default(_that.totalCount,_that.activeCount,_that.inactiveCount,_that.totalRevenue,_that.membershipBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  int activeCount,  int inactiveCount,  double totalRevenue,  Map<String, int> membershipBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _CustomerStatistics() when $default != null:
return $default(_that.totalCount,_that.activeCount,_that.inactiveCount,_that.totalRevenue,_that.membershipBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerStatistics implements CustomerStatistics {
  const _CustomerStatistics({this.totalCount = 0, this.activeCount = 0, this.inactiveCount = 0, this.totalRevenue = 0.0, final  Map<String, int> membershipBreakdown = const {}}): _membershipBreakdown = membershipBreakdown;
  

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int activeCount;
@override@JsonKey() final  int inactiveCount;
@override@JsonKey() final  double totalRevenue;
 final  Map<String, int> _membershipBreakdown;
@override@JsonKey() Map<String, int> get membershipBreakdown {
  if (_membershipBreakdown is EqualUnmodifiableMapView) return _membershipBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_membershipBreakdown);
}


/// Create a copy of CustomerStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerStatisticsCopyWith<_CustomerStatistics> get copyWith => __$CustomerStatisticsCopyWithImpl<_CustomerStatistics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerStatistics&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.inactiveCount, inactiveCount) || other.inactiveCount == inactiveCount)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&const DeepCollectionEquality().equals(other._membershipBreakdown, _membershipBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,activeCount,inactiveCount,totalRevenue,const DeepCollectionEquality().hash(_membershipBreakdown));

@override
String toString() {
  return 'CustomerStatistics(totalCount: $totalCount, activeCount: $activeCount, inactiveCount: $inactiveCount, totalRevenue: $totalRevenue, membershipBreakdown: $membershipBreakdown)';
}


}

/// @nodoc
abstract mixin class _$CustomerStatisticsCopyWith<$Res> implements $CustomerStatisticsCopyWith<$Res> {
  factory _$CustomerStatisticsCopyWith(_CustomerStatistics value, $Res Function(_CustomerStatistics) _then) = __$CustomerStatisticsCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, int activeCount, int inactiveCount, double totalRevenue, Map<String, int> membershipBreakdown
});




}
/// @nodoc
class __$CustomerStatisticsCopyWithImpl<$Res>
    implements _$CustomerStatisticsCopyWith<$Res> {
  __$CustomerStatisticsCopyWithImpl(this._self, this._then);

  final _CustomerStatistics _self;
  final $Res Function(_CustomerStatistics) _then;

/// Create a copy of CustomerStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? activeCount = null,Object? inactiveCount = null,Object? totalRevenue = null,Object? membershipBreakdown = null,}) {
  return _then(_CustomerStatistics(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,inactiveCount: null == inactiveCount ? _self.inactiveCount : inactiveCount // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,membershipBreakdown: null == membershipBreakdown ? _self._membershipBreakdown : membershipBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

/// @nodoc
mixin _$SelectedCustomerAnalytics {

 double get totalSpent; int get visitCount; double get averageSpent; DateTime? get lastVisit; Map<String, int> get serviceFrequency;
/// Create a copy of SelectedCustomerAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedCustomerAnalyticsCopyWith<SelectedCustomerAnalytics> get copyWith => _$SelectedCustomerAnalyticsCopyWithImpl<SelectedCustomerAnalytics>(this as SelectedCustomerAnalytics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedCustomerAnalytics&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount)&&(identical(other.averageSpent, averageSpent) || other.averageSpent == averageSpent)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&const DeepCollectionEquality().equals(other.serviceFrequency, serviceFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpent,visitCount,averageSpent,lastVisit,const DeepCollectionEquality().hash(serviceFrequency));

@override
String toString() {
  return 'SelectedCustomerAnalytics(totalSpent: $totalSpent, visitCount: $visitCount, averageSpent: $averageSpent, lastVisit: $lastVisit, serviceFrequency: $serviceFrequency)';
}


}

/// @nodoc
abstract mixin class $SelectedCustomerAnalyticsCopyWith<$Res>  {
  factory $SelectedCustomerAnalyticsCopyWith(SelectedCustomerAnalytics value, $Res Function(SelectedCustomerAnalytics) _then) = _$SelectedCustomerAnalyticsCopyWithImpl;
@useResult
$Res call({
 double totalSpent, int visitCount, double averageSpent, DateTime? lastVisit, Map<String, int> serviceFrequency
});




}
/// @nodoc
class _$SelectedCustomerAnalyticsCopyWithImpl<$Res>
    implements $SelectedCustomerAnalyticsCopyWith<$Res> {
  _$SelectedCustomerAnalyticsCopyWithImpl(this._self, this._then);

  final SelectedCustomerAnalytics _self;
  final $Res Function(SelectedCustomerAnalytics) _then;

/// Create a copy of SelectedCustomerAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSpent = null,Object? visitCount = null,Object? averageSpent = null,Object? lastVisit = freezed,Object? serviceFrequency = null,}) {
  return _then(_self.copyWith(
totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,averageSpent: null == averageSpent ? _self.averageSpent : averageSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,serviceFrequency: null == serviceFrequency ? _self.serviceFrequency : serviceFrequency // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedCustomerAnalytics].
extension SelectedCustomerAnalyticsPatterns on SelectedCustomerAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedCustomerAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedCustomerAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedCustomerAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics() when $default != null:
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency)  $default,) {final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics():
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSpent,  int visitCount,  double averageSpent,  DateTime? lastVisit,  Map<String, int> serviceFrequency)?  $default,) {final _that = this;
switch (_that) {
case _SelectedCustomerAnalytics() when $default != null:
return $default(_that.totalSpent,_that.visitCount,_that.averageSpent,_that.lastVisit,_that.serviceFrequency);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedCustomerAnalytics implements SelectedCustomerAnalytics {
  const _SelectedCustomerAnalytics({this.totalSpent = 0.0, this.visitCount = 0, this.averageSpent = 0.0, this.lastVisit, final  Map<String, int> serviceFrequency = const {}}): _serviceFrequency = serviceFrequency;
  

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


/// Create a copy of SelectedCustomerAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedCustomerAnalyticsCopyWith<_SelectedCustomerAnalytics> get copyWith => __$SelectedCustomerAnalyticsCopyWithImpl<_SelectedCustomerAnalytics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedCustomerAnalytics&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount)&&(identical(other.averageSpent, averageSpent) || other.averageSpent == averageSpent)&&(identical(other.lastVisit, lastVisit) || other.lastVisit == lastVisit)&&const DeepCollectionEquality().equals(other._serviceFrequency, _serviceFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpent,visitCount,averageSpent,lastVisit,const DeepCollectionEquality().hash(_serviceFrequency));

@override
String toString() {
  return 'SelectedCustomerAnalytics(totalSpent: $totalSpent, visitCount: $visitCount, averageSpent: $averageSpent, lastVisit: $lastVisit, serviceFrequency: $serviceFrequency)';
}


}

/// @nodoc
abstract mixin class _$SelectedCustomerAnalyticsCopyWith<$Res> implements $SelectedCustomerAnalyticsCopyWith<$Res> {
  factory _$SelectedCustomerAnalyticsCopyWith(_SelectedCustomerAnalytics value, $Res Function(_SelectedCustomerAnalytics) _then) = __$SelectedCustomerAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 double totalSpent, int visitCount, double averageSpent, DateTime? lastVisit, Map<String, int> serviceFrequency
});




}
/// @nodoc
class __$SelectedCustomerAnalyticsCopyWithImpl<$Res>
    implements _$SelectedCustomerAnalyticsCopyWith<$Res> {
  __$SelectedCustomerAnalyticsCopyWithImpl(this._self, this._then);

  final _SelectedCustomerAnalytics _self;
  final $Res Function(_SelectedCustomerAnalytics) _then;

/// Create a copy of SelectedCustomerAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSpent = null,Object? visitCount = null,Object? averageSpent = null,Object? lastVisit = freezed,Object? serviceFrequency = null,}) {
  return _then(_SelectedCustomerAnalytics(
totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,averageSpent: null == averageSpent ? _self.averageSpent : averageSpent // ignore: cast_nullable_to_non_nullable
as double,lastVisit: freezed == lastVisit ? _self.lastVisit : lastVisit // ignore: cast_nullable_to_non_nullable
as DateTime?,serviceFrequency: null == serviceFrequency ? _self._serviceFrequency : serviceFrequency // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
