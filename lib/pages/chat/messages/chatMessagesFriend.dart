import 'package:flutter/material.dart';
import 'package:project_jelly/widgets/ownMessage.dart';
import 'package:project_jelly/widgets/replyMessage.dart';

class ChatMessagesFriend extends StatefulWidget{
  const ChatMessagesFriend ({Key? key}) : super(key: key);

  @override
  State<ChatMessagesFriend> createState() => _ChatMessagesFriendState();
}

class _ChatMessagesFriendState extends State<ChatMessagesFriend> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();


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
        child: Column(
          children: [
            ListView(
              children: [
                OwnMessage(message: "message", time: "12:50"),
                ReplyMessage(message: "reply", time: "12:31"),
                OwnMessage(message: "message", time: "12:50"),
                ReplyMessage(message: "reply", time: "12:31"),
                OwnMessage(message: "message", time: "12:50"),
                ReplyMessage(message: "reply", time: "12:31"),
                OwnMessage(message: "message", time: "12:50"),
                ReplyMessage(message: "reply", time: "12:31")
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Card(
                            margin: EdgeInsets.only(
                                left: 3, right: 3, bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _controller,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            right: 3,
                            left: 3,
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green[600],
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _scrollController.animateTo(
                                    _scrollController
                                        .position.maxScrollExtent,
                                    duration:
                                    Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                                // sendMessage(
                                //     _controller.text,
                                //
                                // _controller.clear()
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}