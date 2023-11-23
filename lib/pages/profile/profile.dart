import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/logic/auth.dart';
import 'package:project_jelly/pages/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var userName = FirebaseAuth.instance.currentUser!.displayName!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("Profile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authLogOut().then((value) => Get.offAll(() => const LogInPage(),
                    transition: Transition.rightToLeft));
              },
            ),
          ],
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 160,
                height: 160,
                margin: const EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nickname text
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              userName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Description text
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Lorem ipsum dolor sit amet",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularButton(icon: Icons.edit, destinationPath: ''),
              CircularButton(icon: Icons.settings, destinationPath: ''),
              CircularButton(
                  icon: Icons.remove_red_eye_outlined,
                  destinationPath: '/ghost_mode'),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final String destinationPath;

  CircularButton({required this.icon, required this.destinationPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, destinationPath);
      },
      child: Container(
        width: 80.0, // Adjust the size as needed
        height: 80.0, // Adjust the size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context)
              .colorScheme
              .primary, // Change the color as needed
        ),
        child: Center(
          child: Icon(icon, // Use the passed icon
              color: Theme.of(context).colorScheme.onPrimary,
              size: 42.0 // Change the icon color as needed
              ),
        ),
      ),
    );
  }
}
