// ignore: unused_import
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/pages/auth/register_form.dart';
import 'package:project_jelly/pages/auth/register_form_avatar.dart';
import 'package:project_jelly/pages/auth/reset_password.dart';
import 'package:project_jelly/pages/friends/friends.dart';
import 'package:project_jelly/pages/ghost_mode/ghost_mode_screen.dart';
import 'package:project_jelly/pages/helper/shake_it.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/auth/login.dart';
import 'package:project_jelly/pages/messages.dart';
import 'package:project_jelly/pages/profile/profile.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/helper/splash_screen.dart';
import 'package:project_jelly/service/global_services.dart';
import 'package:project_jelly/service/internet_service.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/style_service.dart';
import 'package:project_jelly/themes/theme_constants.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  await GlobalServices.init();
  await Get.find<StyleService>().loadMapStyles();
  await Get.find<MapService>().prepareService();
  await InternetCheckerBanner().initialize(title: "Whoops");
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
          GetPage(
              name: '/register_avatar',
              page: () => const AvatarSelectionPage()),
          GetPage(name: '/forgotPass', page: () => ForgotPasswordPage()),
          GetPage(
              name: '/home',
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
          GetPage(
              name: '/splash',
              page: () => SplashScreen(),
              transition: Transition.circularReveal,
              transitionDuration: const Duration(seconds: 2)),
          GetPage(
            name: '/ghost_mode',
            page: () => GhostMode(),
            transition: Transition.zoom,
          ),
          GetPage(
            name: '/shake',
            page: () => ShakeItScreen(),
            transition: Transition.rightToLeft,
          ),
        ]);
  }
}
