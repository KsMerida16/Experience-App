import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/feature/ecommerce/data/data_source/product_local_data_source.dart';
import 'package:experience_app/feature/ecommerce/data/repositories/product_repository_impl.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';

final productProvider = Provider<List<Product>>((ref) {
  final dataSource = ProductLocalDataSource();
  final repository = ProductRepositoryImpl(dataSource);

  return repository.getProducts();
});
