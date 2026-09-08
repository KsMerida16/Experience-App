import 'package:cloud_firestore/cloud_firestore.dart';

class LogDataSource {
  final FirebaseFirestore _firestore;

  LogDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> logEvent(String eventName, Map<String, dynamic> data) async {
    final logEntry = {
      'eventName': eventName,
      'data': data,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('logs').add(logEntry);
  }
}
