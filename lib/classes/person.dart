import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  String name;
  BitmapDescriptor avatar;
  LatLng location;

  Person({required this.name, required this.avatar, required this.location});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      avatar: BitmapDescriptor.defaultMarker,
      location: LatLng(json['latitude'], json['longitude'])
    );
  }
}
