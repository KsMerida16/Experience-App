import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_result.freezed.dart';

@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    required bool success,
    required String status, // approved | declined | insufficient_funds | error
    String? transactionId,
    required double amount,
    required String currency,
    required String cardLast4,
    required String message,
    required DateTime timestamp,
  }) = _PaymentResult;
}
