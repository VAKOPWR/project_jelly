import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? AuthKey = GetStorage().read('AuthKey');
  // String? apiKey = null;

  @override
  Widget build(BuildContext context) {
    if (AuthKey == null && FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration.zero, () {
        Get.offNamed('/login');
      });
    }
    FirebaseAuth.instance.currentUser!.getIdToken().then((value) => prints(value));
    return Scaffold(
      body: Stack(
        children: [MapWidget()],
      ),
    );
  }
}

void prints(var s1) {
  String s = s1.toString();
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(s).forEach((match) => print(match.group(0)));
}
