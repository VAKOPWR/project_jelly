import 'dart:ffi';

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
  final List<ChatUser>? groupUsers;
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
    return ChatDTO(
      groupId: json['groupId'],
      groupName: json['groupName'],
      picture: json['picture'],
      description: json['description'],
      friendId: json['friendId'],
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessageText: json['lastMessageText'],
      lastMessageTimeSent: DateTime.tryParse(json['lastMessageTimeSent']),
      lastMessageMessagesStatus: MessageStatusExtension.fromString(
          json['lastMessageMessagesStatus'] ?? ''),
      lastMessageAttachedPhoto: json['lastMessageAttachedPhoto'],
      groupUsers: (json['groupUsers'] as List<dynamic>?)
          ?.map((user) => ChatUser.fromJson(user as Map<String, dynamic>))
          .toList(),
      pinned: json['pinned'],
      friendship: json['friendship'],
      muted: json['muted'],
    );
  }
}



extension MessageStatusExtension on MessageStatus {
  static MessageStatus fromString(String value) {
    return MessageStatus.values
        .firstWhere((e) => e.toString().split('.')[1] == value.toUpperCase());
  }
}
