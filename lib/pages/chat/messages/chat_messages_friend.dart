import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jelly/classes/message.dart';
import 'package:project_jelly/classes/message_status.dart';
import 'package:project_jelly/pages/chat/messages/common.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/widgets/own_message.dart';
import 'package:project_jelly/widgets/reply_message.dart';


class ChatMessagesFriend extends StatefulWidget {
  final chatId;

  const ChatMessagesFriend({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatMessagesFriend> createState() => _ChatMessagesFriendState();
}

class _ChatMessagesFriendState extends State<ChatMessagesFriend> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  List<Message> messages = [];
  XFile? _pickedImage;
  late Timer _stateTimer;
  int page = 0;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
    _stateTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {
        if (Get.find<MapService>().newMessagesBool){
          fetchNewMessage();
        }
      });
    });
  }

  @override
  void dispose() {
    _stateTimer.cancel();
    super.dispose();
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back),
            // SizedBox(width: 10),
            CircleAvatar(
              radius: 10,
            )
          ],
        ),
        title: Text(Get.find<MapService>().chats[widget.chatId]!.chatName),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == 0) {
            _scrollPosition = _scrollController.position.pixels;
        loadMessages();
      }
      return false;
    },
      child: Container(
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
                  if (messages[index].senderId==FirebaseAuth.instance.currentUser!.uid){
                    return OwnMessage(
                      message: messages[index].text,
                      time: formatMessageTime(messages[index].time),
                      messageStatus: messages[index].messageStatus,
                      imageUrl: messages[index].attachedPhoto,
                    );
                  }
                  else {
                    return ReplyMessage(
                      message: messages[index].text,
                      time: formatMessageTime(messages[index].time),
                      messageStatus: messages[index].messageStatus,
                      imageUrl: messages[index].attachedPhoto,
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_pickedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 8),
                            Text("Attached Image: ${_pickedImage!.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                            IconButton(
                                onPressed: (){
                                  setState(() {
                                    _pickedImage = null;
                                  });
                                },
                                icon: Icon(Icons.delete_outline))
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 65,
                            child: Card(
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: TextField(
                                    focusNode: focusNode,
                                    controller: _controller,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    minLines: 1,
                                    textAlignVertical: TextAlignVertical
                                        .center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      alignLabelWithHint:
                                          true,
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          emojiShowing
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!emojiShowing) {
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                            setState(() {
                                              emojiShowing = !emojiShowing;
                                            });
                                          } else {
                                            focusNode.requestFocus();
                                          }
                                        },
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.attach_file_outlined),
                                        onPressed: () {
                                          _pickImage();
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
                                _sendMessage();
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                                String messageText = _controller.text;
                                messages.add(Message(
                                    text: messageText,
                                    time: DateTime.now().toLocal(),
                                    chatId: widget.chatId,
                                    senderId: int.parse(FirebaseAuth.instance.currentUser!.uid),
                                    messageStatus: MessageStatus.SENT));
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

            //TODO: colors for the emoji panel. May be left as is
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
    ));
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });    }
  }

  Future<void> _sendMessage() async{
    bool response = await Get.find<RequestService>().sendMessage(Message(
        text: _controller.text, time: DateTime.now().toLocal(),
        chatId: widget.chatId,
        senderId: int.parse(FirebaseAuth.instance.currentUser!.uid),
        messageStatus: MessageStatus.SENT,
        attachedPhoto: handleImagesToText(_pickedImage)
    )
    );
  }

  Future<void> fetchNewMessage() async {
    if (Get.find<MapService>().newMessagesBool && Get.find<MapService>().newMessages.containsKey(widget.chatId)){
      setState(() {
        messages.addAll(Get.find<MapService>().newMessages[widget.chatId]!);
        Get.find<MapService>().newMessages.remove(widget.chatId);
      });
    }
  }

  Future<void> loadMessages() async {
    List<Message> messagePage = await Get.find<RequestService>().loadMessagesPaged(widget.chatId, page);
    setState(() {
      messages.addAll(messagePage);
      page++;
      _scrollController.jumpTo(_scrollPosition);
    });
  }
}
