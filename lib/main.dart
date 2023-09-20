import 'package:flutter/material.dart';
import 'package:project_jelly/pages/friends.dart';
import 'package:project_jelly/pages/ghostModeSettings/ghostModeScreen.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/pages/login.dart';
import 'package:project_jelly/pages/messages.dart';
import 'package:project_jelly/pages/profile.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/ghostMode',
    routes: {
      '/loading': (context) => const Loading(),
      '/login': (context) => const Login(),
      '/map': (context) => const Home(),
      '/friends': (context) => const FriendsPage(),
      '/messages': (context) => const MessagesPage(),
      '/profile': (context) => const ProfilePage(),
      '/ghostMode' : (context) => const GhostMode()
    },
  ));
}
