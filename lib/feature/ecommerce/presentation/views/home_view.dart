import 'package:experience_app/core/navigation/router.dart';
import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:experience_app/feature/ecommerce/presentation/provider/product_provider.dart';
import 'package:experience_app/feature/ecommerce/presentation/widgets/auto_carousel.dart';
import 'package:experience_app/feature/ecommerce/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);
    final isAdmin = ref.watch(authProvider).value?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Cerrar sesión'),
                content: const Text('¿Deseas cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            );

            if (result == true) {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.goNamed(Routes.login);
              }
            }
          },
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF006FFD)),
              tooltip: 'Gestionar productos',
              onPressed: () {
                context.pushNamed(Routes.adminProducts);
              },
            ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: Colors.black),
            tooltip: 'Mis transacciones',
            onPressed: () {
              context.pushNamed(Routes.transactions);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              context.goNamed(Routes.bag);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (products) {
            if (products.isEmpty) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AutoCarousel(),
                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        'Aún no hay productos disponibles',
                        style: TextStyle(color: Color(0xFF71727A)),
                      ),
                    ),
                  ],
                ),
              );
            }

            final reversed = products.reversed.toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AutoCarousel(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Perfect for you'),
                  const SizedBox(height: 18),
                  _buildProductRow(products),
                  const SizedBox(height: 32),
                  _buildSectionTitle('For this summer'),
                  const SizedBox(height: 18),
                  _buildProductRow(reversed),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF006FFD),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See more',
            style: TextStyle(color: Color(0xFF006FFD), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildProductRow(List products) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              context.goNamed(Routes.detail, extra: product);
            },
            child: ProductCard(
              name: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
            ),
          );
        },
      ),
    );
  }
}