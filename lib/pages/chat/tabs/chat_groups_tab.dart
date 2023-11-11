import 'package:flutter/material.dart';

class ChatGroupsTab extends StatefulWidget {
  const ChatGroupsTab({Key? key}) : super(key: key);

  @override
  State<ChatGroupsTab> createState() => _ChatGroupsTabState();
}

class _ChatGroupsTabState extends State<ChatGroupsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
    );
  }
}
