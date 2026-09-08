import 'dart:async';

import 'package:experience_app/app_colors.dart';
import 'package:experience_app/core/environment/env.dart';
import 'package:experience_app/core/local_storage.dart';
import 'package:experience_app/core/notifications_service.dart';
import 'package:experience_app/core/utils/dependencies.dart';
import 'package:experience_app/core/navigation/router.dart';
import 'package:experience_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

final notificationsService = NotificationsService();

void runProject() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();

  await LocalStorage().init();

  await setupDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MainApp()));

  // Esperamos a que Flutter construya la interfaz
  // antes de inicializar el servicio de notificaciones.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(notificationsService.init());
  });
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Inter',
      ),

      title: Env.appName,

      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: router,
    );
  }
}
