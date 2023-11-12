import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/misc/enum.dart';
import 'package:project_jelly/pages/helper/shake_it.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

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
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<Friend> _listFriends = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _fetchFriendsList();
  }

  @override
  void dispose() {
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
              friends: _listFriends,
              onTabChange: _handleTabChange,
              trailingActions: tabTrailingActions[TabType.list]!,
              buildRowForFriendList: _buildRow,
            ),
            FriendFindingTab(
              friends: _listFriends,
              onTabChange: _handleTabChange,
              onShakeButtonPressed: _handleShakeButtonPressed,
              trailingActions: tabTrailingActions[TabType.find]!,
              buildRowForFriendFinding: _buildRow,
            ),
            FriendPendingTab(
              friends: _listFriends,
              onTabChange: _handleTabChange,
              trailingActions: tabTrailingActions[TabType.pending]!,
              buildRowForFriendPending: _buildRow,
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
                _listFriends.length.toString(),
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

  Widget _buildRow(Friend friend, List<Widget> trailingActions) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            Get.find<LocationService>().imageProviders[MarkerId(friend.id)],
        radius: 29,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      title: Text(
        friend.name,
        style: _biggerFont,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: trailingActions,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    setState(() {
      _listFriends = Get.find<LocationService>().friendsData.values.toList();
    });
  }
}

class FriendListTab extends StatefulWidget {
  final List<Friend> friends;
  final void Function(int) onTabChange;
  final List<Widget> trailingActions;
  final Widget Function(Friend, List<Widget>) buildRowForFriendList;

  const FriendListTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
    required this.buildRowForFriendList,
    required this.trailingActions,
  }) : super(key: key);

  @override
  _FriendListTabState createState() => _FriendListTabState();
}

class _FriendListTabState extends State<FriendListTab> {
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
          return widget.buildRowForFriendList(
              filteredFriends[index], widget.trailingActions);
        },
      ),
    );
  }
}

class FriendFindingTab extends StatefulWidget {
  final List<Friend> friends;
  final void Function(int) onTabChange;
  final VoidCallback? onShakeButtonPressed;
  final List<Widget> trailingActions;
  final Widget Function(Friend, List<Widget>) buildRowForFriendFinding;

  const FriendFindingTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
    this.onShakeButtonPressed,
    required this.buildRowForFriendFinding,
    required this.trailingActions,
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
    return Column(
      children: [
        SearchBarWidget(
          onSearchChanged: _onSearchChanged,
          content: Expanded(
            child: ListView.separated(
              itemCount: filteredFriends.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return widget.buildRowForFriendFinding(
                    filteredFriends[index], widget.trailingActions);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 90.0,
          child: Center(
            child: Text(
              "OR",
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 80.0,
          child: ElevatedButton(
            onPressed: widget.onShakeButtonPressed,
            child: const Text(
              "SHAKE IT",
              style: TextStyle(fontSize: 42.0),
            ),
          ),
        ),
      ],
    );
  }
}

class FriendPendingTab extends StatefulWidget {
  final List<Friend> friends;
  final void Function(int) onTabChange;
  final List<Widget> trailingActions;
  final Widget Function(Friend, List<Widget>) buildRowForFriendPending;

  const FriendPendingTab({
    Key? key,
    required this.friends,
    required this.onTabChange,
    required this.buildRowForFriendPending,
    required this.trailingActions,
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
          return widget.buildRowForFriendPending(
              filteredFriends[index], widget.trailingActions);
        },
      ),
    );
  }
}
