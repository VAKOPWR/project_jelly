import 'package:project_jelly/classes/chat_DTO.dart';

import 'message_status.dart';

class Message {
  int? messageId;
  int chatId;
  int senderId;
  String text;
  String time;
  MessageStatus messageStatus;
  String? attachedPhoto;

  Message(
      {this.messageId,
      required this.chatId,
      required this.senderId,
      required this.text,
      required this.time,
      required this.messageStatus,
      this.attachedPhoto});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        messageId: json["messageId"],
        chatId: json["groupId"],
        senderId: json["senderId"],
        text: json["text"],
        time: json["timeSent"],
        messageStatus:
            MessageStatusExtension.fromString(json["messageStatus"])!,
        attachedPhoto: json["attachedPhoto"]);
  }
}
