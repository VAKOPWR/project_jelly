import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/misc/backend_url.dart';

class LocationService extends GetxService {
  Position? _currentLocation;
  Stream<Position> locationStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
  StreamSubscription<Position>? locationStreamSubscription;
  Position defaultPosition = Position(
      longitude: -122.0322,
      latitude: 37.3230,
      timestamp: DateTime.timestamp(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  @override
  void onInit() async {
    super.onInit();
    requestLocationPermission().then((locationGranted) async {
      if (locationGranted) {
        Position? lastKnownLoc = await Geolocator.getLastKnownPosition();
        if (lastKnownLoc != null) {
          _currentLocation = lastKnownLoc;
        } else {
          _currentLocation = defaultPosition;
        }
      } else {
        _currentLocation = defaultPosition;
      }
    });
  }

  void startPositionStream() async {
    bool locationPermission = await requestLocationPermission();
    if (locationPermission) {
      locationStreamSubscription = locationStream.listen(updateCurrentLocation);
    }
  }

  void pausePositionStream() async {
    if (locationStreamSubscription != null) {
      if (!locationStreamSubscription!.isPaused) {
        locationStreamSubscription!.pause();
      }
    }
  }

  void resumePositionStream() async {
    if (locationStreamSubscription != null) {
      if (locationStreamSubscription!.isPaused) {
        locationStreamSubscription!.resume();
      }
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
    _currentLocation = newLocation;
  }

  Future<http.Response> sendLocation(Position locationData) async {
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    return http.put(
      Uri.parse('${getBackendUrl()}/user/location/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken!
      },
      body: jsonEncode(<String, Object>{
        "latitude": locationData.latitude,
        "longitude": locationData.longitude
      }),
    );
  }

  Future<List<Friend>> getFriendsLocation() async {
    final authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${getBackendUrl()}/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken!
      },
    );
    if (response.statusCode == 200) {
      var people = (json.decode(response.body) as List)
          .map((i) => Friend.fromJson(i))
          .toList();
      return people;
    }
    return List.empty();
  }
}
