import 'package:google_maps_flutter/google_maps_flutter.dart';

String defaultAvatarUrl = 'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50';

class Friend {
  String id;
  String nickname;
  String avatar;
  LatLng location;

  Friend({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.location,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'].toString(),
      nickname: json['nickname'],
      avatar: json['profilePicture'] ?? defaultAvatarUrl,
      location: LatLng(json['positionLat'], json['positionLon']),
    );
  }
}
