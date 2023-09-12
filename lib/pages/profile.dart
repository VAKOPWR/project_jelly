import 'package:flutter/material.dart';
import 'package:project_jelly/logic/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
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
                apiLogOut('1122');
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/profile_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nickname text
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Johnny Joestar",
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
              "Лорем ипсум или как там",
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
              CircularButton(icon: Icons.edit),
              CircularButton(icon: Icons.settings),
              CircularButton(icon: Icons.remove_red_eye_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;

  const CircularButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Adjust the width of the circular button as needed
      height: 80, // Adjust the height of the circular button as needed
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context)
            .colorScheme
            .primary, // Adjust the button's color as needed
      ),
      child: Center(
        // Center the icon within the circular button
        child: Icon(
          icon,
          size: 40, // Adjust the icon size as needed
          color: Theme.of(context)
              .colorScheme
              .onPrimary, // Adjust the icon color as needed
        ),
      ),
    );
  }
}
