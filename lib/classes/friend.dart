import 'package:google_maps_flutter/google_maps_flutter.dart';

class Friend {
  String name;
  String avatar;
  LatLng location;

  Friend({required this.name, required this.avatar, required this.location});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        name: json['userId'],
        avatar:
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
        location: LatLng(json['latitude'], json['longitude']));
  }
}
