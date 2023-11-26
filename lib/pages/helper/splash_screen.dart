import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/service/request_service.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.find<RequestService>().setupInterceptor('');
      Future.delayed(Duration.zero, () {
        Get.offNamed('/home');
      });
    } else {
      Future.delayed(Duration.zero, () {
        Get.offNamed('/login');
      });
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
