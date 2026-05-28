import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();
}