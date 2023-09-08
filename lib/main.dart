import 'package:flutter/material.dart';
import 'package:project_jelly/pages/Auth/register_form.dart';
import 'package:project_jelly/pages/Auth/reset_password.dart';
import 'package:project_jelly/pages/friends.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/pages/Auth/login.dart';
import 'package:project_jelly/pages/messages.dart';
import 'package:project_jelly/pages/profile.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(initialRoute: '/login', getPages: [
    GetPage(name: '/loading', page: () => const Loading()),
    GetPage(
        name: '/login',
        page: () => const LogInPage(),
        transition: Transition.circularReveal),
    GetPage(name: '/register', page: () => const RegisterPage()),
    GetPage(name: '/forgotPass', page: () => ForgotPasswordPage()),
    GetPage(
        name: '/map',
        page: () => const HomePage(),
        transition: Transition.circularReveal,
        transitionDuration: const Duration(seconds: 2)),
    GetPage(
        name: '/friends',
        page: () => const FriendsPage(),
        transition: Transition.downToUp),
    GetPage(
        name: '/messages',
        page: () => const MessagesPage(),
        transition: Transition.leftToRight),
    GetPage(
        name: '/profile',
        page: () => const ProfilePage(),
        transition: Transition.rightToLeft),
  ]
      //
      // {
      //   '/loading': (context) => const Loading(),
      //   '/login': (context) => const Login(),
      //   '/map': (context) => const Home(),
      //   '/friends': (context) => const FriendsPage(),
      //   '/messages': (context) => const MessagesPage(),
      //   '/profile': (context) => const ProfilePage(),
      //   '/forgotPass': (context) => ForgotPasswordPage(),
      //   '/signup': (context) => const Register()
      // },
      ));
}
