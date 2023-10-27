import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/pages/Auth/login.dart';
import 'package:project_jelly/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration.zero, () {
        Get.offNamed('/login');
      });
      return LogInPage();
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(0), // Setting the height to 0 hides the app bar
          child: AppBar(
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary, // Set the color of the app bar
          ),
        ),
        body: Stack(
          children: [MapWidget()],
        ),
      );
    }
  }
}
