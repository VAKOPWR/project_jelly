import 'package:flutter/material.dart';
import 'package:project_jelly/pages/Auth/register_form.dart';
import 'package:project_jelly/pages/Auth/register_form_avatar.dart';
import 'package:project_jelly/pages/Auth/register_form_friends.dart';
import 'package:project_jelly/pages/Auth/reset_password.dart';
import 'package:project_jelly/pages/friends.dart';
import 'package:project_jelly/pages/home.dart';
// import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/pages/Auth/login.dart';
import 'package:project_jelly/pages/messages.dart';
import 'package:project_jelly/pages/profile.dart';
import 'package:get/get.dart';
import 'package:project_jelly/theme/theme_constants.dart';
import 'package:project_jelly/theme/theme_manager.dart';

ThemeManager _themeManager = ThemeManager();

void main() {
  runApp(GetMaterialApp(
      initialRoute: '/login',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      getPages: [
        GetPage(
            name: '/login',
            page: () => const LogInPage(),
            transition: Transition.circularReveal),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(
            name: '/register_avatar', page: () => const AvatarSelectionPage()),
        GetPage(name: '/register_friends', page: () => const AddFriendsPage()),
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
      ]));
}
