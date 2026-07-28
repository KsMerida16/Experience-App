import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/core/navigation/router.dart';
import 'package:experience_app/feature/onboarding/widgets/custom_buttom.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFEAF2FF),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 60,
                    color: Color(0xFFB4DBFF),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Dot(active: true), Dot(), Dot()]),
                    const SizedBox(height: 24),
                    const Text(
                      'Create a prototype in jsut\n a few minutes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Enjoy these pre-made components and worry only about creating the best product ever.',
                      style: TextStyle(color: Color(0xFF71727A), fontSize: 12),
                    ),

                    const Spacer(),

                    CustomButtom(
                      text: 'Next',
                      onPressed: () {
                        context.goNamed(Routes.interests);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final bool active;

  const Dot({super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Color(0xFF006FFD) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
