import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_app/feature/payment/domain/entities/payment_transaction.dart';

class FirebaseTransactionDataSource {
  final FirebaseFirestore _firestore;

  FirebaseTransactionDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _ref(String uid) =>
      _firestore.collection('users').doc(uid).collection('transactions');

  CollectionReference<Map<String, dynamic>> get _salesRef =>
      _firestore.collection('sales');

  // ============================================================
  // TRANSACCIONES DEL USUARIO
  // ============================================================

  Future<void> saveTransaction(String uid, PaymentTransaction tx) async {
    final transactionData = {
      'amount': tx.amount,
      'currency': tx.currency,
      'concept': tx.concept,
      'status': tx.status,
      'cardLast4': tx.cardLast4,
      'transactionId': tx.transactionId,
      'date': Timestamp.fromDate(tx.date),
    };

    await _ref(uid).add(transactionData);


    await _salesRef.add({
      'user_id': uid,
      'total': tx.amount,
      'currency': tx.currency,
      'concept': tx.concept,
      'status': tx.status,
      'cardLast4': tx.cardLast4,
      'transactionId': tx.transactionId,
      'date': Timestamp.fromDate(tx.date),
    });
  }

  Future<List<PaymentTransaction>> getTransactions(String uid) async {
    final snapshot = await _ref(uid).orderBy('date', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return PaymentTransaction(
        id: doc.id,
        amount: (data['amount'] as num).toDouble(),
        currency: data['currency'] as String? ?? 'GTQ',
        concept: data['concept'] as String? ?? '',
        status: data['status'] as String? ?? '',
        cardLast4: data['cardLast4'] as String? ?? '',
        transactionId: data['transactionId'] as String?,
        date: (data['date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Stream<List<PaymentTransaction>> streamTransactions(String uid) {
    return _ref(uid).orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return PaymentTransaction(
          id: doc.id,
          amount: (data['amount'] as num).toDouble(),
          currency: data['currency'] as String? ?? 'GTQ',
          concept: data['concept'] as String? ?? '',
          status: data['status'] as String? ?? '',
          cardLast4: data['cardLast4'] as String? ?? '',
          transactionId: data['transactionId'] as String?,
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // ============================================================
  // VENTA ESPECÍFICA
  // ============================================================

  Future<PaymentTransaction?> getSaleById(String saleId) async {
    final document = await _salesRef.doc(saleId).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    final dateValue = data['date'];

    DateTime date;

    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else {
      date = DateTime.now();
    }

    return PaymentTransaction(
      id: document.id,
      amount: (data['total'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'GTQ',
      concept: data['concept'] as String? ?? '',
      status: data['status'] as String? ?? '',
      cardLast4: data['cardLast4'] as String? ?? '',
      transactionId: data['transactionId'] as String?,
      date: date,
    );
  }
}
