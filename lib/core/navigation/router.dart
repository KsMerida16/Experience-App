import 'package:experience_app/feature/onboarding/presentation/interests_view.dart';
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
  ],
);

abstract class Routes {
  static const String onboarding = 'onboarding';
  static const String interests = 'interest';
}