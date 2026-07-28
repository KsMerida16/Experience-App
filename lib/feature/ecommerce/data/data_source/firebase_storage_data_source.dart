import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSource({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadProductImage(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('products/$fileName');
    final uploadTask = await ref.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteProductImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (_) {}
  }
}
