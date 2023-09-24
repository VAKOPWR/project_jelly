import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/pages/Auth/login.dart';
import 'package:project_jelly/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? apiKey = GetStorage().read('apiKey');

  @override
  Widget build(BuildContext context) {
    return apiKey == null
        ? LogInPage()
        : Scaffold(
            body: Stack(children: [MapWidget()]),
          );
  }
}
