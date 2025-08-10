// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GiftCard {

 String get id; String get code; double get initialBalance; double get currentBalance; String? get customerId; String? get purchasedByCustomerId; String get status; DateTime? get expiresAt; String? get notes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of GiftCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftCardCopyWith<GiftCard> get copyWith => _$GiftCardCopyWithImpl<GiftCard>(this as GiftCard, _$identity);

  /// Serializes this GiftCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftCard&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.purchasedByCustomerId, purchasedByCustomerId) || other.purchasedByCustomerId == purchasedByCustomerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,initialBalance,currentBalance,customerId,purchasedByCustomerId,status,expiresAt,notes,createdAt,updatedAt);

@override
String toString() {
  return 'GiftCard(id: $id, code: $code, initialBalance: $initialBalance, currentBalance: $currentBalance, customerId: $customerId, purchasedByCustomerId: $purchasedByCustomerId, status: $status, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GiftCardCopyWith<$Res>  {
  factory $GiftCardCopyWith(GiftCard value, $Res Function(GiftCard) _then) = _$GiftCardCopyWithImpl;
@useResult
$Res call({
 String id, String code, double initialBalance, double currentBalance, String? customerId, String? purchasedByCustomerId, String status, DateTime? expiresAt, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$GiftCardCopyWithImpl<$Res>
    implements $GiftCardCopyWith<$Res> {
  _$GiftCardCopyWithImpl(this._self, this._then);

  final GiftCard _self;
  final $Res Function(GiftCard) _then;

/// Create a copy of GiftCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? initialBalance = null,Object? currentBalance = null,Object? customerId = freezed,Object? purchasedByCustomerId = freezed,Object? status = null,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,purchasedByCustomerId: freezed == purchasedByCustomerId ? _self.purchasedByCustomerId : purchasedByCustomerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GiftCard].
extension GiftCardPatterns on GiftCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftCard value)  $default,){
final _that = this;
switch (_that) {
case _GiftCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftCard value)?  $default,){
final _that = this;
switch (_that) {
case _GiftCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  double initialBalance,  double currentBalance,  String? customerId,  String? purchasedByCustomerId,  String status,  DateTime? expiresAt,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftCard() when $default != null:
return $default(_that.id,_that.code,_that.initialBalance,_that.currentBalance,_that.customerId,_that.purchasedByCustomerId,_that.status,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  double initialBalance,  double currentBalance,  String? customerId,  String? purchasedByCustomerId,  String status,  DateTime? expiresAt,  String? notes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GiftCard():
return $default(_that.id,_that.code,_that.initialBalance,_that.currentBalance,_that.customerId,_that.purchasedByCustomerId,_that.status,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  double initialBalance,  double currentBalance,  String? customerId,  String? purchasedByCustomerId,  String status,  DateTime? expiresAt,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GiftCard() when $default != null:
return $default(_that.id,_that.code,_that.initialBalance,_that.currentBalance,_that.customerId,_that.purchasedByCustomerId,_that.status,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GiftCard implements GiftCard {
  const _GiftCard({required this.id, required this.code, required this.initialBalance, required this.currentBalance, this.customerId, this.purchasedByCustomerId, this.status = 'active', this.expiresAt, this.notes, required this.createdAt, required this.updatedAt});
  factory _GiftCard.fromJson(Map<String, dynamic> json) => _$GiftCardFromJson(json);

@override final  String id;
@override final  String code;
@override final  double initialBalance;
@override final  double currentBalance;
@override final  String? customerId;
@override final  String? purchasedByCustomerId;
@override@JsonKey() final  String status;
@override final  DateTime? expiresAt;
@override final  String? notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of GiftCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftCardCopyWith<_GiftCard> get copyWith => __$GiftCardCopyWithImpl<_GiftCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftCard&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.purchasedByCustomerId, purchasedByCustomerId) || other.purchasedByCustomerId == purchasedByCustomerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,initialBalance,currentBalance,customerId,purchasedByCustomerId,status,expiresAt,notes,createdAt,updatedAt);

@override
String toString() {
  return 'GiftCard(id: $id, code: $code, initialBalance: $initialBalance, currentBalance: $currentBalance, customerId: $customerId, purchasedByCustomerId: $purchasedByCustomerId, status: $status, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GiftCardCopyWith<$Res> implements $GiftCardCopyWith<$Res> {
  factory _$GiftCardCopyWith(_GiftCard value, $Res Function(_GiftCard) _then) = __$GiftCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, double initialBalance, double currentBalance, String? customerId, String? purchasedByCustomerId, String status, DateTime? expiresAt, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$GiftCardCopyWithImpl<$Res>
    implements _$GiftCardCopyWith<$Res> {
  __$GiftCardCopyWithImpl(this._self, this._then);

  final _GiftCard _self;
  final $Res Function(_GiftCard) _then;

/// Create a copy of GiftCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? initialBalance = null,Object? currentBalance = null,Object? customerId = freezed,Object? purchasedByCustomerId = freezed,Object? status = null,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GiftCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,purchasedByCustomerId: freezed == purchasedByCustomerId ? _self.purchasedByCustomerId : purchasedByCustomerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$GiftCardTransaction {

 int get id; String get giftCardId; String? get ticketId; String get transactionType; double get amount; double get balanceAfter; DateTime get createdAt;
/// Create a copy of GiftCardTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftCardTransactionCopyWith<GiftCardTransaction> get copyWith => _$GiftCardTransactionCopyWithImpl<GiftCardTransaction>(this as GiftCardTransaction, _$identity);

  /// Serializes this GiftCardTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftCardTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.giftCardId, giftCardId) || other.giftCardId == giftCardId)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,giftCardId,ticketId,transactionType,amount,balanceAfter,createdAt);

@override
String toString() {
  return 'GiftCardTransaction(id: $id, giftCardId: $giftCardId, ticketId: $ticketId, transactionType: $transactionType, amount: $amount, balanceAfter: $balanceAfter, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GiftCardTransactionCopyWith<$Res>  {
  factory $GiftCardTransactionCopyWith(GiftCardTransaction value, $Res Function(GiftCardTransaction) _then) = _$GiftCardTransactionCopyWithImpl;
@useResult
$Res call({
 int id, String giftCardId, String? ticketId, String transactionType, double amount, double balanceAfter, DateTime createdAt
});




}
/// @nodoc
class _$GiftCardTransactionCopyWithImpl<$Res>
    implements $GiftCardTransactionCopyWith<$Res> {
  _$GiftCardTransactionCopyWithImpl(this._self, this._then);

  final GiftCardTransaction _self;
  final $Res Function(GiftCardTransaction) _then;

/// Create a copy of GiftCardTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? giftCardId = null,Object? ticketId = freezed,Object? transactionType = null,Object? amount = null,Object? balanceAfter = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,giftCardId: null == giftCardId ? _self.giftCardId : giftCardId // ignore: cast_nullable_to_non_nullable
as String,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GiftCardTransaction].
extension GiftCardTransactionPatterns on GiftCardTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftCardTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftCardTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftCardTransaction value)  $default,){
final _that = this;
switch (_that) {
case _GiftCardTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftCardTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _GiftCardTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String giftCardId,  String? ticketId,  String transactionType,  double amount,  double balanceAfter,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftCardTransaction() when $default != null:
return $default(_that.id,_that.giftCardId,_that.ticketId,_that.transactionType,_that.amount,_that.balanceAfter,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String giftCardId,  String? ticketId,  String transactionType,  double amount,  double balanceAfter,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _GiftCardTransaction():
return $default(_that.id,_that.giftCardId,_that.ticketId,_that.transactionType,_that.amount,_that.balanceAfter,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String giftCardId,  String? ticketId,  String transactionType,  double amount,  double balanceAfter,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GiftCardTransaction() when $default != null:
return $default(_that.id,_that.giftCardId,_that.ticketId,_that.transactionType,_that.amount,_that.balanceAfter,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GiftCardTransaction implements GiftCardTransaction {
  const _GiftCardTransaction({required this.id, required this.giftCardId, this.ticketId, required this.transactionType, required this.amount, required this.balanceAfter, required this.createdAt});
  factory _GiftCardTransaction.fromJson(Map<String, dynamic> json) => _$GiftCardTransactionFromJson(json);

@override final  int id;
@override final  String giftCardId;
@override final  String? ticketId;
@override final  String transactionType;
@override final  double amount;
@override final  double balanceAfter;
@override final  DateTime createdAt;

/// Create a copy of GiftCardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftCardTransactionCopyWith<_GiftCardTransaction> get copyWith => __$GiftCardTransactionCopyWithImpl<_GiftCardTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftCardTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftCardTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.giftCardId, giftCardId) || other.giftCardId == giftCardId)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,giftCardId,ticketId,transactionType,amount,balanceAfter,createdAt);

@override
String toString() {
  return 'GiftCardTransaction(id: $id, giftCardId: $giftCardId, ticketId: $ticketId, transactionType: $transactionType, amount: $amount, balanceAfter: $balanceAfter, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GiftCardTransactionCopyWith<$Res> implements $GiftCardTransactionCopyWith<$Res> {
  factory _$GiftCardTransactionCopyWith(_GiftCardTransaction value, $Res Function(_GiftCardTransaction) _then) = __$GiftCardTransactionCopyWithImpl;
@override @useResult
$Res call({
 int id, String giftCardId, String? ticketId, String transactionType, double amount, double balanceAfter, DateTime createdAt
});




}
/// @nodoc
class __$GiftCardTransactionCopyWithImpl<$Res>
    implements _$GiftCardTransactionCopyWith<$Res> {
  __$GiftCardTransactionCopyWithImpl(this._self, this._then);

  final _GiftCardTransaction _self;
  final $Res Function(_GiftCardTransaction) _then;

/// Create a copy of GiftCardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? giftCardId = null,Object? ticketId = freezed,Object? transactionType = null,Object? amount = null,Object? balanceAfter = null,Object? createdAt = null,}) {
  return _then(_GiftCardTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,giftCardId: null == giftCardId ? _self.giftCardId : giftCardId // ignore: cast_nullable_to_non_nullable
as String,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
