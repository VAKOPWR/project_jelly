import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/misc/image_modifier.dart';
import 'package:project_jelly/misc/uint8list_image.dart';
import 'package:project_jelly/service/request_service.dart';

// TODO: Add optimization logic
class MapService extends GetxService {
  Position? _currentLocation;
  DateTime? lastUpdate;
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
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0);
  Uint8List? defaultAvatar;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Friend> friendsData = <MarkerId, Friend>{};
  Map<MarkerId, Uint8List> avatars = <MarkerId, Uint8List>{};
  Map<MarkerId, ImageProvider> imageProviders = <MarkerId, ImageProvider>{};
  bool requestSent = false;
  int locationPerception = 2;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> prepareService() async {
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
    await loadDefaultAvatar();
    if (FirebaseAuth.instance.currentUser != null) {
      await fetchFriendsData();
      await loadCustomAvatars();
      await loadImageProviders();
      await updateMarkers();
    }
    Timer.periodic(Duration(minutes: 30), (timer) async {
      if (FirebaseAuth.instance.currentUser != null) {
        await loadCustomAvatars();
        await loadImageProviders();
      }
    });
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
    DateTime now = DateTime.now();
    if (lastUpdate == null ||
        now.difference(lastUpdate!) > Duration(seconds: locationPerception)) {
      Get.find<RequestService>().putUserUpdate(newLocation);
      lastUpdate = now;
    }
  }

  Future<void> loadDefaultAvatar() async {
    defaultAvatar = await getBytesFromAsset('assets/no_avatar.png', 150);
  }

  Future<void> loadCustomAvatars() async {
    Map<String, Uint8List?> friendsAvatars =
        await Get.find<RequestService>().getFriendsIcons();
    for (var avatar in friendsAvatars.entries) {
      String key = avatar.key;
      Uint8List? value = avatar.value;
      if (value != null) {
        avatars[MarkerId(key)] = await modifyImage(
            value,
            Colors.red,
            friendsData[MarkerId(key)]!.isOnline ?? false,
            friendsData[MarkerId(key)]!.offlineStatus ?? '**');
      } else {
        avatars[MarkerId(key)] = await modifyImage(
            defaultAvatar!,
            Colors.red,
            friendsData[MarkerId(key)]!.isOnline ?? false,
            friendsData[MarkerId(key)]!.offlineStatus ?? '**');
      }
    }
  }

  Future<void> loadImageProviders() async {
    for (var avatar in avatars.entries) {
      MarkerId key = avatar.key;
      Uint8List? value = avatar.value;
      imageProviders[key] = await Uint8ListImageProvider(value);
    }
    for (MarkerId friendId in friendsData.keys) {
      if (!imageProviders.containsKey(friendId)) {
        imageProviders[friendId] = await Uint8ListImageProvider(
            await modifyImage(
                defaultAvatar!,
                Colors.red,
                friendsData[friendId]!.isOnline ?? false,
                friendsData[friendId]!.offlineStatus ?? '**'));
      }
    }
  }

  Marker _createMarker(Friend friend) {
    return Marker(
        markerId: MarkerId(friend.id),
        position: friend.location,
        infoWindow: InfoWindow(
          title: friend.name,
        ),
        icon: avatars[MarkerId(friend.id)] != null
            ? BitmapDescriptor.fromBytes(avatars[MarkerId(friend.id)]!)
            : BitmapDescriptor.fromBytes(defaultAvatar!));
  }

  Future<void> fetchFriendsData() async {
    List<Friend> friendsLocations =
        await Get.find<RequestService>().getFriendsLocation();
    for (Friend friend in friendsLocations) {
      friendsData[MarkerId(friend.id)] = friend;
    }
  }

  Future<void> updateMarkers() async {
    List<MarkerId> friendIDs = avatars.keys.toList();
    for (var friend in friendsData.entries) {
      if (!friendIDs.contains(friend.key)) {
        await loadCustomAvatars();
      }
      markers[friend.key] = _createMarker(friend.value);
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
