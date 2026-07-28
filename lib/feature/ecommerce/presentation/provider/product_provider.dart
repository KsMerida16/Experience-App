import 'package:experience_app/feature/ecommerce/data/data_source/firebase_product_data_source.dart';
import 'package:experience_app/feature/ecommerce/data/data_source/firebase_storage_data_source.dart';
import 'package:experience_app/feature/ecommerce/data/repositories/product_repository_impl.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/domain/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(FirebaseProductDataSource());
});

final productProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.streamProducts();
});

final productActionsProvider = Provider<ProductActions>((ref) {
  return ProductActions(ref.read(productRepositoryProvider));
});

class ProductActions {
  final ProductRepository _repo;

  ProductActions(this._repo);

  Future<void> addProduct(Product product) {
    return _repo.createProduct(product);
  }

  Future<void> editProduct(Product product) {
    return _repo.updateProduct(product);
  }

  Future<void> removeProduct(Product product) async {
    if (product.imageUrl.isNotEmpty) {
      await FirebaseStorageDataSource().deleteProductImage(product.imageUrl);
    }
    await _repo.deleteProduct(product.id);
  }
}
