import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/service/visibility_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class FriendListTab extends StatefulWidget {
  final Function(LatLng) moveMapToPosition;

  const FriendListTab({Key? key, required this.moveMapToPosition})
      : super(key: key);

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

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
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
        radius: 28,
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Image(
          image: Get.find<MapService>().imageProviders[MarkerId(friend.id)] ??
              Get.find<MapService>().defaultImageProvider!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        friend.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.location_searching_rounded,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            ),
            onPressed: () {
              if (Get.find<MapService>()
                          .friendsData[MarkerId(friend.id)]!
                          .location
                          .latitude <
                      0 &&
                  Get.find<MapService>()
                          .friendsData[MarkerId(friend.id)]!
                          .location
                          .longitude <
                      0) {
                Get.snackbar("Sorry to hear that",
                    "Friend's location is unavailable: ${friend.name}",
                    icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                        color: Colors.white, size: 35),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: false,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red[400],
                    margin: EdgeInsets.zero,
                    snackStyle: SnackStyle.GROUNDED);
              } else {
                Get.find<VisibilityService>().isInfoSheetVisible = true;
                Get.find<VisibilityService>().highlightedMarker =
                    MarkerId(friend.id);
                Get.find<VisibilityService>().highlightedMarkerType = null;
                Get.back();
                widget.moveMapToPosition(Get.find<MapService>()
                    .friendsData[MarkerId(friend.id)]!
                    .location);
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            ),
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
        ],
      ),
      onTap: () {},
    );
  }
}
