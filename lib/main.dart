import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'services/fcm_service.dart';
import 'providers/sensor_alert_provider.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FcmService.init();

  runApp(const ProviderScope(child: WormGuardApp()));
}

class WormGuardApp extends ConsumerStatefulWidget {
  const WormGuardApp({super.key});

  @override
  ConsumerState<WormGuardApp> createState() => _WormGuardAppState();
}

class _WormGuardAppState extends ConsumerState<WormGuardApp> {
  @override
  Widget build(BuildContext context) {
    // Mengaktifkan listener otomatis sensor alert.
    ref.watch(sensorAlertProvider);

    return MaterialApp(
      title: 'WormGuard',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/login',
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}