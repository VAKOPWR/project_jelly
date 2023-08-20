import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getData() {}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Map is here'),
    );
  }
}
