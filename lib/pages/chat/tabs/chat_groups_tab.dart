import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_jelly/pages/chat/messages/chat_messages_group.dart';
import 'package:project_jelly/pages/chat/messages/common.dart';
import 'package:project_jelly/widgets/search_bar.dart';

import '../../../classes/chat.dart';
import '../../../service/map_service.dart';

class ChatGroupsTab extends StatefulWidget {
  const ChatGroupsTab({Key? key}) : super(key: key);

  @override
  State<ChatGroupsTab> createState() => _ChatGroupsTabState();
}

class _ChatGroupsTabState extends State<ChatGroupsTab> {
  List<Chat> chats = [];
  List<Chat> filteredChats = [];
  String searchQuery = "";
  late Timer _stateTimer;

  @override
  void initState() {
    super.initState();
    fetchAndSortGroupChats();
    _stateTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {
        if (Get.find<MapService>().newMessagesBool ||
            Get.find<MapService>().newGroupChatsBool) {
          fetchAndSortGroupChats();
          Get.find<MapService>().newMessagesBool = false;
          Get.find<MapService>().newGroupChatsBool = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _stateTimer.cancel();
    super.dispose();
  }

  Future<void> fetchAndSortGroupChats() async {
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
            //TODO: also style this
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
                      Get.to(() => ChatMessagesGroup(chatId: chat.chatId));
                    },
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: Get.find<MapService>()
                                .imageProviders[chat.picture],
                          )
                        ],
                      ),
                      title: Row(
                        children: [
                          Text(chat.chatName),
                          if (chat.isPinned) Icon(Icons.push_pin),
                          if (chat.isMuted) Icon(Icons.volume_off)
                        ],
                      ),
                      subtitle: Text(
                          chat.message?.attachedPhoto != null
                              ? 'Photo'
                              : chat.message?.text ?? '',
                          overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (chat.message != null)
                            buildReadStatusIcon(chat.message!.messageStatus),
                          Text(
                            chat.message != null ? chat.message!.time : '',
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
    return allChats.where((chat) => chat.isFriendship == false).toList();
  }
}
