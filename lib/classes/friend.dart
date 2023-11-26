import 'package:google_maps_flutter/google_maps_flutter.dart';

class Friend {
  String id;
  String name;
  LatLng location;
  int batteryPercentage;
  int movementSpeed;
  String? avatar;
  bool? isOnline;
  String? offlineStatus;

  Friend(
      {required this.id,
      required this.name,
      required this.location,
      required this.batteryPercentage,
      required this.movementSpeed,
      this.avatar,
      this.isOnline,
      this.offlineStatus});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['nickname'],
      location: LatLng(json['positionLat'], json['positionLon']),
      batteryPercentage: json['batteryLevel'],
      movementSpeed: json['speed'],
    );
  }
}
