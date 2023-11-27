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
            // setState(() {
            //   allFriends.removeWhere((Friend f) => f.id == friend.id);
            // });
            Get.snackbar("Congratulations!",
                "Your friend request sent to ${basicUser.name}",
                icon: Icon(Icons.sentiment_satisfied_alt_outlined,
                    color: Colors.white, size: 35),
                snackPosition: SnackPosition.TOP,
                isDismissible: false,
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green[400],
                margin: EdgeInsets.zero,
                snackStyle: SnackStyle.GROUNDED
            );
          } else {
            Get.snackbar("Ooops!",
                "Failed to send friend request to ${basicUser.name}",
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
      onTap: () {},
    );
  }
}
