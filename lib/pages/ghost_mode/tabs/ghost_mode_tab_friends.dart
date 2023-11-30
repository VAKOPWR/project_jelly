import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/misc/stealth_choice.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class GhostModeTabFriends extends StatefulWidget {
  const GhostModeTabFriends({super.key});

  @override
  _GhostModeTabFriendsState createState() => _GhostModeTabFriendsState();
}

class _GhostModeTabFriendsState extends State<GhostModeTabFriends> {
  List<Friend> filteredFriends = [];
  Map<String, bool> ghostModeStatus = {};

  @override
  void initState() {
    super.initState();
    var friendsData = Get.find<MapService>().friendsData.values.toList();
    filteredFriends = friendsData;
    ghostModeStatus = {for (var friend in friendsData) friend.id: false};
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
      trailing: Checkbox(
        value: ghostModeStatus[friend.id] ?? false,
        onChanged: (bool? isChecked) async {
          if (isChecked == null) return;

          setState(() {
            ghostModeStatus[friend.id] = isChecked;
          });

          StealthChoice choice = isChecked
              ? StealthChoice.HIDE
              : StealthChoice.PRECISE;

          bool success = await Get.find<RequestService>()
              .updateStealthChoiceOnRelationshipLevel(friend.id, choice);

          if (!success) {
            setState(() {
              ghostModeStatus[friend.id] = !isChecked;
            });
            Get.snackbar("Update Failed",
                "Failed to update ghost mode status for ${friend.name}",
                icon: Icon(Icons.error_outline, color: Colors.white, size: 35),
                snackPosition: SnackPosition.TOP,
                isDismissible: true,
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red[400],
                margin: EdgeInsets.zero,
                snackStyle: SnackStyle.GROUNDED);
          }
        },
      ),
      onTap: () {
        // TODO: Get.to profile of friend
      },
    );
  }
}
