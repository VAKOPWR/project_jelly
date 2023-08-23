import 'package:flutter/material.dart';
import 'package:project_jelly/widgets/navButtons.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  void getData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          centerTitle: true,
        ),
        body: const Stack(
          children: [NavButtons()],
        ));
  }
}
