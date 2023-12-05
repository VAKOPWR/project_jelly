import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/friend.dart';
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
            .where((friend) => friend.name.toLowerCase().contains(value.toLowerCase()))
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



  Future<void> _createGroupChat() async {
    bool success = await Get.find<RequestService>()
        .createGroupChat(chatName, description, userIds);
    if (success) {
      // Prototype TODO finish after updated endpoint on backend side
      // Get.find<MapService>().chatUsers.putIfAbsent(chatId, () => chatUsersList);
      // Get.find<MapService>().chats.putIfAbsent(chatId, () => chatName);
      // Get.find<MapService>().newMessagesBool = true;

      Get.snackbar("Congratulations!",
          "Your group was created! ${chatName}",
          icon: Icon(Icons.sentiment_satisfied_alt_outlined,
              color: Colors.white, size: 35),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green[400],
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      Get.snackbar(
          "Ooops!", "Failed to create group ${chatName}",
          icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
              color: Colors.white, size: 35),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
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

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _createGroupChat();
              }
            },
            child: Text('Create Group Chat'),
          ),
        ],
      ),
    );
  }


}
