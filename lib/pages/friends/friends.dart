import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/pages/shake_it.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';

import 'friend_finding_tab.dart';
import 'friend_list_tab.dart';
import 'friend_pending_tab.dart';

const int _numberOfTabs = 3;
String tutorialText = "You can add someone to your friend list if both of you "
    "are standing close and shaking your phone at the same time!";
String tutorialTitle = "SHAKE IT TUTORIAL";

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  List<BasicUser> pendingFriends = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            _fetchPendingFriends();
            break;
          default:
        }
      }
    });
    _fetchPendingFriends();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange(int newIndex) {
    setState(() {
      _tabController.index = newIndex;
    });
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
            FriendListTab(
              friends: Get.find<MapService>().friendsData.values.toList(),
              onTabChange: _handleTabChange,
            ),
            FriendFindingTab(
              onTabChange: _handleTabChange,
              onShakeButtonPressed: _handleShakeButtonPressed,
            ),
            FriendPendingTab(
              friends: pendingFriends,
              onTabChange: _handleTabChange,
              onAccept: _acceptFriendRequest,
              onDecline: _declineFriendRequest,
            ),
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
      const Tab(text: "List"),
      const Tab(text: "Find"),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Pending"),
            Container(
              margin: const EdgeInsets.only(left: 4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                pendingFriends.length.toString(),
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

  Future<void> _fetchPendingFriends() async {
    List<BasicUser> _pendingFriends = await Get.find<RequestService>()
        .getFriendsBasedOnEndpoint('/friend/pending');

    setState(() {
      pendingFriends = _pendingFriends;
    });
  }

  Future<void> _acceptFriendRequest(String friendId) async {
    bool success =
        await Get.find<RequestService>().acceptFriendRequest(friendId);
    if (success) {
      setState(() {
        BasicUser? acceptedFriend = pendingFriends.firstWhereOrNull(
          (friend) => friend.id == friendId,
        );

        pendingFriends.removeWhere((friend) => friend.id == friendId);
        print(pendingFriends);

        if (acceptedFriend != null) {
          Get.snackbar("Congratulations!",
              "You decided to become a friends with a ${acceptedFriend.name}",
              icon: Icon(Icons.add_reaction, color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        }
        _fetchPendingFriends();
      });
    } else {}
  }

  Future<void> _declineFriendRequest(String friendId) async {
    bool success =
        await Get.find<RequestService>().declineFriendRequest(friendId);
    if (success) {
      setState(() {
        BasicUser? declinedFriend = pendingFriends.firstWhereOrNull(
          (friend) => friend.id == friendId,
        );
        pendingFriends.removeWhere((friend) => friend.id == friendId);
        if (declinedFriend != null) {
          Get.snackbar("Ooops!",
              "You decided to decline friendship with a ${declinedFriend.name}",
              icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        }
        _fetchPendingFriends();
      });
    } else {}
  }
}
