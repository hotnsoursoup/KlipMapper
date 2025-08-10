// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 String get id; String get ticketId; String get paymentMethod; double get amount; double get tipAmount; String? get cardLastFour; String? get cardType; String? get transactionId; String get status; double? get refundAmount; String? get refundReason; DateTime? get refundedAt; DateTime get createdAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.tipAmount, tipAmount) || other.tipAmount == tipAmount)&&(identical(other.cardLastFour, cardLastFour) || other.cardLastFour == cardLastFour)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.refundReason, refundReason) || other.refundReason == refundReason)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketId,paymentMethod,amount,tipAmount,cardLastFour,cardType,transactionId,status,refundAmount,refundReason,refundedAt,createdAt);

@override
String toString() {
  return 'Payment(id: $id, ticketId: $ticketId, paymentMethod: $paymentMethod, amount: $amount, tipAmount: $tipAmount, cardLastFour: $cardLastFour, cardType: $cardType, transactionId: $transactionId, status: $status, refundAmount: $refundAmount, refundReason: $refundReason, refundedAt: $refundedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String ticketId, String paymentMethod, double amount, double tipAmount, String? cardLastFour, String? cardType, String? transactionId, String status, double? refundAmount, String? refundReason, DateTime? refundedAt, DateTime createdAt
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ticketId = null,Object? paymentMethod = null,Object? amount = null,Object? tipAmount = null,Object? cardLastFour = freezed,Object? cardType = freezed,Object? transactionId = freezed,Object? status = null,Object? refundAmount = freezed,Object? refundReason = freezed,Object? refundedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,tipAmount: null == tipAmount ? _self.tipAmount : tipAmount // ignore: cast_nullable_to_non_nullable
as double,cardLastFour: freezed == cardLastFour ? _self.cardLastFour : cardLastFour // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double?,refundReason: freezed == refundReason ? _self.refundReason : refundReason // ignore: cast_nullable_to_non_nullable
as String?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ticketId,  String paymentMethod,  double amount,  double tipAmount,  String? cardLastFour,  String? cardType,  String? transactionId,  String status,  double? refundAmount,  String? refundReason,  DateTime? refundedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.ticketId,_that.paymentMethod,_that.amount,_that.tipAmount,_that.cardLastFour,_that.cardType,_that.transactionId,_that.status,_that.refundAmount,_that.refundReason,_that.refundedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ticketId,  String paymentMethod,  double amount,  double tipAmount,  String? cardLastFour,  String? cardType,  String? transactionId,  String status,  double? refundAmount,  String? refundReason,  DateTime? refundedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.ticketId,_that.paymentMethod,_that.amount,_that.tipAmount,_that.cardLastFour,_that.cardType,_that.transactionId,_that.status,_that.refundAmount,_that.refundReason,_that.refundedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ticketId,  String paymentMethod,  double amount,  double tipAmount,  String? cardLastFour,  String? cardType,  String? transactionId,  String status,  double? refundAmount,  String? refundReason,  DateTime? refundedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.ticketId,_that.paymentMethod,_that.amount,_that.tipAmount,_that.cardLastFour,_that.cardType,_that.transactionId,_that.status,_that.refundAmount,_that.refundReason,_that.refundedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.id, required this.ticketId, required this.paymentMethod, required this.amount, this.tipAmount = 0.0, this.cardLastFour, this.cardType, this.transactionId, this.status = 'completed', this.refundAmount, this.refundReason, this.refundedAt, required this.createdAt});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override final  String ticketId;
@override final  String paymentMethod;
@override final  double amount;
@override@JsonKey() final  double tipAmount;
@override final  String? cardLastFour;
@override final  String? cardType;
@override final  String? transactionId;
@override@JsonKey() final  String status;
@override final  double? refundAmount;
@override final  String? refundReason;
@override final  DateTime? refundedAt;
@override final  DateTime createdAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.tipAmount, tipAmount) || other.tipAmount == tipAmount)&&(identical(other.cardLastFour, cardLastFour) || other.cardLastFour == cardLastFour)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.refundReason, refundReason) || other.refundReason == refundReason)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketId,paymentMethod,amount,tipAmount,cardLastFour,cardType,transactionId,status,refundAmount,refundReason,refundedAt,createdAt);

@override
String toString() {
  return 'Payment(id: $id, ticketId: $ticketId, paymentMethod: $paymentMethod, amount: $amount, tipAmount: $tipAmount, cardLastFour: $cardLastFour, cardType: $cardType, transactionId: $transactionId, status: $status, refundAmount: $refundAmount, refundReason: $refundReason, refundedAt: $refundedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String ticketId, String paymentMethod, double amount, double tipAmount, String? cardLastFour, String? cardType, String? transactionId, String status, double? refundAmount, String? refundReason, DateTime? refundedAt, DateTime createdAt
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketId = null,Object? paymentMethod = null,Object? amount = null,Object? tipAmount = null,Object? cardLastFour = freezed,Object? cardType = freezed,Object? transactionId = freezed,Object? status = null,Object? refundAmount = freezed,Object? refundReason = freezed,Object? refundedAt = freezed,Object? createdAt = null,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,tipAmount: null == tipAmount ? _self.tipAmount : tipAmount // ignore: cast_nullable_to_non_nullable
as double,cardLastFour: freezed == cardLastFour ? _self.cardLastFour : cardLastFour // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double?,refundReason: freezed == refundReason ? _self.refundReason : refundReason // ignore: cast_nullable_to_non_nullable
as String?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
