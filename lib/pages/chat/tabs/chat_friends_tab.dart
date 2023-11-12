import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../classes/friend_chat.dart';
import '../../../classes/friend.dart';
import '../../../widgets/search_bar.dart';
import '../messages/common.dart';

class ChatFriendsTab extends StatefulWidget {
  const ChatFriendsTab({Key? key}) : super(key: key);

  @override
  State<ChatFriendsTab> createState() => _ChatFriendsTabState();
}

class _ChatFriendsTabState extends State<ChatFriendsTab> {
  late final List<FriendChat> chats;
  List<FriendChat> filteredChats = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchAndSortFriendChats();
  }

  Future<void> fetchAndSortFriendChats() async {
    List<FriendChat> fetchedChats = await getChatsFromNetwork();

    fetchedChats.sort((a, b) => b.lastSentTime.compareTo(a.lastSentTime));

    setState(() {
      chats = fetchedChats;
      filteredChats =
          searchQuery.isEmpty ? chats : filterChats(searchQuery, chats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
        onSearchChanged: updateSearchQuery,
        content: Container(
          child: ListView.separated(
            itemCount: filteredChats.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(chat.friend.avatar),
                    ),
                    if (chat.friend.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).canvasColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(chat.friend.name),
                subtitle: Text(chat.lastMessage),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildReadStatusIcon(chat.hasRead),
                    Text(
                      formatLastSentTime(chat.lastSentTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  List<FriendChat> filterChats(String query, List<FriendChat> chatList) {
    return chatList
        .where((chat) =>
            chat.friend.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filteredChats = filterChats(searchQuery, chats);
    });
  }

  Future<List<FriendChat>> getChatsFromNetwork() async {
    return generateFakeChats();
  }

  List<FriendChat> generateFakeChats() {
    return [
      FriendChat(
        friend: Friend(
          id: '1',
          name: 'Orest Haman',
          avatar: 'https://placekitten.com/200/200',
          location: LatLng(37.7749, -122.4194),
          batteryPercentage: 80,
          movementSpeed: 3,
          isOnline: true,
          offlineStatus: '2 hours ago',
        ),
        lastMessage: 'Hey, when are we going hiking?',
        hasRead: false,
        lastSentTime: DateTime.now().subtract(Duration(hours: 1)),
      ),
      FriendChat(
        friend: Friend(
          id: '2',
          name: 'Andrii Papusha',
          avatar: 'https://placekitten.com/200/201',
          location: LatLng(34.0522, -118.2437),
          batteryPercentage: 50,
          movementSpeed: 0,
          isOnline: false,
          offlineStatus: '1 day ago',
        ),
        lastMessage: 'Don\'t forget about the meeting tomorrow!',
        hasRead: true,
        lastSentTime: DateTime.now().subtract(Duration(minutes: 1)),
      ),
      FriendChat(
        friend: Friend(
          id: '3',
          name: 'Jone Stone',
          avatar: 'https://placekitten.com/200/202',
          location: LatLng(40.7128, -74.0060),
          batteryPercentage: 65,
          movementSpeed: 5,
          isOnline: false,
          offlineStatus: '5 minutes ago',
        ),
        lastMessage: 'That was a great game last night!',
        hasRead: true,
        lastSentTime: DateTime.now().subtract(Duration(days: 1)),
      ),
      FriendChat(
        friend: Friend(
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
        lastMessage: 'See you next week!',
        hasRead: false,
        lastSentTime: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];
  }
}
