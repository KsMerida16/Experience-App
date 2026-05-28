import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/feature/payment/data/datasources/payment_local_storage.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';

final paymentProvider =
    NotifierProvider<PaymentNotifier, List<CreditCardEntity>>(
      PaymentNotifier.new,
    );
final selectedCardProvider = NotifierProvider<SelectedCardNotifier, int>(
  SelectedCardNotifier.new,
);

class SelectedCardNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void selectCard(int index) {
    state = index;
  }
}

class PaymentNotifier extends Notifier<List<CreditCardEntity>> {
  final storage = PaymentLocalStorage();
  @override
  List<CreditCardEntity> build() {
    loadCards();
    return [];
  }

  Future<void> addCard(CreditCardEntity card) async {
    state = [...state, card];
    await saveCards();
  }

  Future<void> saveCards() async {
    final data = state.map((card) {
      return {
        'holderName': card.holderName,
        'cardNumber': card.cardNumber,
        'expiryDate': card.expiryDate,
        'cvv': card.cvv,
        'brand': card.brand,
      };
    }).toList();
    await storage.saveCards(data);
  }

  Future<void> loadCards() async {
    final data = await storage.loadCards();
    final loadedCards = data.map<CreditCardEntity>((item) {
      return CreditCardEntity(
        holderName: item['holderName'] ?? '',
        cardNumber: item['cardNumber'] ?? '',
        expiryDate: item['expiryDate'] ?? '',
        cvv: item['cvv'] ?? '',
        brand: item['brand'] ?? '',
      );
    }).toList();
    state = loadedCards;
  }
}
