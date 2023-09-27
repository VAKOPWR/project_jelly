import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavButtons extends StatelessWidget {
  const NavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "messagesBtn",
              onPressed: () {
                Get.toNamed('/messages');
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Icon(
                Icons.message_rounded,
                size: 40.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Icon(Icons.group_add_rounded,
                  size: 40.0, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              heroTag: "profileBtn",
              onPressed: () {
                Get.toNamed('/profile');
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Icon(Icons.person,
                  size: 40.0, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
