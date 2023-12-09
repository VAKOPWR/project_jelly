import 'dart:ffi';

import 'message_status.dart';

class Message{
  int chatId;
  int senderId;
  String text;
  DateTime time;
  MessageStatus messageStatus;
  String? attachedPhoto;


  Message({
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.time,
    required this.messageStatus,
    this.attachedPhoto
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
        chatId: json["chatId"],
        senderId: json["senderId"],
        text: json["text"],
        time: json["time"],
        messageStatus: json["messageStatus"],
        attachedPhoto: json["attachedPhoto"]);
  }

}