import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_jelly/classes/friend.dart';

class FriendSpecificGhostMode extends StatefulWidget {
  final Friend person;

  const FriendSpecificGhostMode({Key? key, required this.person})
      : super(key: key);

  @override
  State<FriendSpecificGhostMode> createState() =>
      _FriendSpecificGhostModeState();
}

class _FriendSpecificGhostModeState extends State<FriendSpecificGhostMode> {
  int locationPrecisionOption = 0;
  int otherOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          backgroundColor: Colors.green[600],
          title: AutoSizeText(widget.person.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // logout
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          // Make the list scrollable
          child: Column(
            children: [
              Divider(
                color: Colors.black,
                height: 20.0,
              ),
              Text('Location precision visibility'),
              // Wrap the location precision options in a ListView
              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: locationPrecisionOption,
                        onChanged: (value) {
                          setState(() {
                            locationPrecisionOption = value!;
                          });
                        },
                      ),
                      Text('Precise'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: locationPrecisionOption,
                        onChanged: (value) {
                          setState(() {
                            locationPrecisionOption = value!;
                          });
                        },
                      ),
                      Text('City district'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: locationPrecisionOption,
                        onChanged: (value) {
                          setState(() {
                            locationPrecisionOption = value!;
                          });
                        },
                      ),
                      Text('City'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 4,
                        groupValue: locationPrecisionOption,
                        onChanged: (value) {
                          setState(() {
                            locationPrecisionOption = value!;
                          });
                        },
                      ),
                      Text('Hide my location'),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                height: 20.0,
              ),
              Text('Some other settings'),
              // Wrap the other options in a ListView
              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: otherOption,
                        onChanged: (value) {
                          setState(() {
                            otherOption = value!;
                          });
                        },
                      ),
                      Text('Option 1'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: otherOption,
                        onChanged: (value) {
                          setState(() {
                            otherOption = value!;
                          });
                        },
                      ),
                      Text('Option 2'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: otherOption,
                        onChanged: (value) {
                          setState(() {
                            otherOption = value!;
                          });
                        },
                      ),
                      Text('Option 3'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 4,
                        groupValue: otherOption,
                        onChanged: (value) {
                          setState(() {
                            otherOption = value!;
                          });
                        },
                      ),
                      Text('Option 4'),
                    ],
                  ),
                ],
              ),
              // Add some padding to the bottom
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            // Confirm button logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
          ),
          child: Text('Confirm'),
        ),
      ),
    );
  }
}
