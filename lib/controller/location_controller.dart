import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
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

  void _toggleSnackBar(dynamic error) {
    log('Permissiion denied');
    log(error.toString());
    Get.rawSnackbar(
        messageText: const Text(
          'Getting location...',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(
          Icons.location_disabled_rounded,
          color: Colors.white,
          size: 35,
        ),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: SnackPosition.TOP);
  }
}
