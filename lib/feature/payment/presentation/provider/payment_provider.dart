import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:experience_app/feature/payment/data/datasources/firebase_card_data_source.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardDataSourceProvider = Provider<FirebaseCardDataSource>((ref) {
  return FirebaseCardDataSource();
});

final paymentProvider =
    AsyncNotifierProvider<PaymentNotifier, List<CreditCardEntity>>(
      PaymentNotifier.new,
    );

class PaymentNotifier extends AsyncNotifier<List<CreditCardEntity>> {
  @override
  Future<List<CreditCardEntity>> build() async {
    final uid = ref.watch(authProvider).value?.uid;
    if (uid == null) return [];
    final ds = ref.read(cardDataSourceProvider);
    return ds.getCards(uid);
  }

  Future<void> addCard(CreditCardEntity card) async {
    final uid = ref.read(authProvider).value?.uid;
    if (uid == null) return;
    final ds = ref.read(cardDataSourceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ds.addCard(uid, card);
      return ds.getCards(uid);
    });
  }

  Future<void> editCard(CreditCardEntity card) async {
    final uid = ref.read(authProvider).value?.uid;
    if (uid == null) return;
    final ds = ref.read(cardDataSourceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ds.updateCard(uid, card);
      return ds.getCards(uid);
    });
  }

  Future<void> removeCard(String cardId) async {
    final uid = ref.read(authProvider).value?.uid;
    if (uid == null) return;
    final ds = ref.read(cardDataSourceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ds.deactivateCard(uid, cardId);
      return ds.getCards(uid);
    });
  }
}

final selectedCardProvider = NotifierProvider<SelectedCardNotifier, int>(
  SelectedCardNotifier.new,
);

class SelectedCardNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectCard(int index) => state = index;
}
