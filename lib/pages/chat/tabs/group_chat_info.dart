import 'package:flutter/material.dart';
import 'package:project_jelly/classes/chat.dart';
import 'package:project_jelly/classes/chat_user.dart';
import 'package:get/get.dart';
import 'package:project_jelly/service/map_service.dart';

class GroupChatInfo extends StatefulWidget {
  final Chat chat;

  const GroupChatInfo({Key? key, required this.chat}) : super(key: key);

  @override
  _GroupChatInfoState createState() => _GroupChatInfoState();
}

class _GroupChatInfoState extends State<GroupChatInfo> {
  late List<ChatUser> members;

  @override
  void initState() {
    super.initState();
    members = Get.find<MapService>().chatUsers[widget.chat.chatId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.chatName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          _buildChatDetails(),
          Expanded(child: _buildMembersList()),
        ],
      ),
    );
  }


  Widget _buildAvatar() {
    return Center(
      child: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(widget.chat.picture ?? 'https://cataas.com/cat/rrsvsbRgL7zaJuR3'),
      ),
    );
  }

  Widget _buildChatDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.chat.chatName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Description: ${widget.chat.message?.text ?? 'No description available'}",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(members[index].profilePicture),
          ),
          title: Text(members[index].nickname),
        );
      },
    );
  }
}
