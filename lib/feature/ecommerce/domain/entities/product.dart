import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required List<String> sizes,
    required List<String> colorsHex,
    @Default('') String imageUrl,
  }) = _Product;
}
