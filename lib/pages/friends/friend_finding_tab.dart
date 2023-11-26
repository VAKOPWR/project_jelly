import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendFindingTab extends StatefulWidget {
  final void Function(int) onTabChange;
  final VoidCallback? onShakeButtonPressed;

  const FriendFindingTab({
    Key? key,
    required this.onTabChange,
    this.onShakeButtonPressed,
  }) : super(key: key);

  @override
  _FriendFindingTabState createState() => _FriendFindingTabState();
}

class _FriendFindingTabState extends State<FriendFindingTab> {
  List<BasicUser> filteredFriends = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (value.isEmpty) {
        setState(() {
          filteredFriends = [];
        });
      } else {
        List<BasicUser> results =
            await Get.find<RequestService>().searchFriends(value);
        setState(() {
          filteredFriends = results;
          print(filteredFriends);
          log(filteredFriends.toString());
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

  Widget _buildRow(BasicUser basicUser) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(basicUser.avatar!),
        radius: 29,
      ),
      title: Text(
        basicUser.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: IconButton(
        icon: Icon(Icons.person_add_alt_1),
        onPressed: () async {
          bool success =
              await Get.find<RequestService>().sendFriendRequest(basicUser.id);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Friend request sent to ${basicUser.name}'),
              duration: Duration(seconds: 2),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to send friend request to ${basicUser.name}'),
              duration: Duration(seconds: 2),
            ));
          }
        },
      ),
      onTap: () {},
    );
  }
}
