import 'message.dart';

class Chat {
  final int chatId;
  final int? friendId;
  final String chatName;
  final String? description;
  String? picture;
  final bool isFriendship;
  bool isPinned;
  bool isMuted;
  Message? message;

  Chat(
      {required this.isFriendship,
      required this.chatName,
      this.description,
      this.friendId,
      required this.chatId,
      this.picture,
      this.message,
      required this.isMuted,
      required this.isPinned});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatName: json["groupName"],
      friendId: json["friendId"],
      chatId: json["groupId"],
      picture: json["picture"],
      message: new Message(
          chatId: json["groupId"],
          senderId: json["lastMessageSenderId"],
          text: json["lastMessageText"],
          messageStatus: json["lastMessageMessageStatus"],
          attachedPhoto: json["lastMessageAttachedPhoto"],
          time: json["lastMessageTimeSent"]),
      isMuted: json["isMuted"],
      isPinned: json["isPinned"],
      isFriendship: json["isFriendship"],
    );
  }
}
