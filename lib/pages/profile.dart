import 'package:flutter/material.dart';

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
          backgroundColor: Colors.green[600],
          title: const Text(
              "Profile",
              style: TextStyle(
              fontSize: 30,
                fontWeight: FontWeight.bold
          )
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // logout
              },
            ),
          ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            // Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, "/map");
          },
        ),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
  // final Function onPressedCallback;

  const CircularButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.green[600],
        radius: 50,
        child: IconButton(
          icon: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            // onPressedCallback();
          },
        ),
      ),
    );
  }
}
