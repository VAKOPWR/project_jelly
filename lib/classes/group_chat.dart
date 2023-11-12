import 'friend.dart';

class GroupChat {
  final String groupName;
  final String? avatar;
  final String lastMessage;
  final Friend lastFriend;
  final bool hasRead;
  final DateTime lastSentTime;

  GroupChat({
    required this.groupName,
    this.avatar,
    required this.lastMessage,
    required this.lastFriend,
    required this.hasRead,
    required this.lastSentTime,
  });
}