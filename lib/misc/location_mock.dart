import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';

class MockLocationService {
  late List<Friend> _friends;
  late final Random _random;

  MockLocationService() {
    _random = Random();

    // Initial locations for three friends in Wroclaw
    _friends = [
      Friend(
          id: '1',
          name: 'Viktor',
          avatar: 'assets/N01.png',
          location: LatLng(51.1079, 17.0385)),
      Friend(
          id: '2',
          name: 'Andrii',
          avatar: 'assets/N02.png',
          location: LatLng(51.1102, 17.0301)),
      Friend(
          id: '3',
          name: 'Orest',
          avatar: 'assets/N03.png',
          location: LatLng(51.1045, 17.0458)),
    ];
  }

  Future<List<Friend>> getFriendsLocation() async {
    _friends.forEach((friend) {
      double latitude =
          friend.location.latitude + (_random.nextDouble() - 0.5) * 0.001;
      double longitude =
          friend.location.longitude + (_random.nextDouble() - 0.5) * 0.001;
      friend.location = LatLng(latitude, longitude);
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

  Future<Map<String, Uint8List>> getFriendsIcons() async {
    Map<String, Uint8List> icons = {};
    for (var friend in _friends) {
      icons[friend.id] = await getBytesFromAsset(friend.avatar, 100);
    }
    return icons;
  }
}
