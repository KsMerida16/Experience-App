import 'package:flutter/material.dart';

class ProductModel {
  final String title;
  final double cost;
  final String description;
  final List<String> sizes;
  final List<Color> colors;
  
  ProductModel({
    required this.title,
    required this.cost,
    required this.description,
    required this.sizes,
    required this.colors,
  });
}
