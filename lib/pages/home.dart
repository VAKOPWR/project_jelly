import 'package:flutter/material.dart';
import 'package:project_jelly/widgets/map.dart';
import 'package:project_jelly/widgets/navButtons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MapWidget(),
        const NavButtons(),
      ]),
    );
  }
}
