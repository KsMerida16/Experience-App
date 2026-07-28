import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_app/feature/ecommerce/data/models/product_model.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';

class FirebaseProductDataSource {
  final FirebaseFirestore _firestore;

  FirebaseProductDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('products');

  Future<List<Product>> getProducts() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<Product> createProduct(Product product) async {
    final docRef = await _collection.add(ProductModel.toFirestore(product));
    return product.copyWith(id: docRef.id);
  }

  Future<void> updateProduct(Product product) async {
    await _collection.doc(product.id).update(ProductModel.toFirestore(product));
  }

  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<Product>> streamProducts() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }
}
