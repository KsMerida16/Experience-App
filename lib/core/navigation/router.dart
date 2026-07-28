import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:experience_app/feature/auth/presentation/views/login_view.dart';
import 'package:experience_app/feature/auth/presentation/views/register_view.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/bag_view.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/home_view.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/product_detail_view.dart';
import 'package:experience_app/feature/admin/presentation/views/admin_product_list_view.dart';
import 'package:experience_app/feature/admin/presentation/views/admin_product_form_view.dart';
import 'package:experience_app/feature/onboarding/presentation/interests_view.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';
import 'package:experience_app/feature/payment/presentation/views/add_card_view.dart';
import 'package:experience_app/feature/payment/presentation/views/checkout_view.dart';
import 'package:experience_app/feature/payment/presentation/views/transactions_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:experience_app/feature/onboarding/presentation/onboarding_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref),
    redirect: (context, state) {
      // Mientras se resuelve el estado inicial (¿hay sesión guardada?), no redirigimos.
      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;
      final isAdmin = user?.isAdmin ?? false;

      final goingToAuth =
          state.matchedLocation == '/' ||
          state.matchedLocation == Routes.registerPath;

      if (!isLoggedIn && !goingToAuth) return '/';
      if (isLoggedIn && goingToAuth) return '/home';

      if (state.matchedLocation.startsWith('/admin') && !isAdmin) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        name: Routes.login,
        path: '/',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: Routes.register,
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        name: Routes.interests,
        path: '/interests',
        builder: (context, state) => const InterestsView(),
      ),
      GoRoute(
        name: Routes.home,
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: Routes.detail,
        path: '/detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailView(product: product);
        },
      ),
      GoRoute(
        name: Routes.bag,
        path: '/bag',
        builder: (context, state) => const BagView(),
      ),
      GoRoute(
        name: Routes.checkout,
        path: '/checkout',
        builder: (context, state) => const CheckoutView(),
      ),
      // ---- Rutas de administrador ----
      GoRoute(
        name: Routes.adminProducts,
        path: '/admin/products',
        builder: (context, state) => const AdminProductListView(),
      ),
      GoRoute(
        name: Routes.adminProductForm,
        path: '/admin/products/form',
        builder: (context, state) {
          final product = state.extra as Product?;
          return AdminProductFormView(product: product);
        },
      ),
      GoRoute(
        name: Routes.transactions,
        path: '/transactions',
        builder: (context, state) => const TransactionsView(),
      ),
      GoRoute(
        name: Routes.addCard,
        path: '/addcard',
        builder: (context, state) {
          final card = state.extra as CreditCardEntity?;
          return AddCardView(card: card);
        },
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

abstract class Routes {
  static const login = "login";
  static const register = "register";
  static const String registerPath = '/register';
  static const String onboarding = 'onboarding';
  static const String interests = 'interest';
  static const String home = 'home';
  static const String detail = 'detail';
  static const String bag = 'bag';
  static const String checkout = 'checkout';
  static const String addCard = 'addCard';
  static const String adminProducts = 'adminProducts';
  static const String adminProductForm = 'adminProductForm';
  static const String transactions = 'transactions';
}
