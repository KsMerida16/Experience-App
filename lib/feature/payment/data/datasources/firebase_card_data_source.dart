import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';

class FirebaseCardDataSource {
  final FirebaseFirestore _firestore;

  FirebaseCardDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _cardsRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('cards');

  Future<List<CreditCardEntity>> getCards(String uid) async {
    final snapshot = await _cardsRef(uid).get();
    return snapshot.docs
        .map((doc) => _fromFirestore(doc.id, doc.data()))
        .where((card) => card.isActive)
        .toList();
  }

  Future<CreditCardEntity> addCard(String uid, CreditCardEntity card) async {
    final docRef = await _cardsRef(uid).add(_toFirestore(card));
    return card.copyWith(id: docRef.id);
  }

  Future<void> updateCard(String uid, CreditCardEntity card) async {
    await _cardsRef(uid).doc(card.id).update(_toFirestore(card));
  }

  Future<void> deactivateCard(String uid, String cardId) async {
    await _cardsRef(uid).doc(cardId).update({'isActive': false});
  }

  CreditCardEntity _fromFirestore(String id, Map<String, dynamic> json) {
    return CreditCardEntity(
      id: id,
      holderName: json['holderName'] as String? ?? '',
      cardNumber: json['cardNumber'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      cvv: '',
      brand: json['brand'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> _toFirestore(CreditCardEntity card) {
    return {
      'holderName': card.holderName,
      'cardNumber': card.cardNumber.replaceAll(' ', ''),
      'expiryDate': card.expiryDate,
      'brand': card.brand,
      'isActive': card.isActive,
    };
  }
}
