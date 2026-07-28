import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/feature/ecommerce/data/data_source/bag_local_storage.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/car_item.dart';
import '../../domain/entities/product.dart';

final bagProvider = NotifierProvider<BagNotifier, List<CarItem>>(
  BagNotifier.new,
);

class BagNotifier extends Notifier<List<CarItem>> {
  final storage = BagLocalStorage();

  @override
  List<CarItem> build() {
    loadBag();
    return [];
  }

  Future<void> addProduct(Product product, String size, Color color) async {
    final index = state.indexWhere(
      (item) =>
          item.product.name == product.name &&
          item.selectedSize == size &&
          item.selectedColor.value == color.value,
    );
    if (index >= 0) {
      final updated = [...state];
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
      state = updated;
    } else {
      state = [
        ...state,
        CarItem(
          product: product,
          quantity: 1,
          selectedSize: size,
          selectedColor: color,
        ),
      ];
    }
    await saveBag();
  }

  Future<void> increase(int index) async {
    final updated = [...state];
    updated[index] = updated[index].copyWith(
      quantity: updated[index].quantity + 1,
    );
    state = updated;
    await saveBag();
  }

  Future<void> decrease(int index) async {
    final updated = [...state];
    if (updated[index].quantity > 1) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
      state = updated;
    } else {
      updated.removeAt(index);
      state = updated;
    }
    await saveBag();
  }

  Future<void> clearBag() async {
    state = [];
    await saveBag();
  }

  double get totalPrice {
    double total = 0;
    for (final item in state) {
      total += item.total;
    }
    return total;
  }

  Future<void> saveBag() async {
    final data = state.map((item) {
      return {
        'id': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'description': item.product.description,
        'quantity': item.quantity,
        'size': item.selectedSize,
        'color': item.selectedColor.value,
      };
    }).toList();
    await storage.saveBag(data);
  }

  Future<void> loadBag() async {
    final data = await storage.loadBag();
    final loadedItems = data.map<CarItem>((item) {
      return CarItem(
        product: Product(
          id: item['id'] ?? '',
          name: item['name'],
          price: item['price'],
          description: item['description'],
          sizes: const [],
          colorsHex: const [],
        ),
        quantity: item['quantity'],
        selectedSize: item['size'],
        selectedColor: Color(item['color']),
      );
    }).toList();
    state = loadedItems;
  }
}
