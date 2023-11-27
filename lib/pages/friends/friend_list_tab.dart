import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendListTab extends StatefulWidget {
  final List<BasicUser> friends;
  final void Function(int) onTabChange;

  const FriendListTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _FriendListTabState createState() => _FriendListTabState();
}

class _FriendListTabState extends State<FriendListTab> {
  List<BasicUser> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = widget.friends;
  }

  void _onSearchChanged(String value) {
    setState(() {
      filteredFriends = widget.friends
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
                success = await Get.find<RequestService>().deleteFriend(friendId);
              } else {
              }

              if (success) {
                setState(() {
                  filteredFriends.removeWhere((BasicUser f) => f.id == friend.id);
                });
                Get.snackbar("Sorry to hear that",
                    "Your friend was deleted: ${friend.name}",
                    icon: Icon(Icons.sentiment_very_dissatisfied_outlined ,
                        color: Colors.white, size: 35),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: false,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green[400],
                    margin: EdgeInsets.zero,
                    snackStyle: SnackStyle.GROUNDED
                );
              } else {
                Get.snackbar("Sorry to hear that",
                    "Failed to delete friend: ${friend.name}",
                    icon: Icon(Icons.sentiment_very_dissatisfied_outlined ,
                        color: Colors.white, size: 35),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: false,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red[400],
                    margin: EdgeInsets.zero,
                    snackStyle: SnackStyle.GROUNDED
                );
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
