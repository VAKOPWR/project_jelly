// ignore: unused_import
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/pages/auth/register_form.dart';
// import 'package:project_jelly/pages/Auth/register_form_friends.dart';
import 'package:project_jelly/pages/auth/reset_password.dart';
import 'package:project_jelly/pages/auth/login.dart';
import 'package:project_jelly/pages/profile/profile.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/helper/splash_screen.dart';
import 'package:project_jelly/service/global_services.dart';
import 'package:project_jelly/theme/theme_constants.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  await GlobalServices.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProjectJelly());
}

class ProjectJelly extends StatelessWidget {
  const ProjectJelly({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/splash',
        theme: lightTheme,
        darkTheme: darkTheme,
        getPages: [
          GetPage(
              name: '/login',
              page: () => const LogInPage(),
              transition: Transition.circularReveal,
              transitionDuration: const Duration(seconds: 2)),
          GetPage(name: '/register', page: () => const RegisterPage()),
          GetPage(name: '/forgotPass', page: () => ForgotPasswordPage()),
          GetPage(
              name: '/profile',
              page: () => const ProfilePage(),
              transition: Transition.rightToLeft),
          GetPage(
              name: '/splash',
              page: () => SplashScreen(),
              transition: Transition.circularReveal,
              transitionDuration: const Duration(seconds: 2)),
        ]);
  }
}
