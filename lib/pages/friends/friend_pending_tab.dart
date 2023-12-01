import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendPendingTab extends StatefulWidget {
  const FriendPendingTab({
    Key? key,
  }) : super(key: key);

  @override
  _FriendPendingTabState createState() => _FriendPendingTabState();
}

class _FriendPendingTabState extends State<FriendPendingTab> {
  List<BasicUser> filteredFriends = [];
  // late Timer _stateTimer;

  @override
  void initState() {
    super.initState();
    filteredFriends = Get.find<MapService>().pendingFriends;
  }

  @override
  void dispose() {
    // _stateTimer.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      filteredFriends = Get.find<MapService>()
          .pendingFriends
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

  Widget _buildRow(BasicUser friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(friend.avatar!),
        radius: 29,
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
            icon: Icon(Icons.add),
            onPressed: () => _acceptFriendRequest(friend.id),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _declineFriendRequest(friend.id),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  Future<void> _acceptFriendRequest(String friendId) async {
    bool success =
        await Get.find<RequestService>().acceptFriendRequest(friendId);
    if (success) {
      setState(() {
        BasicUser? acceptedFriend =
            Get.find<MapService>().pendingFriends.firstWhereOrNull(
                  (friend) => friend.id == friendId,
                );

        Get.find<MapService>()
            .pendingFriends
            .removeWhere((friend) => friend.id == friendId);

        if (acceptedFriend != null) {
          Get.snackbar("Congratulations!",
              "You decided to become a friends with a ${acceptedFriend.name}",
              icon: Icon(Icons.add_reaction, color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        }
        Get.find<MapService>().fetchPendingFriends();
        filteredFriends = Get.find<MapService>().pendingFriends;
      });
    } else {}
  }

  Future<void> _declineFriendRequest(String friendId) async {
    bool success =
        await Get.find<RequestService>().declineFriendRequest(friendId);
    if (success) {
      setState(() {
        BasicUser? declinedFriend =
            Get.find<MapService>().pendingFriends.firstWhereOrNull(
                  (friend) => friend.id == friendId,
                );
        Get.find<MapService>()
            .pendingFriends
            .removeWhere((friend) => friend.id == friendId);
        if (declinedFriend != null) {
          Get.snackbar("Ooops!",
              "You decided to decline friendship with a ${declinedFriend.name}",
              icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        }
        Get.find<MapService>().fetchPendingFriends();
        filteredFriends = Get.find<MapService>().pendingFriends;
      });
    } else {}
  }
}
