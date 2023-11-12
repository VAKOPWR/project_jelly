import 'package:flutter/material.dart';

class ChatFriendsTab extends StatefulWidget {
  const ChatFriendsTab({Key? key}) : super(key: key);

  @override
  State<ChatFriendsTab> createState() => _ChatFriendsTabState();
}

class _ChatFriendsTabState extends State<ChatFriendsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
    );
  }
}
