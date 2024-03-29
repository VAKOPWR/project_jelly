import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/chat.dart';
import 'package:project_jelly/pages/chat/messages/common.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

import '../messages/chat_messages_friend.dart';

class ChatFriendsTab extends StatefulWidget {
  const ChatFriendsTab({Key? key}) : super(key: key);

  @override
  State<ChatFriendsTab> createState() => _ChatFriendsTabState();
}

class _ChatFriendsTabState extends State<ChatFriendsTab> {
  List<Chat> chats = [];
  List<Chat> filteredChats = [];
  String searchQuery = "";
  late Timer _stateTimer;

  @override
  void initState() {
    super.initState();
    fetchAndSortFriendChats();
    _stateTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {
        if (Get.find<MapService>().newMessagesBool ||
            Get.find<MapService>().newFriendChatsBool) {
          fetchAndSortFriendChats();
          Get.find<MapService>().newMessagesBool = false;
          Get.find<MapService>().newFriendChatsBool = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _stateTimer.cancel();
    super.dispose();
  }

  Future<void> fetchAndSortFriendChats() async {
    List<Chat> fetchedChats = await getChatsFromNetwork();

    fetchedChats.sort((a, b) {
      if (a.isPinned && !b.isPinned) {
        return -1;
      } else if (!a.isPinned && b.isPinned) {
        return 1;
      }

      var timeA = a.message?.time;
      var timeB = b.message?.time;

      if (timeA != null && timeB != null) {
        return timeB.compareTo(timeA);
      }

      if (timeA == null && timeB == null) {
        return 0;
      } else if (timeA == null) {
        return 1;
      } else {
        return -1;
      }
    });

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
        content: Builder(builder: (BuildContext context) {
          if (filteredChats.isEmpty) {
            return Container(
              child: Center(
                child: Text("Ooooops, nothing to see here..."),
              ),
            );
          } else {
            return Container(
              child: ListView.separated(
                itemCount: filteredChats.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ChatMessagesFriend(chatId: chat.chatId));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        child: Image(
                          image: Get.find<MapService>().imageProviders[
                                  MarkerId(chat.friendId.toString())] ??
                              Get.find<MapService>().defaultImageProvider!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(chat.chatName),
                          if (chat.isPinned) Icon(Icons.push_pin),
                          if (chat.isMuted) Icon(Icons.volume_off)
                        ],
                      ),
                      subtitle: Text(
                          chat.message?.attachedPhoto != null &&
                                  chat.message?.attachedPhoto != ''
                              ? 'Photo'
                              : chat.message?.text ?? '',
                          overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (chat.message != null)
                            buildReadStatusIcon(chat.message!.messageStatus),
                          Text(
                            chat.message != null
                                ? formatMessageTimeStr(chat.message!.time)
                                : '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }));
  }

  List<Chat> filterChats(String query, List<Chat> chatList) {
    return chatList
        .where(
            (chat) => chat.chatName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filteredChats = filterChats(searchQuery, chats);
    });
  }

  Future<List<Chat>> getChatsFromNetwork() async {
    List<Chat> allChats = Get.find<MapService>().chats.values.toList();
    return allChats.where((chat) => chat.isFriendship).toList();
  }
}
