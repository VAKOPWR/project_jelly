import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/service/map_service.dart';

class ShakeItScreen extends StatelessWidget {
  ShakeItScreen({Key? key}) : super(key: key);

//TODO :REMOVE MOCK
  List<Friend> _generateFakeShakingFriends() {
    return List<Friend>.generate(
        3,
        (int index) => Friend(
            id: (index + 1).toString(),
            name: 'Friend $index',
            // avatar: 'assets/andrii.jpeg',
            location: LatLng(37.4219999, -122.0840575),
            batteryPercentage: index,
            movementSpeed: index.toDouble(),
            isOnline: true,
            offlineStatus: ''));
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
        elevation: 0,
        titleSpacing: 16.0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  margin: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
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
                            return _buildFriendRow(context, friends[index]);
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
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRow(BuildContext context, Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 25,
        backgroundImage:
            Get.find<MapService>().imageProviders[MarkerId(friend.id)],
      ),
      title: Text(
        friend.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      onTap: () {},
    );
  }
}
