// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentTransaction {

 String get id; double get amount; String get currency; String get concept; String get status;// approved | declined | insufficient_funds | error
 String get cardLast4; String? get transactionId; DateTime get date;
/// Create a copy of PaymentTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentTransactionCopyWith<PaymentTransaction> get copyWith => _$PaymentTransactionCopyWithImpl<PaymentTransaction>(this as PaymentTransaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.concept, concept) || other.concept == concept)&&(identical(other.status, status) || other.status == status)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,currency,concept,status,cardLast4,transactionId,date);

@override
String toString() {
  return 'PaymentTransaction(id: $id, amount: $amount, currency: $currency, concept: $concept, status: $status, cardLast4: $cardLast4, transactionId: $transactionId, date: $date)';
}


}

/// @nodoc
abstract mixin class $PaymentTransactionCopyWith<$Res>  {
  factory $PaymentTransactionCopyWith(PaymentTransaction value, $Res Function(PaymentTransaction) _then) = _$PaymentTransactionCopyWithImpl;
@useResult
$Res call({
 String id, double amount, String currency, String concept, String status, String cardLast4, String? transactionId, DateTime date
});




}
/// @nodoc
class _$PaymentTransactionCopyWithImpl<$Res>
    implements $PaymentTransactionCopyWith<$Res> {
  _$PaymentTransactionCopyWithImpl(this._self, this._then);

  final PaymentTransaction _self;
  final $Res Function(PaymentTransaction) _then;

/// Create a copy of PaymentTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? currency = null,Object? concept = null,Object? status = null,Object? cardLast4 = null,Object? transactionId = freezed,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,concept: null == concept ? _self.concept : concept // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,cardLast4: null == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentTransaction].
extension PaymentTransactionPatterns on PaymentTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentTransaction value)  $default,){
final _that = this;
switch (_that) {
case _PaymentTransaction():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  String currency,  String concept,  String status,  String cardLast4,  String? transactionId,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentTransaction() when $default != null:
return $default(_that.id,_that.amount,_that.currency,_that.concept,_that.status,_that.cardLast4,_that.transactionId,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  String currency,  String concept,  String status,  String cardLast4,  String? transactionId,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _PaymentTransaction():
return $default(_that.id,_that.amount,_that.currency,_that.concept,_that.status,_that.cardLast4,_that.transactionId,_that.date);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  String currency,  String concept,  String status,  String cardLast4,  String? transactionId,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _PaymentTransaction() when $default != null:
return $default(_that.id,_that.amount,_that.currency,_that.concept,_that.status,_that.cardLast4,_that.transactionId,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentTransaction implements PaymentTransaction {
  const _PaymentTransaction({required this.id, required this.amount, required this.currency, required this.concept, required this.status, required this.cardLast4, this.transactionId, required this.date});
  

@override final  String id;
@override final  double amount;
@override final  String currency;
@override final  String concept;
@override final  String status;
// approved | declined | insufficient_funds | error
@override final  String cardLast4;
@override final  String? transactionId;
@override final  DateTime date;

/// Create a copy of PaymentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentTransactionCopyWith<_PaymentTransaction> get copyWith => __$PaymentTransactionCopyWithImpl<_PaymentTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.concept, concept) || other.concept == concept)&&(identical(other.status, status) || other.status == status)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,currency,concept,status,cardLast4,transactionId,date);

@override
String toString() {
  return 'PaymentTransaction(id: $id, amount: $amount, currency: $currency, concept: $concept, status: $status, cardLast4: $cardLast4, transactionId: $transactionId, date: $date)';
}


}

/// @nodoc
abstract mixin class _$PaymentTransactionCopyWith<$Res> implements $PaymentTransactionCopyWith<$Res> {
  factory _$PaymentTransactionCopyWith(_PaymentTransaction value, $Res Function(_PaymentTransaction) _then) = __$PaymentTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, String currency, String concept, String status, String cardLast4, String? transactionId, DateTime date
});




}
/// @nodoc
class __$PaymentTransactionCopyWithImpl<$Res>
    implements _$PaymentTransactionCopyWith<$Res> {
  __$PaymentTransactionCopyWithImpl(this._self, this._then);

  final _PaymentTransaction _self;
  final $Res Function(_PaymentTransaction) _then;

/// Create a copy of PaymentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? currency = null,Object? concept = null,Object? status = null,Object? cardLast4 = null,Object? transactionId = freezed,Object? date = null,}) {
  return _then(_PaymentTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,concept: null == concept ? _self.concept : concept // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,cardLast4: null == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
