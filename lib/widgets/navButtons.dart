import 'package:flutter/material.dart';

class NavButtons extends StatelessWidget {
  const NavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30, // Adjust this value to control the vertical positioning
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Adjust button spacing
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "messagesBtn",
              onPressed: () {
                ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
                if (currentRoute?.settings?.name != '/messages') {
                  // Only navigate to the '/friends' page if not already on it
                  Navigator.pushReplacementNamed(context, '/messages');
                }
              },
              backgroundColor:
                  Colors.green[600], // Change the background color as desired
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: const Icon(Icons.message_rounded, size: 40.0),
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "friendsBtn",
              onPressed: () {
                ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
                if (currentRoute?.settings?.name != '/friends') {
                  // Only navigate to the '/friends' page if not already on it
                  Navigator.pushReplacementNamed(context, '/friends');
                }
              },
              backgroundColor:
                  Colors.green[600], // Change the background color as desired
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: const Icon(Icons.group_add_rounded, size: 40.0),
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "mapBtn",
              onPressed: () {
                ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
                if (currentRoute?.settings?.name != '/map') {
                  // Only navigate to the '/friends' page if not already on it
                  Navigator.pushReplacementNamed(context, '/map');
                }
              },
              backgroundColor:
                  Colors.green[600], // Change the background color as desired
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: const Icon(Icons.map_rounded, size: 40.0),
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "profileBtn",
              onPressed: () {
                ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
                if (currentRoute?.settings?.name != '/profile') {
                  // Only navigate to the '/friends' page if not already on it
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              },
              backgroundColor:
                  Colors.green[600], // Change the background color as desired
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: const Icon(Icons.person, size: 40.0),
            ),
          ),
        ],
      ),
    );
  }
}
