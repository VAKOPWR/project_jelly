import 'dart:async';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

    loadMessagesInit();
    _stateTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {
        if (Get.find<MapService>().newMessagesBool) {
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
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Container(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: Text(
                            Get.find<MapService>()
                                .chats[widget.chatId]!
                                .chatName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Image(
                      image: Get.find<MapService>().imageProviders[MarkerId(
                              Get.find<MapService>()
                                  .chats[widget.chatId]!
                                  .friendId
                                  .toString())] ??
                          Get.find<MapService>().defaultImageProvider!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.isEmpty ? 1 : messages.length,
                    itemBuilder: (context, index) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "This chat seems to be empty... try writing something",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (messages[index].senderId ==
                          Get.find<MapService>().currUserId) {
                        return OwnMessage(
                          message: messages[index].text,
                          time: formatMessageTimeStr(messages[index].time),
                          messageStatus: messages[index].messageStatus,
                          imageUrl: messages[index].attachedPhoto,
                        );
                      } else {
                        return ReplyMessage(
                          message: messages[index].text,
                          time: formatMessageTimeStr(messages[index].time),
                          imageUrl: messages[index].attachedPhoto,
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
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
                                Text(
                                  "Attached Image: ${_pickedImage!.name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                    onPressed: () {
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
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 15),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 65,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 3, right: 3, bottom: 8),
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
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  16), // Adjust padding as needed
                                          border: InputBorder.none,
                                          hintText: "Type a message",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          alignLabelWithHint: true,
                                          prefixIcon: IconButton(
                                            icon: Icon(
                                              emojiShowing
                                                  ? Icons.keyboard
                                                  : Icons
                                                      .emoji_emotions_outlined,
                                            ),
                                            onPressed: () {
                                              if (!emojiShowing) {
                                                focusNode.unfocus();
                                                focusNode.canRequestFocus =
                                                    false;
                                                setState(() {
                                                  emojiShowing = !emojiShowing;
                                                });
                                              } else {
                                                focusNode.requestFocus();
                                              }
                                            },
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                                Icons.attach_file_outlined),
                                            onPressed: () {
                                              _pickImage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 25,
                                right: 3,
                                left: 3,
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  onPressed: () async {
                                    if (_controller.text != "" ||
                                        (_controller.isBlank ?? false)) {
                                      String timeahaha = await _sendMessage();
                                      _scrollController.animateTo(
                                          _scrollController
                                                  .position.maxScrollExtent +
                                              60,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut);
                                      String messageText = _controller.text;
                                      messages.add(Message(
                                          text: messageText,
                                          time: formatMessageTimeStr(timeahaha),
                                          chatId: widget.chatId,
                                          senderId:
                                              Get.find<MapService>().currUserId,
                                          messageStatus: MessageStatus.SENT));
                                      _controller.clear();
                                      _scrollController.animateTo(
                                        _scrollController
                                                .position.maxScrollExtent +
                                            60,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      setState(() {
                                        sortMessages();
                                      });
                                    }
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
                          bgColor: Theme.of(context).colorScheme.background,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.onBackground,
                          iconColorSelected:
                              Theme.of(context).colorScheme.primary,
                          backspaceColor: Theme.of(context).colorScheme.primary,
                          skinToneDialogBgColor:
                              Theme.of(context).colorScheme.onBackground,
                          skinToneIndicatorColor:
                              Theme.of(context).colorScheme.onBackground,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
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
      });
    }
  }

  Future<String> _sendMessage() async {
    return await Get.find<RequestService>()
        .sendMessage(widget.chatId, _controller.text);
    //TODO: handle images
  }

  Future<void> fetchNewMessage() async {
    if (Get.find<MapService>().newMessagesBool &&
        Get.find<MapService>().newMessages.containsKey(widget.chatId)) {
      setState(() {
        messages.addAll(
          Get.find<MapService>()
              .newMessages[widget.chatId]!
              .where((message) =>
                  message.senderId != Get.find<MapService>().currUserId)
              .toList(),
        );
        sortMessages();
        Get.find<MapService>().newMessages.remove(widget.chatId);
      });
    }
  }

  Future<void> loadMessages() async {
    List<Message> messagePage =
        await Get.find<RequestService>().loadMessagesPaged(widget.chatId, page);
    messages.addAll(messagePage);
    page++;
    setState(() {
      sortMessages();
    });
  }

  Future<void> loadMessagesInit() async {
    List<Message> messagesPaged =
        await Get.find<RequestService>().loadMessagesPaged(widget.chatId, page);
    messages.addAll(messagesPaged);
    setState(() {
      sortMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 60);
      });
    });
  }

  void sortMessages() {
    messages.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a.time);
      DateTime dateTimeB = DateTime.parse(b.time);
      return dateTimeA.compareTo(dateTimeB);
    });
  }
}
