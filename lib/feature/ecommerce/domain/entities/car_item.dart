import 'package:flutter/material.dart';

import 'product.dart';

class CarItem {
  final Product product;
  final int quantity;
  final String selectedSize;
  final Color selectedColor;

  CarItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get total => product.price * quantity;

  CarItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    Color? selectedColor,
  }) {
    return CarItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
