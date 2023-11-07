import 'package:google_maps_flutter/google_maps_flutter.dart';

class Friend {
  String id;
  String name;
  String avatar;
  LatLng location;
  String description;
  String batteryPercentage;
  String movementSpeed;

  Friend(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.location,
      required this.description,
      required this.batteryPercentage,
      required this.movementSpeed});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        name: json['nickname'],
        avatar:
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
        location: LatLng(json['latitude'], json['longitude']),
        description: json['description'],
        batteryPercentage: json['batteryPercentage'],
        movementSpeed: json['movementSpeed']);
  }
}
