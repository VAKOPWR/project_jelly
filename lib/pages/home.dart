import 'package:flutter/material.dart';
import 'package:project_jelly/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(0), // Setting the height to 0 hides the app bar
        child: AppBar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primary, // Set the color of the app bar
          // You can also add other properties like title, actions, etc. here if needed
        ),
      ),
      body: Stack(
        children: [MapWidget()],
      ),
    );
  }
}
