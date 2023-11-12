import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../classes/friend.dart';
import '../../../classes/group_chat.dart';
import '../../../widgets/search_bar.dart';
import '../messages/common.dart';

class ChatGroupsTab extends StatefulWidget {
  const ChatGroupsTab({Key? key}) : super(key: key);

  @override
  State<ChatGroupsTab> createState() => _ChatGroupsTabState();
}

class _ChatGroupsTabState extends State<ChatGroupsTab> {
  List<GroupChat> groupChats = [];
  List<GroupChat> filteredGroupChats = [];

  @override
  void initState() {
    super.initState();
    fetchAndSortGroupChats();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
      onSearchChanged: updateSearchQuery,
      content: ListView.separated(
        itemCount: filteredGroupChats.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final groupChat = filteredGroupChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: groupChat.avatar != null
                  ? NetworkImage(groupChat.avatar!)
                  : NetworkImage('https://placekitten.com/200/201'),
            ),
            title: Text(groupChat.groupName),
            subtitle: _buildGroupLastMessage(groupChat),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildReadStatusIcon(groupChat.hasRead),
                Text(
                  formatLastSentTime(groupChat.lastSentTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  void updateSearchQuery(String newQuery) {
    filterAndSortChats(newQuery);
  }

  void filterAndSortChats(String query) async {
    final newQuery = query.toLowerCase();

    List<GroupChat> filteredAndSorted = await Future(() {
      return groupChats
          .where((groupChat) =>
              groupChat.groupName.toLowerCase().contains(newQuery))
          .toList()
        ..sort((a, b) => b.lastSentTime.compareTo(a.lastSentTime));
    });

    setState(() {
      filteredGroupChats = filteredAndSorted;
    });
  }

  Widget _buildGroupLastMessage(GroupChat chat) {
    String senderName = chat.lastFriend.name;
    return Text('$senderName: ${chat.lastMessage}');
  }

  Future<void> fetchAndSortGroupChats() async {
    List<GroupChat> fetchedGroupChats = await getGroupChatsFromNetwork();

    fetchedGroupChats.sort((a, b) => b.lastSentTime.compareTo(a.lastSentTime));

    setState(() {
      groupChats = fetchedGroupChats;
      filteredGroupChats = fetchedGroupChats;
    });
  }

  Future<List<GroupChat>> getGroupChatsFromNetwork() async {
    return generateFakeGroupChats();
  }

  List<GroupChat> generateFakeGroupChats() {
    return [
      GroupChat(
        lastFriend: Friend(
          id: '1',
          name: 'Orest Haman',
          avatar: 'https://placekitten.com/200/200',
          location: LatLng(37.7749, -122.4194),
          batteryPercentage: 80,
          movementSpeed: 3,
          isOnline: true,
          offlineStatus: '2 hours ago',
        ),
        groupName: 'ZPI Team',
        avatar: 'https://placekitten.com/200/208',
        lastMessage: 'Hey, when are we going to play football?',
        hasRead: true,
        lastSentTime: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      GroupChat(
        lastFriend: Friend(
          id: '2',
          name: 'Andrii Papusha',
          avatar: 'https://placekitten.com/200/201',
          location: LatLng(34.0522, -118.2437),
          batteryPercentage: 50,
          movementSpeed: 0,
          isOnline: false,
          offlineStatus: '1 day ago',
        ),
        groupName: 'My roommates',
        avatar: 'https://placekitten.com/200/209',
        lastMessage: 'Hey, someone is online?',
        hasRead: false,
        lastSentTime: DateTime.now().subtract(Duration(hours: 1)),
      ),
      GroupChat(
        lastFriend: Friend(
          id: '4',
          name: 'Diana Prince',
          avatar: 'https://placekitten.com/200/203',
          // Placeholder avatar image
          location: LatLng(42.3601, -71.0589),
          batteryPercentage: 90,
          movementSpeed: 7,
          isOnline: true,
          offlineStatus: 'Online',
        ),
        groupName: 'PWR chat',
        avatar: 'https://placekitten.com/200/210',
        lastMessage: 'Hey, when are we going to watch AOT?',
        hasRead: false,
        lastSentTime: DateTime.now().subtract(Duration(days: 1)),
      ),
      GroupChat(
        lastFriend: Friend(
          id: '3',
          name: 'Jone Stone',
          avatar: 'https://placekitten.com/200/202',
          location: LatLng(40.7128, -74.0060),
          batteryPercentage: 65,
          movementSpeed: 5,
          isOnline: false,
          offlineStatus: '5 minutes ago',
        ),
        groupName: 'Gamers ONLY',
        avatar: 'https://placekitten.com/200/212',
        lastMessage: 'Thanks for playing',
        hasRead: true,
        lastSentTime: DateTime.now().subtract(Duration(minutes: 1)),
      ),
    ];
  }
}
