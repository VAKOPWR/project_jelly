import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  String name;
  BitmapDescriptor avatar;
  LatLng location;

  Person({required this.name, required this.avatar, required this.location});
}
