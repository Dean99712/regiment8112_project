
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final  _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('$token $settings');
  }
}