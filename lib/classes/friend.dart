import 'package:google_maps_flutter/google_maps_flutter.dart';

class Friend {
  String id;
  String name;
  String avatar;
  LatLng location;
  int batteryPercentage;
  int movementSpeed;
  bool isOnline;
  String offlineStatus;

  Friend(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.location,
      required this.batteryPercentage,
      required this.movementSpeed,
      required this.isOnline,
      required this.offlineStatus});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        name: json['nickname'],
        avatar:
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
        location: LatLng(json['latitude'], json['longitude']),
        batteryPercentage: json['batteryPercentage'],
        movementSpeed: json['movementSpeed'],
        isOnline: json['isOnline'],
        offlineStatus: json['offlineStatus']);
  }
}
