class ChatUser {
  final int id;
  final String nickname;
  final String profilePicture;

  ChatUser(
      {required this.id, required this.nickname, required this.profilePicture});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
        id: json["id"],
        nickname: json["nickname"],
        profilePicture: json["picture"]);
  }
}
