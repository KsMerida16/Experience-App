import 'package:flutter/material.dart';
import 'package:experience_app/feature/ecommerce/data/models/product_model.dart';

class ProductLocalDataSource {
  List<ProductModel> getProducts() {
    return [
      ProductModel(
        title: 'Amazing T-shirt',
        cost: 12,
        description:
            'The perfect T-shirt for when you want to feel comfortable but still stylish. Amazing for all ocasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        colors: [
          Color(0xFF1F2024),
          Color(0xFF71727A),
          Color(0xFFC5C6CC),
          Color(0xFFE8E9F1),
        ],
      ),
      ProductModel(
        title: 'Faboulous Pants',
        cost: 15,
        description: 'Comfortable casual wear',
        sizes: ['S', 'M', 'L', 'XL'],
        colors: [Colors.black, Colors.brown, Colors.white],
      ),
      ProductModel(
        title: 'Spectacular Dress',
        cost: 20,
        description: 'Comfortable casual wear',
        sizes: ['M', 'L'],
        colors: [Colors.black, Colors.white],
      ),
      ProductModel(
        title: 'Stunning Jacket',
        cost: 18,
        description: 'Comfortable wear',
        sizes: ['M', 'L', 'XL'],
        colors: [Colors.black, Colors.brown],
      ),
    ];
  }
}
