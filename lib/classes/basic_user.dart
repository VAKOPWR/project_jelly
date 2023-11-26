class BasicUser {
  String id;
  String name;
  String? avatar;
  bool? isOnline;

  BasicUser(
      {required this.id,
      required this.name,
      this.avatar,
      this.isOnline,
      });

  factory BasicUser.fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: json['id'].toString(),
      name: json['nickname'],
      avatar: json['profilePicture'],
      isOnline: json['isOnline'],
    );
  }
}
