import 'package:flutter/material.dart';

class WifiOffOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Icon(
          Icons.wifi_off,
          size: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
