import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                Get.toNamed('/messages');
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
                Get.toNamed('/friends');
              },
              backgroundColor:
                  Colors.green[600], // Change the background color as desired
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: const Icon(Icons.group_add_rounded, size: 40.0),
            ),
          ),
          // SizedBox(
          //   height: 64,
          //   width: 64,
          //   child: FloatingActionButton(
          //     heroTag: "mapBtn",
          //     onPressed: () {
          //       Get.offNamed('/map');
          //     },
          //     backgroundColor:
          //         Colors.green[600], // Change the background color as desired
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(16.0)),
          //     ),
          //     child: const Icon(Icons.map_rounded, size: 40.0),
          //   ),
          // ),
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "profileBtn",
              onPressed: () {
                Get.toNamed('/profile');
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
