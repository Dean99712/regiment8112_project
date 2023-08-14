import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Regiment8112',
    options: DefaultFirebaseOptions.currentPlatform,
  );
await FirebaseAppCheck.instance.activate(
  webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  androidProvider: AndroidProvider.playIntegrity,
  appleProvider: AppleProvider.appAttest,
);
  Intl.defaultLocale = 'he';
  initializeDateFormatting('he', null);
  runApp(const ProviderScope(child: Login()));
}

