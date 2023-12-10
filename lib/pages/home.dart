import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/auth/login.dart';
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
      if (Platform.isIOS) {
        return Scaffold(
          body: Stack(
            children: [MapWidget()],
          ),
        );
      } else {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          body: Stack(
            children: [MapWidget()],
          ),
        );
      }
    }
  }
}
