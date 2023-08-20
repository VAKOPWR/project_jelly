import 'package:flutter/material.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/pages/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/loading': (context) => const Loading(),
      '/login': (context) => const Login(),
      '/home': (context) => const Home()
    },
  ));
}
