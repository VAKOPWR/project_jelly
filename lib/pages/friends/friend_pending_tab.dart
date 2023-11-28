import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendPendingTab extends StatefulWidget {
  final List<BasicUser> friends;
  final void Function(int) onTabChange;
  final void Function(String) onAccept;
  final void Function(String) onDecline;

  const FriendPendingTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  _FriendPendingTabState createState() => _FriendPendingTabState();
}

class _FriendPendingTabState extends State<FriendPendingTab> {
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
            onPressed: () => widget.onAccept(friend.id),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => widget.onDecline(friend.id),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
