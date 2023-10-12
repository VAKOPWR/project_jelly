import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';

class LocationService extends GetxService {
  Position? _currentLocation;
  Stream<Position> locationStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  late StreamSubscription<Position> locationStreamSubscription;

  @override
  void onInit() async {
    super.onInit();
    Position? lastKnownLoc = await Geolocator.getLastKnownPosition();
    if (lastKnownLoc != null) {
      _currentLocation = lastKnownLoc;
    } else {
      Position(
          longitude: -122.0322,
          latitude: 37.3230,
          timestamp: DateTime.timestamp(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0);
    }
    // Location.onLocationChanged.listen(_updateCurrentLocation);
    // Location.
    // log(_currentLocation.onLocationChanged.isEmpty as String);
  }

  void startPositionStream() async {
    bool locationPermission = await requestLocationPermission();
    log('Stream is broadcast:');
    log(locationStream.isBroadcast.toString());
    if (locationPermission) {
      locationStreamSubscription = locationStream.listen(updateCurrentLocation);
    }
  }

  void pausePositionStream() async {
    log('Stopping stream subscription');
    if (!locationStreamSubscription.isPaused) {
      locationStreamSubscription.pause();
    }
  }

  void resumePositionStream() async {
    log('Resuming stream subscription');
    if (locationStreamSubscription.isPaused) {
      locationStreamSubscription.resume();
    }
  }

  void retriveCurrentLocation() async {
    bool locationPermission = await requestLocationPermission();
    if (locationPermission) {
      _currentLocation = await Geolocator.getCurrentPosition();
    }
  }

  Position? getCurrentLocation() {
    return _currentLocation;
  }

  void updateCurrentLocation(Position newLocation) async {
    log('Updating location');
    _currentLocation = newLocation;
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
    return List.empty();
    // throw Exception('Failed to load album');
  }
}
