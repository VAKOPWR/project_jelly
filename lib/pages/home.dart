import 'package:flutter/material.dart';
import 'package:project_jelly/widgets/map.dart';
import 'package:project_jelly/widgets/nav_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getData() {}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [
        MapWidget(),
        NavButtons(),
      ]),
    );
  }
}
