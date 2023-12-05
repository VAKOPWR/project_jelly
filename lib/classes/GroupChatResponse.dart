import 'chat_user.dart';

class GroupChatResponse {
  final int groupId;
  final List<ChatUser> chatUser;

  GroupChatResponse({required this.groupId, required this.chatUser});

  factory GroupChatResponse.fromJson(Map<String, dynamic> json) {
    var list = json['chatUserDTOS'] as List;
    List<ChatUser> chatUserList = list.map((i) => ChatUser.fromJson(i)).toList();
    return GroupChatResponse(
      groupId: json['groupId'],
      chatUser: chatUserList,
    );
  }
}