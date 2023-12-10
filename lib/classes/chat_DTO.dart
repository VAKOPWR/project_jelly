import 'chat_user.dart';
import 'message_status.dart';

class ChatDTO {
  final int groupId;
  final String groupName;
  final String? picture;
  final String? description;
  final int? friendId;
  final int? lastMessageSenderId;
  final String? lastMessageText;
  final DateTime? lastMessageTimeSent;
  final MessageStatus? lastMessageMessagesStatus;
  final String? lastMessageAttachedPhoto;
  final Map<int, ChatUser>? groupUsers;
  final bool pinned;
  final bool friendship;
  final bool muted;

  ChatDTO({
    required this.groupId,
    required this.groupName,
    required this.pinned,
    required this.friendship,
    required this.muted,
    this.description,
    this.friendId,
    this.picture,
    this.lastMessageSenderId,
    this.lastMessageText,
    this.lastMessageTimeSent,
    this.lastMessageMessagesStatus,
    this.lastMessageAttachedPhoto,
    this.groupUsers,
  });

  factory ChatDTO.fromJson(Map<String, dynamic> json) {
    int groupId = json['groupId'];
    String groupName = json['groupName'];
    String? picture = json['picture'];
    String? description = json['description'];
    int? friendId = json['friendId'];
    int? lastMessageSenderId = json['lastMessageSenderId'];
    String? lastMessageText = json['lastMessageText'];
    DateTime? lastMessageTimeSent =
        DateTime.tryParse(json['lastMessageTimeSent'] ?? '');
    MessageStatus? lastMessageMessagesStatus =
        MessageStatusExtension.fromString(json['lastMessageMessagesStatus']);
    String? lastMessageAttachedPhoto = json['lastMessageAttachedPhoto'];
    List<ChatUser>? groupUsers = (json['groupUsers'] as List<dynamic>?)
        ?.map<ChatUser>(
            (user) => ChatUser.fromJson(user as Map<String, dynamic>))
        .toList();
    Map<int, ChatUser>? userMap = groupUsers?.fold<Map<int, ChatUser>>(
      {},
      (Map<int, ChatUser> map, ChatUser user) {
        map[user.id] = user;
        return map;
      },
    );
    bool pinned = json['pinned'] ?? false;
    bool friendship = json['friendship'] ?? false;
    bool muted = json['muted'] ?? false;
    return ChatDTO(
      groupId: groupId,
      groupName: groupName,
      picture: picture ?? '',
      description: description ?? '',
      friendId: friendId,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageText: lastMessageText,
      lastMessageTimeSent: lastMessageTimeSent,
      lastMessageMessagesStatus: lastMessageMessagesStatus,
      lastMessageAttachedPhoto: lastMessageAttachedPhoto ?? '',
      groupUsers: userMap,
      pinned: pinned,
      friendship: friendship,
      muted: muted,
    );
  }
}

extension MessageStatusExtension on MessageStatus {
  static MessageStatus? fromString(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return MessageStatus.values
        .firstWhere((e) => e.toString().split('.')[1] == value.toUpperCase());
  }
}
