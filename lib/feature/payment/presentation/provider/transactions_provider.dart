import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:experience_app/feature/payment/data/datasources/firebase_transaction_data_source.dart';
import 'package:experience_app/feature/payment/domain/entities/payment_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionDataSourceProvider = Provider<FirebaseTransactionDataSource>((
  ref,
) {
  return FirebaseTransactionDataSource();
});

final transactionsProvider = StreamProvider<List<PaymentTransaction>>((ref) {
  final uid = ref.watch(authProvider).value?.uid;

  if (uid == null) {
    return const Stream.empty();
  }

  final ds = ref.read(transactionDataSourceProvider);

  return ds.streamTransactions(uid);
});

// ============================================================
// VENTA ESPECÍFICA
// ============================================================

final saleByIdProvider = FutureProvider.family<PaymentTransaction?, String>((
  ref,
  saleId,
) async {
  final ds = ref.read(transactionDataSourceProvider);

  return ds.getSaleById(saleId);
});
