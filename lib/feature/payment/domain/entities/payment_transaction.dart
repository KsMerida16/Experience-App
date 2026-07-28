import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_transaction.freezed.dart';

@freezed
sealed class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    required double amount,
    required String currency,
    required String concept,
    required String status, // approved | declined | insufficient_funds | error
    required String cardLast4,
    String? transactionId,
    required DateTime date,
  }) = _PaymentTransaction;
}
