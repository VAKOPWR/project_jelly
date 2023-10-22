import 'package:flutter/material.dart';

class ChatMessagesFriend extends StatefulWidget{
  const ChatMessagesFriend ({Key? key}) : super(key: key);

  @override
  State<ChatMessagesFriend> createState() => _ChatMessagesFriendState();
}

class _ChatMessagesFriendState extends State<ChatMessagesFriend> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back),
            CircleAvatar(
              radius: 20,
            )
          ],
        ),
        title: Text("temp"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }
}