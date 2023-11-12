import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/pages/Auth/register_form.dart';
import 'package:project_jelly/pages/Auth/register_form_avatar.dart';
import 'package:project_jelly/pages/Auth/register_form_friends.dart';
import 'package:project_jelly/pages/Auth/reset_password.dart';
import 'package:project_jelly/pages/friends.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/Auth/login.dart';
import 'package:project_jelly/pages/messages.dart';
import 'package:project_jelly/pages/profile.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/resource_usage.dart';
import 'package:project_jelly/service/global_services.dart';
import 'package:project_jelly/theme/theme_constants.dart';

void main() async {
  await GetStorage.init();
  await GlobalServices.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProjectJelly());
}

class ProjectJelly extends StatelessWidget {
  const ProjectJelly({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/metrics',
        theme: lightTheme,
        darkTheme: darkTheme,
        getPages: [
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
              name: '/metrics',
              page: () => const ResourceUsageScreen(),
              transition: Transition.rightToLeft),
        ]);
  }
}
