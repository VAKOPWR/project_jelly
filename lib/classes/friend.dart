import 'package:google_maps_flutter/google_maps_flutter.dart';

String defaultFriendAvatar ='https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50';

class Friend {
  String id;
  String name;
  String avatar;
  LatLng location;

  Friend(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.location});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        name: json['nickname'],
        avatar: defaultFriendAvatar,
        location: LatLng(json['latitude'], json['longitude']));
  }
}
