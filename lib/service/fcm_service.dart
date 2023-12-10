import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();

    initPushNotifications();
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
    Get.toNamed('/home');
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
