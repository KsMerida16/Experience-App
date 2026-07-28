import 'package:experience_app/feature/ecommerce/data/data_source/firebase_product_data_source.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getProducts() => _dataSource.getProducts();

  @override
  Future<Product> createProduct(Product product) =>
      _dataSource.createProduct(product);

  @override
  Future<void> updateProduct(Product product) =>
      _dataSource.updateProduct(product);

  @override
  Future<void> deleteProduct(String id) => _dataSource.deleteProduct(id);

  @override
  Stream<List<Product>> streamProducts() => _dataSource.streamProducts();
}
