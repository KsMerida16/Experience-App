import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AutoCarousel extends StatefulWidget {
  const AutoCarousel({super.key});

  @override
  State<AutoCarousel> createState() => _AutoCarouselState();
}

class _AutoCarouselState extends State<AutoCarousel> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (_) {
      if (!controller.hasClients) return;
      currentPage = (currentPage + 1) % 3;
      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: controller,
        itemCount: 3,
        itemBuilder: (_, __) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag,
                size: 60,
                color: Color(0xFF006FFD),
              ),
            ),
          );
        },
      ),
    );
  }
}
