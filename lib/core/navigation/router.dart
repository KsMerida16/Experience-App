import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/bag_view.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/home_view.dart';
import 'package:experience_app/feature/ecommerce/presentation/views/product_detail_view.dart';
import 'package:experience_app/feature/onboarding/presentation/interests_view.dart';
import 'package:experience_app/feature/payment/presentation/views/add_card_view.dart';
import 'package:experience_app/feature/payment/presentation/views/checkout_view.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/feature/onboarding/presentation/onboarding_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.onboarding,
      path: '/',
      builder: (context, state) => const OnboardingView(),
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
    GoRoute(
      name: Routes.addCard,
      path: '/addcard',
      builder: (context, state) => const AddCardView(),
    )
  ],
);

abstract class Routes {
  static const String onboarding = 'onboarding';
  static const String interests = 'interest';
  static const String home = 'home';
  static const String detail = 'detail';
  static const String bag = 'bag';
  static const String checkout = 'checkout';
  static const String addCard = 'addCard';
}
