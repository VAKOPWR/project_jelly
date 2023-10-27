import 'package:flutter/material.dart';

class ShakeItScreen extends StatelessWidget {
  const ShakeItScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shake IT",
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: Colors.green,
        elevation: 0,
        titleSpacing: 16.0,
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Icon(
            Icons.phone_android,
            size: 300.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}