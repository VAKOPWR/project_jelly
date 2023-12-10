import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
  }

  Future<String> getFCMToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    print("fcmToken: ${fcmToken}");
    return fcmToken!;
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Get.toNamed('/map');
  }
}

