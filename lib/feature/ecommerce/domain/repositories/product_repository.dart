import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Stream<List<Product>> streamProducts();
  Future<Product> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
