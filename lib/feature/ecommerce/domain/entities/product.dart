import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String description;
  final List<String> sizes;
  final List<Color> colors;

  const Product({
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
    required this.colors,
  });
}
