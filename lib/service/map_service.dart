import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/misc/image_modifier.dart';
import 'package:project_jelly/misc/uint8list_image.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/service/visibility_service.dart';

// TODO: Add optimization logic
class MapService extends GetxService {
  Position? _currentLocation;
  DateTime? lastPositionUpdate;
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
  ImageProvider? defaultImageProvider;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, BitmapDescriptor> staticMarkerIcons =
      <MarkerId, BitmapDescriptor>{};
  Map<MarkerId, Uint8List> staticImages = <MarkerId, Uint8List>{};
  Map<MarkerId, Friend> friendsData = <MarkerId, Friend>{};
  Map<String, List<String>> staticMarkerTypeId = <String, List<String>>{};
  Map<MarkerId, Uint8List> avatars = <MarkerId, Uint8List>{};
  Map<MarkerId, ImageProvider> imageProviders = <MarkerId, ImageProvider>{};
  Map<String, bool> ghostedFriends = <String, bool>{};
  List<BasicUser> pendingFriends = <BasicUser>[];
  Map<MarkerId, LatLng> targetPoints = <MarkerId, LatLng>{};
  final box = GetStorage();
  bool requestSent = false;
  int locationPerception = 2;
  int nearPointThreshold = 50;
  int nearPointUpdateFrequency = 30;

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
    await loadStaticImages();
    await loadDefaultAvatar();
    await loadStaticMarkers();
    await loadDefaultImageProvider();
    if (FirebaseAuth.instance.currentUser != null) {
      // TODO: Add ping request verification
      await fetchFriendsData();
      await loadCustomAvatars();
      await loadImageProviders();
      await updateMarkers();
      await fetchPendingFriends();
    }
    Timer.periodic(Duration(minutes: 30), (timer) async {
      if (FirebaseAuth.instance.currentUser != null) {
        await loadCustomAvatars();
        await loadImageProviders();
      }
    });
    readStaticMarkersData();
    readGhostedFriends();
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

    bool nearAnyPoint = targetPoints.entries.any((targetPoint) {
      double distanceToTarget = calculateDistance(
        newLocation.latitude,
        newLocation.longitude,
        targetPoint.value.latitude,
        targetPoint.value.longitude,
      );
      return distanceToTarget <= nearPointThreshold;
    });

    if (nearAnyPoint) {
      if (lastPositionUpdate == null ||
          now.difference(lastPositionUpdate!) >
              Duration(minutes: nearPointUpdateFrequency)) {
        if (FirebaseAuth.instance.currentUser != null) {
          Get.find<RequestService>().putUserUpdate(newLocation);
        }
        lastPositionUpdate = now;
      }
    } else {
      if (lastPositionUpdate == null ||
          now.difference(lastPositionUpdate!) >
              Duration(seconds: locationPerception)) {
        if (FirebaseAuth.instance.currentUser != null) {
          Get.find<RequestService>().putUserUpdate(newLocation);
        }
        lastPositionUpdate = now;
      }
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371000;

    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (3.141592653589793 / 180)) *
            cos(lat2 * (3.141592653589793 / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  Future<void> loadStaticImages() async {
    staticImages[MarkerId('Home')] =
        await getBytesFromAsset("assets/markers/home.png", 150);
    staticImages[MarkerId('Work')] =
        await getBytesFromAsset("assets/markers/work.png", 150);
    staticImages[MarkerId('School')] =
        await getBytesFromAsset("assets/markers/education.png", 150);
    staticImages[MarkerId('Shop')] =
        await getBytesFromAsset("assets/markers/shop.png", 150);
    staticImages[MarkerId('Gym')] =
        await getBytesFromAsset("assets/markers/gym.png", 150);
    staticImages[MarkerId('Favorite')] =
        await getBytesFromAsset("assets/markers/favorite.png", 150);
  }

  Future<void> loadStaticMarkers() async {
    staticMarkerIcons[MarkerId('Home')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('Home')]!);
    staticMarkerIcons[MarkerId('Work')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('Work')]!);
    staticMarkerIcons[MarkerId('School')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('School')]!);
    staticMarkerIcons[MarkerId('Shop')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('Shop')]!);
    staticMarkerIcons[MarkerId('Gym')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('Gym')]!);
    staticMarkerIcons[MarkerId('Favorite')] =
        BitmapDescriptor.fromBytes(staticImages[MarkerId('Favorite')]!);
  }

  Future<void> loadDefaultAvatar() async {
    defaultAvatar = await getBytesFromAsset('assets/no_avatar.png', 150);
  }

  Future<void> loadDefaultImageProvider() async {
    defaultImageProvider = Uint8ListImageProvider(defaultAvatar!);
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
            friendsData[MarkerId(key)]!.isOnline,
            friendsData[MarkerId(key)]!.offlineStatus);
      } else {
        avatars[MarkerId(key)] = await modifyImage(
            defaultAvatar!,
            friendsData[MarkerId(key)]!.isOnline,
            friendsData[MarkerId(key)]!.offlineStatus);
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
            await modifyImage(defaultAvatar!, friendsData[friendId]!.isOnline,
                friendsData[friendId]!.offlineStatus));
      }
    }
  }

  Marker _createMarker(Friend friend) {
    return Marker(
        markerId: MarkerId(friend.id),
        position: friend.location,
        icon: avatars[MarkerId(friend.id)] != null
            ? BitmapDescriptor.fromBytes(avatars[MarkerId(friend.id)]!)
            : BitmapDescriptor.fromBytes(defaultAvatar!),
        onTap: () {
          Get.find<VisibilityService>().isInfoSheetVisible = true;
          if (Get.find<VisibilityService>().isBottomSheetOpen) {
            Get.find<VisibilityService>().isInfoSheetVisible = false;
          }
          Get.find<VisibilityService>().highlightedMarker = MarkerId(friend.id);
          Get.find<VisibilityService>().highlightedMarkerType = null;
        });
  }

  Future<void> fetchFriendsData() async {
    List<Friend> friendsLocations =
        await Get.find<RequestService>().getFriendsLocation();
    Map<MarkerId, Friend> newFriendsData = {};
    for (Friend friend in friendsLocations) {
      newFriendsData[MarkerId(friend.id)] = friend;
    }
    friendsData.clear();
    friendsData = newFriendsData;
  }

  Future<void> updateMarkers() async {
    Map<MarkerId, Marker> newMarkers = {};
    List<MarkerId> friendIDs = avatars.keys.toList();
    for (var friend in friendsData.entries) {
      if (!friendIDs.contains(friend.key)) {
        await loadCustomAvatars();
        await loadImageProviders();
      }
      newMarkers[friend.key] = _createMarker(friend.value);
    }
    markers.clear();
    markers = newMarkers;
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

  Future<void> fetchPendingFriends() async {
    List<BasicUser> _pendingFriends = await Get.find<RequestService>()
        .getFriendsBasedOnEndpoint('/friend/pending');
    pendingFriends = _pendingFriends;
  }

  String markerToJson(Marker marker) {
    return "{\"id\": \"${marker.markerId.value}\",\"latitude\": ${marker.position.latitude},\"longitude\": ${marker.position.longitude}}";
  }

  String markersToJson(Map<MarkerId, Marker> staticMarkers) {
    String result = '[';
    for (Marker marker in staticMarkers.values) {
      result += markerToJson(marker);
      result += ',';
    }
    if (result.endsWith(',')) {
      result = result.substring(0, result.length - 1);
    }
    result += ']';
    return result;
  }

  void addStaticMarkerTypeId(String markerType, String newMarkerName) {
    if (staticMarkerTypeId.containsKey(markerType)) {
      staticMarkerTypeId[markerType]!.add(newMarkerName);
    } else {
      staticMarkerTypeId[markerType] = [newMarkerName];
    }
  }

  void writeStaticMarkersData(Map<MarkerId, Marker> staticMarkers) {
    String _markers = markersToJson(staticMarkers);
    box.write('staticMarkers', _markers);
    box.write('staticMarkerTypeId', staticMarkerTypeId);
  }

  void addStaticPoint(Marker newPoint) {
    targetPoints[newPoint.markerId] = newPoint.position;
  }

  void deleteStaticPoint(MarkerId markerId) {
    if (targetPoints.containsKey(markerId)) {
      targetPoints.remove(markerId);
    }
  }

  void readStaticMarkersData() {
    Map<String, dynamic>? _markerTypeId = box.read('staticMarkerTypeId');
    if (_markerTypeId != null) {
      staticMarkerTypeId = Map<String, List<String>>.from(_markerTypeId.map(
          (key, value) => MapEntry<String, List<String>>(
              key, (value as List<dynamic>).cast<String>())));
    }
  }

  void updateFriendGhostStatus(String friendId, bool newGhostedState) {
    ghostedFriends[friendId] = newGhostedState;
    box.write('ghostedFriends', ghostedFriends);
  }

  void readGhostedFriends() {
    Map<String, dynamic>? _ghostedFriends = box.read('ghostedFriends');
    if (_ghostedFriends != null) {
      ghostedFriends = _ghostedFriends.cast<String, bool>();
    }
  }
}
