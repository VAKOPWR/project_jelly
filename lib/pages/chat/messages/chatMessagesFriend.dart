import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_jelly/widgets/ownMessage.dart';
import 'package:project_jelly/widgets/replyMessage.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../classes/message.dart';


class ChatMessagesFriend extends StatefulWidget{
  const ChatMessagesFriend ({Key? key}) : super(key: key);

  @override
  State<ChatMessagesFriend> createState() => _ChatMessagesFriendState();
}

class _ChatMessagesFriendState extends State<ChatMessagesFriend> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  List<Message> messages = [];

  @override
  void initState(){
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus){
        setState(() {
          emojiShowing = false;
        });
      }
    });
  }
  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back),
            // SizedBox(width: 10),
            CircleAvatar(
              radius: 10,
            )
          ],
        ),
        title: Text("temp"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[700],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return OwnMessage(
                    message: messages[index].text,
                    time: messages[index].time.toString(),
                  );
                },
              ),
                // child: ListView(
                //   children: [
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31"),
                //     OwnMessage(message: "message", time: "12:50"),
                //     ReplyMessage(message: "reply", time: "12:31")
                //   ],
                // )
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 65,
                            child: Card(
                              margin: EdgeInsets.only(left: 3, right: 3, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust as needed
                                  child: TextField(
                                    focusNode: focusNode,
                                    controller: _controller,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    minLines: 1,
                                    textAlignVertical: TextAlignVertical.center, // Center text vertically
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      alignLabelWithHint: true, // Align the label (hint) to the bottom
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          emojiShowing
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!emojiShowing){
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                            setState(() {
                                              emojiShowing = !emojiShowing;
                                            });
                                          }
                                          else {
                                            focusNode.requestFocus();
                                          }
                                        },
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            Icons.attach_file_outlined
                                        ),
                                        onPressed: () {

                                        },
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
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
                                    String messageText = _controller.text;
                                    String currentTime = DateFormat.jm().format(DateTime.now().toLocal());
                                    messages.add(Message(text: messageText, time: currentTime));
                                    _controller.clear();
                                    _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: _controller,
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                      columns: 7,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}