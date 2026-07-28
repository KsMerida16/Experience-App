import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';

class ProductModel {
  static Product fromFirestore(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sizes: List<String>.from(json['sizes'] ?? const []),
      colorsHex: List<String>.from(json['colors'] ?? const []),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toFirestore(Product product) {
    return {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'sizes': product.sizes,
      'colors': product.colorsHex,
      'imageUrl': product.imageUrl,
    };
  }
}
