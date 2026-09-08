import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import 'package:experience_app/firebase_options.dart';
import 'package:experience_app/core/environment/env.dart';
import 'package:experience_app/core/log_data_source.dart';
import 'package:experience_app/core/navigation/router.dart';

// ============================================================
// FIREBASE BACKGROUND HANDLER
// ============================================================

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    Env.environment = Environment.development;
  } catch (e) {
    debugPrint('Environment already set: $e');
  }

  await Env.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final data = message.data;

  debugPrint('========================================');
  debugPrint('Background message received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: $data');
  debugPrint('sale_id: ${data['sale_id']}');
  debugPrint('========================================');

  final logDataSource = LogDataSource();

  await logDataSource.logEvent('background_message', {
    ...data,
    'title': message.notification?.title ?? '',
  });
}

// ============================================================
// NOTIFICATIONS SERVICE
// ============================================================

class NotificationsService {
  NotificationsService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin(),
       _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseMessaging _firebaseMessaging;

  final FlutterLocalNotificationsPlugin _localNotifications;

  final FirebaseFirestore _firestore;

  final FirebaseAuth _firebaseAuth;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'experience_app_notifications',
    'Notificaciones de Experience App',
    description: 'Notificaciones de Experience App',
    importance: Importance.high,
    enableVibration: true,
    showBadge: true,
  );

  RemoteMessage? _initialMessage;

  String? _pendingSaleId;

  bool _initialized = false;

  bool _initialMessageProcessed = false;

  // ============================================================
  // INIT
  // ============================================================

  Future<void> init() async {
    if (_initialized) {
      debugPrint('NotificationsService ya estaba inicializado.');
      return;
    }

    _initialized = true;

    debugPrint('========================================');
    debugPrint('Inicializando NotificationsService');
    debugPrint('========================================');

    // Background handler
    _initBackgroundHandler();

    // Permisos
    await _requestPermissions();

    // Local notifications
    await _initLocalNotifications();

    // FCM
    await _initRemoteNotifications();

    // Cuando la app está en segundo plano y el usuario
    // presiona una notificación.
    _initMessageOpenedApp();

    // Registrar token del usuario actual.
    await _registerCurrentUserToken();

    // Escuchar login/logout.
    _listenAuthChanges();

    // Procesar notificación que abrió la aplicación
    // estando completamente cerrada.
    await _processInitialMessage();

    debugPrint('NotificationsService inicializado correctamente.');
  }

  // ============================================================
  // INITIAL MESSAGE
  // ============================================================

  Future<void> _processInitialMessage() async {
    if (_initialMessageProcessed) {
      return;
    }

    _initialMessageProcessed = true;

    _initialMessage = await _firebaseMessaging.getInitialMessage();

    if (_initialMessage == null) {
      debugPrint('La aplicación no fue abierta desde una notificación.');

      return;
    }

    debugPrint('========================================');
    debugPrint('Aplicación abierta desde una notificación');
    debugPrint('Title: ${_initialMessage!.notification?.title}');
    debugPrint('Body: ${_initialMessage!.notification?.body}');
    debugPrint('Data: ${_initialMessage!.data}');
    debugPrint('sale_id: ${_initialMessage!.data['sale_id']}');
    debugPrint('========================================');

    await _handleNotificationInteraction(_initialMessage!);
  }

  // ============================================================
  // PERMISSIONS
  // ============================================================

  Future<void> _requestPermissions() async {
    final actualSettings = await _firebaseMessaging.getNotificationSettings();

    debugPrint(
      'Permisos actuales de notificaciones: '
      '${actualSettings.authorizationStatus}',
    );

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      'Estado de permisos de notificaciones: '
      '${settings.authorizationStatus}',
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // ============================================================
  // FCM
  // ============================================================

  Future<void> _initRemoteNotifications() async {
    final token = await _firebaseMessaging.getToken();

    debugPrint('FCM Token: $token');

    if (token != null) {
      await _saveFcmToken(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM Token actualizado: $newToken');

      await _saveFcmToken(newToken);
    });

    FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);
  }

  // ============================================================
  // AUTH
  // ============================================================

  void _listenAuthChanges() {
    _firebaseAuth.authStateChanges().listen((user) async {
      if (user == null) {
        debugPrint('No hay usuario autenticado.');

        return;
      }

      debugPrint('Usuario autenticado: ${user.uid}');

      await _registerCurrentUserToken();

      // Si el usuario abrió la aplicación
      // desde una notificación y todavía
      // no estaba autenticado.
      if (_pendingSaleId != null) {
        final saleId = _pendingSaleId!;

        _pendingSaleId = null;

        debugPrint(
          'Procesando venta pendiente después del login: '
          '$saleId',
        );

        await _navigateToSale(saleId);
      }
    });
  }

  // ============================================================
  // FCM TOKEN
  // ============================================================

  Future<void> _registerCurrentUserToken() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      debugPrint(
        'No hay usuario autenticado. '
        'El token se registrará cuando inicie sesión.',
      );

      return;
    }

    try {
      final token = await _firebaseMessaging.getToken();

      if (token == null) {
        debugPrint('Firebase Messaging no devolvió un token.');

        return;
      }

      await _saveFcmToken(token);
    } catch (e) {
      debugPrint('Error obteniendo el FCM token: $e');
    }
  }

  Future<void> _saveFcmToken(String token) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      debugPrint(
        'No hay usuario autenticado. '
        'No se guardará el FCM token.',
      );

      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'fcm_tokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));

      debugPrint('FCM token guardado correctamente.');

      debugPrint('Usuario: ${user.uid}');
    } catch (e) {
      debugPrint('Error guardando FCM token: $e');
    }
  }

  // ============================================================
  // LOCAL NOTIFICATIONS
  // ============================================================

  Future<void> _initLocalNotifications() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        debugPrint('========================================');
        debugPrint('Local notification tapped');
        debugPrint('Payload: ${response.payload}');
        debugPrint('========================================');

        if (response.payload == null || response.payload!.isEmpty) {
          return;
        }

        try {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;

          final saleId = data['sale_id']?.toString();

          if (saleId == null || saleId.isEmpty) {
            debugPrint('La notificación local no contiene sale_id.');

            return;
          }

          await _handleSaleId(saleId);
        } catch (e) {
          debugPrint('Error procesando payload local: $e');
        }
      },
    );
  }

  // ============================================================
  // FOREGROUND
  // ============================================================

  Future<void> _foregroundMessageHandler(RemoteMessage message) async {
    debugPrint('========================================');
    debugPrint('Foreground message received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');
    debugPrint('sale_id: ${message.data['sale_id']}');
    debugPrint('========================================');

    // Cuando la aplicación está abierta,
    // mostramos una local notification.
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'experience_app_notifications',
      'Notificaciones de Experience App',
      channelDescription: 'Notificaciones de la aplicación Experience App',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Guardamos todo el data.
    //
    // Python enviará:
    //
    // {
    //   "sale_id": "...",
    //   ...
    // }
    //
    // Al tocar la notificación podremos recuperar
    // el sale_id.
    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(2147483647),

      title:
          message.notification?.title ??
          message.data['title']?.toString() ??
          'Experience App',

      body:
          message.notification?.body ??
          message.data['body']?.toString() ??
          'Has recibido una nueva notificación',

      notificationDetails: notificationDetails,

      payload: payload,
    );
  }

  // ============================================================
  // BACKGROUND HANDLER
  // ============================================================

  void _initBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  // ============================================================
  // APP EN SEGUNDO PLANO
  // ============================================================

  void _initMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      debugPrint('========================================');
      debugPrint('Notification opened from background');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      debugPrint('sale_id: ${message.data['sale_id']}');
      debugPrint('========================================');

      await _handleNotificationInteraction(message);
    });
  }

  // ============================================================
  // PROCESAR INTERACCIÓN
  // ============================================================

  Future<void> _handleNotificationInteraction(RemoteMessage message) async {
    final saleId = message.data['sale_id']?.toString();

    if (saleId == null || saleId.isEmpty) {
      debugPrint('La notificación no contiene sale_id.');

      return;
    }

    await _handleSaleId(saleId);
  }

  Future<void> _handleSaleId(String saleId) async {
    debugPrint('sale_id recibido: $saleId');

    final user = _firebaseAuth.currentUser;

    // ----------------------------------------------------------
    // USUARIO YA AUTENTICADO
    // ----------------------------------------------------------

    if (user != null) {
      debugPrint(
        'Usuario autenticado. '
        'Intentando abrir la venta.',
      );

      await _navigateToSale(saleId);

      return;
    }

    // ----------------------------------------------------------
    // USUARIO NO AUTENTICADO
    // ----------------------------------------------------------

    _pendingSaleId = saleId;

    debugPrint(
      'Usuario no autenticado. '
      'Venta guardada como pendiente: $saleId',
    );
  }

  // ============================================================
  // NAVEGAR A TRANSACTIONS
  // ============================================================

  Future<void> _navigateToSale(String saleId) async {
    debugPrint('Intentando navegar a venta: $saleId');

    // Esperamos hasta que el Navigator exista.
    for (int attempt = 0; attempt < 20; attempt++) {
      final context = rootNavigatorKey.currentContext;

      if (context != null) {
        try {
          debugPrint(
            'Navigator disponible. '
            'Navegando a Transactions.',
          );

          context.goNamed(
            Routes.transactions,
            queryParameters: {'saleId': saleId},
          );

          debugPrint('Navegación realizada correctamente.');

          _pendingSaleId = null;

          return;
        } catch (e) {
          debugPrint('Error navegando a la venta: $e');
        }
      }

      // Esperar un frame antes de volver a intentar.
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    // Si después de los intentos no se pudo navegar,
    // conservamos la venta.
    _pendingSaleId = saleId;

    debugPrint(
      'No fue posible navegar todavía. '
      'Venta guardada como pendiente: $saleId',
    );
  }

  // ============================================================
  // INITIAL MESSAGE PÚBLICO
  // ============================================================

  Future<RemoteMessage?> getInitialMessage() async {
    if (_initialMessage == null) {
      _initialMessage = await _firebaseMessaging.getInitialMessage();
    }

    return _initialMessage;
  }
}
