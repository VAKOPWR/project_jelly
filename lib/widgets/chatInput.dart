import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {

  ChatInput({Key? key}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Container(
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
                        sendMessage(
                            _controller.text,
                            widget.sourchat.id,
                            widget.chatModel.id);
                        _controller.clear();
                        setState(() {
                          sendButton = false;
                        });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}