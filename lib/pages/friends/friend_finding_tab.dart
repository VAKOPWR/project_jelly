import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_jelly/classes/friend.dart';

import '../../service/request_service.dart';
import '../../widgets/search_bar.dart';

class FriendFindingTab extends StatefulWidget {
  final List<Friend> friends;
  final void Function(int) onTabChange;
  final VoidCallback? onShakeButtonPressed;

  const FriendFindingTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
    this.onShakeButtonPressed,
  }) : super(key: key);

  @override
  _FriendFindingTabState createState() => _FriendFindingTabState();
}

class _FriendFindingTabState extends State<FriendFindingTab> {
  List<Friend> filteredFriends = [];

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
          return _buildRow(widget.friends[index]);
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(friend.avatar),
        radius: 29,
      ),
      title: Text(
        friend.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: IconButton(
        icon: Icon(Icons.person_add_alt_1),
        onPressed: () async {
          bool success =
              await Get.find<RequestService>().sendFriendRequest(friend.id);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Friend request sent to ${friend.name}'),
              duration: Duration(seconds: 2),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to send friend request to ${friend.name}'),
              duration: Duration(seconds: 2),
            ));
          }
        },
      ),
      onTap: () {},
    );
  }
}
