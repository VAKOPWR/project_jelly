import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(Duration.zero, () {
        Get.offNamed('/profile');
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
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       SizedBox(
        //         width: 120,
        //         height: 120,
        //         child: Image.asset('assets/logo.png'),
        //       ), // App logo image path
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
