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
    print('groupId has been successfully initialised with $groupId');

    String groupName = json['groupName'];
    print('groupName has been successfully initialised with $groupName');

    String? picture = json['picture'];
    print('picture has been successfully initialised with $picture');

    String? description = json['description'];
    print('description has been successfully initialised with $description');

    int? friendId = json['friendId'];
    print('friendId has been successfully initialised with $friendId');

    int? lastMessageSenderId = json['lastMessageSenderId'];
    print('lastMessageSenderId has been successfully initialised with $lastMessageSenderId');

    String? lastMessageText = json['lastMessageText'];
    print('lastMessageText has been successfully initialised with $lastMessageText');

    DateTime? lastMessageTimeSent = DateTime.tryParse(json['lastMessageTimeSent'] ?? '');
    print('lastMessageTimeSent has been successfully initialised with $lastMessageTimeSent');

    MessageStatus? lastMessageMessagesStatus = MessageStatusExtension.fromString(json['lastMessageMessagesStatus']);
    print('lastMessageMessagesStatus has been successfully initialised with $lastMessageMessagesStatus');

    String? lastMessageAttachedPhoto = json['lastMessageAttachedPhoto'];
    print('lastMessageAttachedPhoto has been successfully initialised with $lastMessageAttachedPhoto');

    List<ChatUser>? groupUsers = (json['groupUsers'] as List<dynamic>?)
        ?.map<ChatUser>((user) => ChatUser.fromJson(user as Map<String, dynamic>))
        ?.toList();

    Map<int, ChatUser>? userMap = groupUsers?.fold<Map<int, ChatUser>>(
      {},
          (Map<int, ChatUser> map, ChatUser user) {
        map[user.id] = user;
        return map;
      },
    );

    bool pinned = json['pinned'] ?? false;
    print('pinned has been successfully initialised with $pinned');

    bool friendship = json['friendship'] ?? false;
    print('friendship has been successfully initialised with $friendship');

    bool muted = json['muted'] ?? false;
    print('muted has been successfully initialised with $muted');

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
    if (value==null||value.isEmpty){
      return null;
    }
    return MessageStatus.values
        .firstWhere((e) => e.toString().split('.')[1] == value.toUpperCase());
  }
}
