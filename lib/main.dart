import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:regiment8112/services/push_notifications.dart';
import 'firebase_options.dart';
import 'login.dart';

Future _firebaseBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}'
        '${message.notification}');
    print('Message From Firebase');
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "מסייעת");
      if (kReleaseMode) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.playIntegrity,
          appleProvider: AppleProvider.appAttest,
        );
      }
      if (kDebugMode) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.debug,
          appleProvider: AppleProvider.debug,
        );
      }
      PushNotifications.init();
      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
      Intl.defaultLocale = 'he';
      initializeDateFormatting('he', null);
  runApp(const ProviderScope(child: Login()));
}
