import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
import 'package:project_jelly/classes/friend.dart';

class LocationService extends GetxService {
  final LocationSettings locationSettings =
      LocationSettings(accuracy: LocationAccuracy.best);
  Position? currentLocation;

  @override
  void onInit() async {
    super.onInit();
    currentLocation = await Geolocator.getLastKnownPosition();
    // Location.onLocationChanged.listen(_updateCurrentLocation);
    // Location.
    // log(_currentLocation.onLocationChanged.isEmpty as String);
  }

  void _startPositionStream() {
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(_updateCurrentLocation);
  }

  void _updateCurrentLocation(Position newLocation) {
    log('Location Controller');
    log(newLocation.toString());
  }

  Future<http.Response> sendLocation(Position locationData) async {
    log('location sent');
    return http.Response('200', 200);
    // return http.post(
    //   Uri.parse(
    //       'https://jelly-backend.azurewebsites.net/api/v1/location/store'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, Object>{
    //     "userId": "Orest",
    //     "latitude": locationData.latitude,
    //     "longitude": locationData.longitude
    //   }),
    // );
  }

  Future<List<Friend>> getFriendsLocation() async {
    log('friends received');
    final response = await http.get(Uri.parse(
        'https://jelly-backend.azurewebsites.net/api/v1/location/all'));
    if (response.statusCode == 200) {
      var people = (json.decode(response.body) as List)
          .map((i) => Friend.fromJson(i))
          .toList();
      return people;
    }
    throw Exception('Failed to load album');
  }
}
