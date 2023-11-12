import 'friend.dart';

class FriendChat {
  final Friend friend;
  final String lastMessage;
  final bool hasRead;
  final DateTime lastSentTime;

  FriendChat({
    required this.friend,
    required this.lastMessage,
    required this.hasRead,
    required this.lastSentTime,
  });
}