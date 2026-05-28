import 'package:go_router/go_router.dart';
import 'package:experience_app/core/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/feature/ecommerce/presentation/provider/bag_provider.dart';

String getColorName(Color color) {
  if (color.value == const Color(0xFF1F2024).value) {
    return 'Black';
  }
  if (color.value == const Color(0xFF71727A).value) {
    return 'Dark Grey';
  }
  if (color.value == const Color(0xFFC5C6CC).value) {
    return 'Grey';
  }
  if (color.value == const Color(0xFFE8E9F1).value) {
    return 'Light Grey';
  }
  return 'Color';
}

class BagView extends ConsumerWidget {
  const BagView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bag = ref.watch(bagProvider);
    final notifier = ref.read(bagProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF006FFD)),
          onPressed: () {
            context.goNamed(Routes.home);
          },
        ),
        title: const Text(
          'Your bag',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bag.length,
                itemBuilder: (context, index) {
                  final item = bag[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: Color(0xFFB4DBFF),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      notifier.decrease(index);
                                    },
                                    icon: const Icon(Icons.remove, size: 20),
                                    color: Color(0xFF006FFD),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      notifier.increase(index);
                                    },
                                    icon: const Icon(Icons.add, size: 20),
                                    color: Color(0xFF006FFD),
                                  ),
                                  Text(
                                    'Q ${(item.total).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Q ${notifier.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006FFD),
                ),
                onPressed: () {
                  context.goNamed(Routes.checkout);
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
