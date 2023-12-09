import 'package:flutter/material.dart';

class ChatMessagesGroup extends StatefulWidget{
  final groupId;

  const ChatMessagesGroup ({Key? key, required this.groupId}) : super(key: key);

  @override
  State<ChatMessagesGroup> createState() => _ChatMessagesGroupState();
}

class _ChatMessagesGroupState extends State<ChatMessagesGroup> {

  @override
  Widget build(BuildContext context){
    return Placeholder();
  }
}