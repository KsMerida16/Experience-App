import 'package:dio/dio.dart';
import 'package:experience_app/feature/payment/data/datasources/payment_api_config.dart';
import 'package:experience_app/feature/payment/domain/entities/payment_result.dart';

class PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'GTQ',
  }) async {
    final cleanNumber = cardNumber.replaceAll(' ', '');

    try {
      final response = await _dio.post(
        PaymentApiConfig.processPaymentUrl,
        data: {
          'amount': amount,
          'cardNumber': cleanNumber,
          'currency': currency,
        },
      );

      final json = response.data as Map<String, dynamic>;

      return PaymentResult(
        success: json['success'] as bool? ?? false,
        status: json['status'] as String? ?? 'declined',
        transactionId: json['transactionId'] as String?,
        amount: (json['amount'] as num?)?.toDouble() ?? amount,
        currency: json['currency'] as String? ?? currency,
        cardLast4:
            json['cardLast4'] as String? ??
            (cleanNumber.length >= 4
                ? cleanNumber.substring(cleanNumber.length - 4)
                : cleanNumber),
        message: json['message'] as String? ?? '',
        timestamp:
            DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
      );
    } on DioException catch (e) {
      return PaymentResult(
        success: false,
        status: 'error',
        transactionId: null,
        amount: amount,
        currency: currency,
        cardLast4: cleanNumber.length >= 4
            ? cleanNumber.substring(cleanNumber.length - 4)
            : cleanNumber,
        message: 'No se pudo conectar con el servidor de pagos.',
        timestamp: DateTime.now(),
      );
    }
  }
}
