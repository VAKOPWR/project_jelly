import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/pages/helper/shake_it.dart';
import 'package:project_jelly/service/map_service.dart';
import 'friends/friend_finding_tab.dart';
import 'friends/friend_list_tab.dart';
import 'friends/friend_pending_tab.dart';

const int _numberOfTabs = 3;
String tutorialText = "You can add someone to your friend list if both of you "
    "are standing close and shaking your phone at the same time!";
String tutorialTitle = "SHAKE IT TUTORIAL";

class FriendsPage extends StatefulWidget {
  final Function(LatLng) moveMapToPosition;
  const FriendsPage({super.key, required this.moveMapToPosition});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Timer _stateTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
        switch (_tabController.index) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            Get.find<MapService>().fetchPendingFriends();
            break;
          default:
        }
      }
    });
    _stateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {});
    });
    Get.find<MapService>().fetchPendingFriends();
  }

  @override
  void dispose() {
    _stateTimer.cancel();
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void _handleShakeButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tutorialTitle),
          content: Text(tutorialText),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.to(ShakeItScreen());
              },
              child: Text("Shake it"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _numberOfTabs,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: [
            FriendListTab(moveMapToPosition: widget.moveMapToPosition),
            FriendFindingTab(
              onShakeButtonPressed: _handleShakeButtonPressed,
            ),
            FriendPendingTab(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Friends"),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        tabs: _buildTabsWithBadges(),
      ),
    );
  }

  List<Widget> _buildTabsWithBadges() {
    return [
      Tab(
          child: Text(
        "List",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      )),
      Tab(
          child: Text("List",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary))),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Pending",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            Container(
              margin: const EdgeInsets.only(left: 4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                Get.find<MapService>().pendingFriends.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
