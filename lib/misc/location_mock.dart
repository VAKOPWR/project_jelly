import 'dart:async';
import 'dart:math';
// import 'dart:developer' as dev;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';

class MockLocationService {
  late List<Friend> _friends;
  late final Random _random;

  MockLocationService() {
    _random = Random();

    _friends = [
      Friend(
          id: '1',
          name: 'Kseniia',
          avatar: 'assets/1.jpg',
          location: LatLng(51.1079, 17.0385),
          description: 'Welcome back',
          batteryPercentage: 81,
          movementSpeed: 3,
          isOnline: true,
          offlineStatus: ''),
      Friend(
          id: '2',
          name: 'Andrii',
          avatar: 'assets/andrii.jpeg',
          location: LatLng(51.1102, 17.0301),
          description: 'See ya!!',
          batteryPercentage: 54,
          movementSpeed: 29,
          isOnline: false,
          offlineStatus: '3h'),
      Friend(
          id: '3',
          name: 'Orest',
          avatar: 'null',
          location: LatLng(51.1045, 17.0458),
          description: 'Sup',
          batteryPercentage: 18,
          movementSpeed: 3,
          isOnline: false,
          offlineStatus: '21h'),
    ];
  }

  Future<List<Friend>> getFriendsLocation() async {
    _friends.forEach((friend) {
      double latitude =
          friend.location.latitude + (_random.nextDouble() - 0.5) * 0.001;
      double longitude =
          friend.location.longitude + (_random.nextDouble() - 0.5) * 0.001;
      friend.location = LatLng(latitude, longitude);
      friend.batteryPercentage = _random.nextInt(100);
      friend.movementSpeed = _random.nextInt(50);
    });
    return _friends;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Map<String, Uint8List?>> getFriendsIcons() async {
    Map<String, Uint8List?> icons = {};
    for (var friend in _friends) {
      if (friend.avatar == 'null') {
        icons[friend.id] = null;
      } else {
        icons[friend.id] = await getBytesFromAsset(friend.avatar, 150);
      }
    }
    return icons;
  }
}
