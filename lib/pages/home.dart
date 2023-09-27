import 'dart:async';
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
  String? apiKey = GetStorage().read('apiKey');
  // String? apiKey = null;

  @override
  Widget build(BuildContext context) {
    if (apiKey == null) {
      Future.delayed(Duration.zero, () {
        Get.offNamed('/login');
      });
    }

    return Scaffold(
      body: Stack(
        children: [MapWidget()],
      ),
    );
  }
}
