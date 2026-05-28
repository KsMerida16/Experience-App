import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/domain/repositories/product_repository.dart';
import 'package:experience_app/feature/ecommerce/data/data_source/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  List<Product> getProducts() {
    final models = dataSource.getProducts();

    return models.map((model) {
      return Product(
        name: model.title,
        price: model.cost,
        description: model.description,
        sizes: model.sizes,
        colors: model.colors,
      );
    }).toList();
  }
}