import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';

class MockLocationService {
  late List<Friend> _friends;
  late int _currentIndex;
  late final Random _random;

  MockLocationService() {
    _random = Random();
    _currentIndex = 0;

    // Initial locations for three friends in Wroclaw
    _friends = [
      Friend(
          id: '1',
          name: 'Viktor',
          avatar: '',
          location: LatLng(51.1079, 17.0385)),
      Friend(
          id: '2',
          name: 'Andrii',
          avatar: '',
          location: LatLng(51.1102, 17.0301)),
      Friend(
          id: '3',
          name: 'Orest',
          avatar: '',
          location: LatLng(51.1045, 17.0458)),
    ];
  }

  Future<List<Friend>> getFriendsLocation() async {
    _friends.forEach((friend) {
      double latitude = friend.location.latitude +
          (_random.nextDouble() - 0.5) * 0.001; // +/- 0.0005 degrees
      double longitude = friend.location.longitude +
          (_random.nextDouble() - 0.5) * 0.001; // +/- 0.0005 degrees
      friend.location = LatLng(latitude, longitude);
    });

    return _friends;
  }
}
