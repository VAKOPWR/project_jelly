import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/friend.dart';

class ShakeItScreen extends StatelessWidget {
  ShakeItScreen({Key? key}) : super(key: key);

  List<Friend> _generateFakeShakingFriends() {
    return List<Friend>.generate(5, (int index) => Friend(
        id: 'id_$index',
        name: 'Friend $index',
        avatar: defaultFriendAvatar,
        location: LatLng(37.4219999, -122.0840575)
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = _generateFakeShakingFriends();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shake IT",
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: Colors.green,
        elevation: 0,
        titleSpacing: 16.0,
      ),
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  margin: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Also shaking near you",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: friends.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildFriendRow(friends[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Icon(
              Icons.phone_android,
              size: 160.0,
              color: Colors.white,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRow(Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(friend.avatar),
      ),
      title: Text(
        friend.name,
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
      },
    );
  }
}