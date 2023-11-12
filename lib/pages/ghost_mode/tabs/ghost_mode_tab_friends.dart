import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/pages/ghost_mode/friend_specific_ghost_mode.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class GhostModeTabFriends extends StatefulWidget {
  const GhostModeTabFriends({super.key});

  @override
  _GhostModeTabFriends createState() => _GhostModeTabFriends();
}

class _GhostModeTabFriends extends State<GhostModeTabFriends> {
  void getData() {}

  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<Friend> _listFriends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // child: SearchBarWidget(
      //   content: _buildContent(),
      // ),
    );
  }

  Widget _buildContent() {
    Widget widget;

    if (_isProgressBarShown) {
      widget = const Center(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      widget = ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();
            final friendIndex = i ~/ 2;
            // TODO delete this condition
            if (friendIndex != _listFriends.length) {
              return _buildRow(_listFriends[friendIndex]);
            }
            return null;
          });
    }
    return widget;
  }

  Widget _buildRow(Friend person) {
    return GestureDetector(
      onTap: () {
        _handleFriendClick(person);
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
        ),
        title: Text(
          person.name,
          style: _biggerFont,
        ),
      ),
    );
  }

  void _handleFriendClick(Friend person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendSpecificGhostMode(
          person:
              person, // Replace 'personObject' with the actual Person object
        ),
      ),
    );
  }

  _fetchFriendsList() async {
    setState(() {
      _listFriends = Get.find<LocationService>().friendsData.values.toList();
    });
  }
}
