import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/core/navigation/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ExperienceApp(),
    ),
  );
}

class ExperienceApp extends StatelessWidget {
  const ExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Experience App',
      routerConfig: router,
    );
  }
}
