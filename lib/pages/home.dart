import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        body: Stack(
          children: [MapWidget()],
        ),
      );
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
