import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';

import '../../service/map_service.dart';
import '../../widgets/search_bar.dart';

class FriendPendingTab extends StatefulWidget {
  final List<Friend> friends;
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
        backgroundImage:
            Get.find<MapService>().imageProviders[MarkerId(friend.id)],
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
