import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/GroupChatResponse.dart';
import 'package:project_jelly/classes/chat.dart';
import 'package:project_jelly/classes/chat_user.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/pages/chat/messages/chat_messages_group.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/search_bar.dart';

class CreateGroupChat extends StatefulWidget {
  @override
  _CreateGroupChatState createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  final _formKey = GlobalKey<FormState>();
  List<Friend> filteredFriends = [];
  List<int> userIds = [];
  String chatName = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    filteredFriends = Get.find<MapService>().friendsData.values.toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredFriends = Get.find<MapService>().friendsData.values.toList();
      } else {
        filteredFriends = Get.find<MapService>()
            .friendsData
            .values
            .where((friend) =>
                friend.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildRow(Friend friend) {
    int? friendId = int.tryParse(friend.id);
    bool isChecked = friendId != null && userIds.contains(friendId);

    return ListTile(
      key: ValueKey(friend.id),
      title: Text(friend.name),
      trailing: Checkbox(
        value: isChecked,
        onChanged: (bool? newValue) {
          setState(() {
            if (friendId != null) {
              if (newValue ?? false) {
                if (!userIds.contains(friendId)) {
                  userIds.add(friendId);
                }
              } else {
                userIds.removeWhere((id) => id == friendId);
              }
            }
          });
        },
      ),
    );
  }

  Future<int?> _createGroupChat() async {
    GroupChatResponse? groupChatResponse = await Get.find<RequestService>()
        .createGroupChat(chatName, description, userIds);
    if (groupChatResponse != null) {
      int chatId = groupChatResponse.groupId;
      List<ChatUser> chatUsersList =
          groupChatResponse.chatUser.cast<ChatUser>();

      Map<int, ChatUser> chatUserMap = chatUsersList.fold(
        <int, ChatUser>{},
            (Map<int, ChatUser> map, ChatUser chatUser) {
          map[chatUser.id] = chatUser;
          return map;
        },
      );

      Get.find<MapService>().groupChatUsers.putIfAbsent(chatId, () => chatUserMap);

      Chat newChat = Chat(
          chatId: chatId,
          chatName: chatName,
          isFriendship: false,
          isMuted: false,
          isPinned: false);
      Get.find<MapService>().chats.putIfAbsent(chatId, () => newChat);
      Get.find<MapService>().newMessagesBool = true;

      Get.snackbar("Congratulations!", "Your group was created! ${chatName}",
          icon: Icon(Icons.sentiment_satisfied_alt_outlined,
              color: Colors.white, size: 35),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green[400],
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
      return chatId;
    } else {
      Get.snackbar("Ooops!", "Failed to create group ${chatName}",
          icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
              color: Colors.white, size: 35),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Group Chat',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Chat Name'),
                        onSaved: (value) => chatName = value ?? '',
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        onSaved: (value) => description = value ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SearchBarWidget(
                  onSearchChanged: _onSearchChanged,
                  content: ListView.separated(
                    itemCount: filteredFriends.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return _buildRow(filteredFriends[index]);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 40.0), // Add your desired padding
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          int? success = await _createGroupChat();
                          if (success != null) {
                            Navigator.pop(context);
                            Get.to(
                              () => ChatMessagesGroup(chatId: success),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
