import 'package:google_maps_flutter/google_maps_flutter.dart';

class Friend {
  String id;
  String name;
  LatLng location;
  int batteryPercentage;
  double movementSpeed;
  bool isOnline;
  String offlineStatus;

  Friend(
      {required this.id,
      required this.name,
      required this.location,
      required this.batteryPercentage,
      required this.movementSpeed,
      this.isOnline = false,
      this.offlineStatus = '**'});

  factory Friend.fromJson(Map<String, dynamic> json) {
    if (json['positionLat'] == 0 && json['positionLon'] == 0) {
      return Friend(
        id: json['id'].toString(),
        name: json['nickname'],
        location: LatLng(-90.0, -90.0),
        batteryPercentage: json['batteryLevel'],
        movementSpeed: json['speed'],
      );
    }
    return Friend(
      id: json['id'].toString(),
      name: json['nickname'],
      location: LatLng(json['positionLat'], json['positionLon']),
      batteryPercentage: json['batteryLevel'],
      movementSpeed: json['speed'],
    );
  }
}
