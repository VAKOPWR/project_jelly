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

  @override
  void initState() {
    super.initState();
    filteredFriends = Get.find<MapService>().friendsData.values.toList();
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredFriends = Get.find<MapService>().friendsData.values.toList();
      });
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SearchBarWidget(
          onSearchChanged: _onSearchChanged,
          content: ListView.separated(
            itemCount: filteredFriends.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return _buildRow(filteredFriends[index]);
            },
          ),
        ));
  }

  Widget _buildRow(Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Image(
          image: Get.find<MapService>().imageProviders[MarkerId(friend.id)] ??
              Get.find<MapService>().defaultImageProvider!,
          width: 56,
          height: 56,
          fit: BoxFit.cover, // Adjust the fit as needed
        ),
      ),
      title: Text(
        friend.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Checkbox(
        value: Get.find<MapService>().ghostedFriends[friend.id] ?? false,
        onChanged: (bool? isChecked) async {
          if (isChecked == null) return;

          StealthChoice choice =
              isChecked ? StealthChoice.HIDE : StealthChoice.PRECISE;

          bool success = await Get.find<RequestService>()
              .updateStealthChoiceOnRelationshipLevel(friend.id, choice);

          if (success) {
            setState(() {});
            Get.find<MapService>()
                .updateFriendGhostStatus(friend.id, isChecked);
          } else {}
        },
      ),
    );
  }
}
