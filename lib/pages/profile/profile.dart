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
  TextEditingController _usernameController = TextEditingController();
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!),
                    fit: BoxFit.cover,
                  ),
                ),
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularButton(
                icon: Icons.edit,
                onPressed: _showUsernameEditDialog,
              ),
              CircularButton(
                  icon: Icons.settings, destinationPath: '/settings'),
              CircularButton(
                  icon: Icons.remove_red_eye_outlined,
                  destinationPath: '/ghost_mode'),
            ],
          ),
        ],
      ),
    );
  }

  void _showUsernameEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(36.0),
          child: AlertDialog(
            title: Text("Edit Username"),
            content: TextField(
              controller: _usernameController,
              maxLength: 10,
              decoration: InputDecoration(labelText: 'New Username'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement the logic to update the username
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final String? destinationPath;
  final VoidCallback? onPressed;

  CircularButton({
    required this.icon,
    this.destinationPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else if (destinationPath != null) {
          Navigator.pushNamed(context, destinationPath!);
        }
      },
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 42.0,
          ),
        ),
      ),
    );
  }
}
