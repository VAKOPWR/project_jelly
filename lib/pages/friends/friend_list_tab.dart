import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendListTab extends StatefulWidget {
  final void Function(int) onTabChange;

  const FriendListTab({
    Key? key,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _FriendListTabState createState() => _FriendListTabState();
}

class _FriendListTabState extends State<FriendListTab> {
  List<Friend> filteredFriends = [];
  late Timer _stateTimer;

  @override
  void initState() {
    super.initState();
    filteredFriends = Get.find<MapService>().friendsData.values.toList();
    _stateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        print('setting list page state');
        filteredFriends = Get.find<MapService>().friendsData.values.toList();
      });
    });
  }

  @override
  void dispose() {
    _stateTimer.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      filteredFriends = Get.find<MapService>()
          .friendsData
          .values
          .toList()
          .where((friend) =>
              friend.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
      onSearchChanged: _onSearchChanged,
      content: ListView.separated(
        itemCount: filteredFriends.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return _buildRow(filteredFriends[index]);
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            Get.find<MapService>().imageProviders[MarkerId(friend.id)],
        radius: 27,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      title: Text(
        friend.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool success = false;
              int? friendId = int.tryParse(friend.id);
              if (friendId != null) {
                success =
                    await Get.find<RequestService>().deleteFriend(friendId);
              } else {}
              if (success) {
                setState(() {
                  Get.find<MapService>().friendsData.removeWhere(
                      (MarkerId mid, Friend f) => mid.value == friend.id);
                  filteredFriends =
                      Get.find<MapService>().friendsData.values.toList();
                });
                Get.snackbar("Sorry to hear that",
                    "Your friend was deleted: ${friend.name}",
                    icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                        color: Colors.white, size: 35),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: false,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green[400],
                    margin: EdgeInsets.zero,
                    snackStyle: SnackStyle.GROUNDED);
              } else {
                Get.snackbar("Sorry to hear that",
                    "Failed to delete friend: ${friend.name}",
                    icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                        color: Colors.white, size: 35),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: false,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red[400],
                    margin: EdgeInsets.zero,
                    snackStyle: SnackStyle.GROUNDED);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
