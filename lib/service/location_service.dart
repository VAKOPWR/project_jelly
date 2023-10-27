import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/misc/backend_url.dart';
import 'package:project_jelly/misc/location_mock.dart';

class LocationService extends GetxService {
  Position? _currentLocation;
  Stream<Position> locationStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
  StreamSubscription<Position>? _locationStreamSubscription;
  Position _defaultPosition = Position(
      longitude: -122.0322,
      latitude: 37.3230,
      timestamp: DateTime.timestamp(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  BitmapDescriptor? _defaultAvatar;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, BitmapDescriptor> avatars = <MarkerId, BitmapDescriptor>{};
  MockLocationService _locationService = MockLocationService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await requestLocationPermission().then((locationGranted) async {
      if (locationGranted) {
        Position? lastKnownLoc = await Geolocator.getLastKnownPosition();
        if (lastKnownLoc != null) {
          _currentLocation = lastKnownLoc;
        } else {
          _currentLocation = _defaultPosition;
        }
      } else {
        _currentLocation = _defaultPosition;
      }
    });
    await loadCustomAvatars();
    await loadDefaultAvatar();
    await updateMarkers();
  }

  void startPositionStream() async {
    bool locationPermission = await requestLocationPermission();
    if (locationPermission) {
      _locationStreamSubscription =
          locationStream.listen(updateCurrentLocation);
    }
  }

  void pausePositionStream() async {
    if (_locationStreamSubscription != null) {
      if (!_locationStreamSubscription!.isPaused) {
        _locationStreamSubscription!.pause();
      }
    }
  }

  void resumePositionStream() async {
    if (_locationStreamSubscription != null) {
      if (_locationStreamSubscription!.isPaused) {
        _locationStreamSubscription!.resume();
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

  Future<void> loadDefaultAvatar() async {
    _defaultAvatar = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)), 'assets/N01.png');
  }

  Future<void> loadCustomAvatars() async {
    Map<String, Uint8List> friendsAvatars =
        await _locationService.getFriendsIcons();
    friendsAvatars.forEach((key, value) {
      avatars[MarkerId(key)] = BitmapDescriptor.fromBytes(value);
    });
  }

  Marker _createMarker(Friend friend) {
    return Marker(
        markerId: MarkerId(friend.id),
        position: friend.location,
        infoWindow: InfoWindow(
          title: friend.name,
        ),
        icon: avatars[MarkerId(friend.id)] ?? _defaultAvatar!);
  }

  Future<void> updateMarkers() async {
    List<Friend> friendsLocation = await _locationService.getFriendsLocation();
    for (Friend friend in friendsLocation) {
      markers[MarkerId(friend.id)] = _createMarker(friend);
    }
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
