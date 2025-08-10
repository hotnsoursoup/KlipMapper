// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {

 Set<String> get selectedTicketIds; double get tipPercentage; double get customTipAmount; String? get discountType; double get discountAmount; String? get discountCode; String? get discountReason; String? get paymentMethod; String? get cardType; String? get lastFourDigits; bool get isProcessing; String? get errorMessage; String get searchQuery; String? get statusFilter; String get sortBy;
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutStateCopyWith<CheckoutState> get copyWith => _$CheckoutStateCopyWithImpl<CheckoutState>(this as CheckoutState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState&&const DeepCollectionEquality().equals(other.selectedTicketIds, selectedTicketIds)&&(identical(other.tipPercentage, tipPercentage) || other.tipPercentage == tipPercentage)&&(identical(other.customTipAmount, customTipAmount) || other.customTipAmount == customTipAmount)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountCode, discountCode) || other.discountCode == discountCode)&&(identical(other.discountReason, discountReason) || other.discountReason == discountReason)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.lastFourDigits, lastFourDigits) || other.lastFourDigits == lastFourDigits)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedTicketIds),tipPercentage,customTipAmount,discountType,discountAmount,discountCode,discountReason,paymentMethod,cardType,lastFourDigits,isProcessing,errorMessage,searchQuery,statusFilter,sortBy);

@override
String toString() {
  return 'CheckoutState(selectedTicketIds: $selectedTicketIds, tipPercentage: $tipPercentage, customTipAmount: $customTipAmount, discountType: $discountType, discountAmount: $discountAmount, discountCode: $discountCode, discountReason: $discountReason, paymentMethod: $paymentMethod, cardType: $cardType, lastFourDigits: $lastFourDigits, isProcessing: $isProcessing, errorMessage: $errorMessage, searchQuery: $searchQuery, statusFilter: $statusFilter, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $CheckoutStateCopyWith<$Res>  {
  factory $CheckoutStateCopyWith(CheckoutState value, $Res Function(CheckoutState) _then) = _$CheckoutStateCopyWithImpl;
@useResult
$Res call({
 Set<String> selectedTicketIds, double tipPercentage, double customTipAmount, String? discountType, double discountAmount, String? discountCode, String? discountReason, String? paymentMethod, String? cardType, String? lastFourDigits, bool isProcessing, String? errorMessage, String searchQuery, String? statusFilter, String sortBy
});




}
/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._self, this._then);

  final CheckoutState _self;
  final $Res Function(CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTicketIds = null,Object? tipPercentage = null,Object? customTipAmount = null,Object? discountType = freezed,Object? discountAmount = null,Object? discountCode = freezed,Object? discountReason = freezed,Object? paymentMethod = freezed,Object? cardType = freezed,Object? lastFourDigits = freezed,Object? isProcessing = null,Object? errorMessage = freezed,Object? searchQuery = null,Object? statusFilter = freezed,Object? sortBy = null,}) {
  return _then(_self.copyWith(
selectedTicketIds: null == selectedTicketIds ? _self.selectedTicketIds : selectedTicketIds // ignore: cast_nullable_to_non_nullable
as Set<String>,tipPercentage: null == tipPercentage ? _self.tipPercentage : tipPercentage // ignore: cast_nullable_to_non_nullable
as double,customTipAmount: null == customTipAmount ? _self.customTipAmount : customTipAmount // ignore: cast_nullable_to_non_nullable
as double,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,discountCode: freezed == discountCode ? _self.discountCode : discountCode // ignore: cast_nullable_to_non_nullable
as String?,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,lastFourDigits: freezed == lastFourDigits ? _self.lastFourDigits : lastFourDigits // ignore: cast_nullable_to_non_nullable
as String?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutState value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> selectedTicketIds,  double tipPercentage,  double customTipAmount,  String? discountType,  double discountAmount,  String? discountCode,  String? discountReason,  String? paymentMethod,  String? cardType,  String? lastFourDigits,  bool isProcessing,  String? errorMessage,  String searchQuery,  String? statusFilter,  String sortBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.selectedTicketIds,_that.tipPercentage,_that.customTipAmount,_that.discountType,_that.discountAmount,_that.discountCode,_that.discountReason,_that.paymentMethod,_that.cardType,_that.lastFourDigits,_that.isProcessing,_that.errorMessage,_that.searchQuery,_that.statusFilter,_that.sortBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> selectedTicketIds,  double tipPercentage,  double customTipAmount,  String? discountType,  double discountAmount,  String? discountCode,  String? discountReason,  String? paymentMethod,  String? cardType,  String? lastFourDigits,  bool isProcessing,  String? errorMessage,  String searchQuery,  String? statusFilter,  String sortBy)  $default,) {final _that = this;
switch (_that) {
case _CheckoutState():
return $default(_that.selectedTicketIds,_that.tipPercentage,_that.customTipAmount,_that.discountType,_that.discountAmount,_that.discountCode,_that.discountReason,_that.paymentMethod,_that.cardType,_that.lastFourDigits,_that.isProcessing,_that.errorMessage,_that.searchQuery,_that.statusFilter,_that.sortBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> selectedTicketIds,  double tipPercentage,  double customTipAmount,  String? discountType,  double discountAmount,  String? discountCode,  String? discountReason,  String? paymentMethod,  String? cardType,  String? lastFourDigits,  bool isProcessing,  String? errorMessage,  String searchQuery,  String? statusFilter,  String sortBy)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.selectedTicketIds,_that.tipPercentage,_that.customTipAmount,_that.discountType,_that.discountAmount,_that.discountCode,_that.discountReason,_that.paymentMethod,_that.cardType,_that.lastFourDigits,_that.isProcessing,_that.errorMessage,_that.searchQuery,_that.statusFilter,_that.sortBy);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutState extends CheckoutState {
  const _CheckoutState({final  Set<String> selectedTicketIds = const {}, this.tipPercentage = 0.0, this.customTipAmount = 0.0, this.discountType, this.discountAmount = 0.0, this.discountCode, this.discountReason, this.paymentMethod, this.cardType, this.lastFourDigits, this.isProcessing = false, this.errorMessage, this.searchQuery = '', this.statusFilter, this.sortBy = 'status'}): _selectedTicketIds = selectedTicketIds,super._();
  

 final  Set<String> _selectedTicketIds;
@override@JsonKey() Set<String> get selectedTicketIds {
  if (_selectedTicketIds is EqualUnmodifiableSetView) return _selectedTicketIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedTicketIds);
}

@override@JsonKey() final  double tipPercentage;
@override@JsonKey() final  double customTipAmount;
@override final  String? discountType;
@override@JsonKey() final  double discountAmount;
@override final  String? discountCode;
@override final  String? discountReason;
@override final  String? paymentMethod;
@override final  String? cardType;
@override final  String? lastFourDigits;
@override@JsonKey() final  bool isProcessing;
@override final  String? errorMessage;
@override@JsonKey() final  String searchQuery;
@override final  String? statusFilter;
@override@JsonKey() final  String sortBy;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutStateCopyWith<_CheckoutState> get copyWith => __$CheckoutStateCopyWithImpl<_CheckoutState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutState&&const DeepCollectionEquality().equals(other._selectedTicketIds, _selectedTicketIds)&&(identical(other.tipPercentage, tipPercentage) || other.tipPercentage == tipPercentage)&&(identical(other.customTipAmount, customTipAmount) || other.customTipAmount == customTipAmount)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountCode, discountCode) || other.discountCode == discountCode)&&(identical(other.discountReason, discountReason) || other.discountReason == discountReason)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.lastFourDigits, lastFourDigits) || other.lastFourDigits == lastFourDigits)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedTicketIds),tipPercentage,customTipAmount,discountType,discountAmount,discountCode,discountReason,paymentMethod,cardType,lastFourDigits,isProcessing,errorMessage,searchQuery,statusFilter,sortBy);

@override
String toString() {
  return 'CheckoutState(selectedTicketIds: $selectedTicketIds, tipPercentage: $tipPercentage, customTipAmount: $customTipAmount, discountType: $discountType, discountAmount: $discountAmount, discountCode: $discountCode, discountReason: $discountReason, paymentMethod: $paymentMethod, cardType: $cardType, lastFourDigits: $lastFourDigits, isProcessing: $isProcessing, errorMessage: $errorMessage, searchQuery: $searchQuery, statusFilter: $statusFilter, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class _$CheckoutStateCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutStateCopyWith(_CheckoutState value, $Res Function(_CheckoutState) _then) = __$CheckoutStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> selectedTicketIds, double tipPercentage, double customTipAmount, String? discountType, double discountAmount, String? discountCode, String? discountReason, String? paymentMethod, String? cardType, String? lastFourDigits, bool isProcessing, String? errorMessage, String searchQuery, String? statusFilter, String sortBy
});




}
/// @nodoc
class __$CheckoutStateCopyWithImpl<$Res>
    implements _$CheckoutStateCopyWith<$Res> {
  __$CheckoutStateCopyWithImpl(this._self, this._then);

  final _CheckoutState _self;
  final $Res Function(_CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTicketIds = null,Object? tipPercentage = null,Object? customTipAmount = null,Object? discountType = freezed,Object? discountAmount = null,Object? discountCode = freezed,Object? discountReason = freezed,Object? paymentMethod = freezed,Object? cardType = freezed,Object? lastFourDigits = freezed,Object? isProcessing = null,Object? errorMessage = freezed,Object? searchQuery = null,Object? statusFilter = freezed,Object? sortBy = null,}) {
  return _then(_CheckoutState(
selectedTicketIds: null == selectedTicketIds ? _self._selectedTicketIds : selectedTicketIds // ignore: cast_nullable_to_non_nullable
as Set<String>,tipPercentage: null == tipPercentage ? _self.tipPercentage : tipPercentage // ignore: cast_nullable_to_non_nullable
as double,customTipAmount: null == customTipAmount ? _self.customTipAmount : customTipAmount // ignore: cast_nullable_to_non_nullable
as double,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,discountCode: freezed == discountCode ? _self.discountCode : discountCode // ignore: cast_nullable_to_non_nullable
as String?,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,lastFourDigits: freezed == lastFourDigits ? _self.lastFourDigits : lastFourDigits // ignore: cast_nullable_to_non_nullable
as String?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
