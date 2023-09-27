import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestGalleryPermission() async {
  final status = await Permission.storage.status;

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    final result = await Permission.storage.request();

    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    return false;
  }
}

Future<bool> requestContactsPermission() async {
  final status = await Permission.contacts.status;
  log((status.isDenied).toString());

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    final result = await Permission.contacts.request();

    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    return false;
  }
}

Future<bool> requestLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // return Future.error("Location services are disabled.");
    log("Location services are disabled.");
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // return Future.error("Location permission are denied");
      log("Location permission are denied");
      return false;
    } else {
      log("Location permission are granted");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // return Future.error("Location permission are permanently denied");
    log("Location permission are permanently denied");
    return false;
  }
  LocationAccuracyStatus accuracyStatus =
      await Geolocator.getLocationAccuracy();
  if (accuracyStatus == LocationAccuracyStatus.precise) {
    log("Percise location accuracy is granted");
    return true;
  } else {
    log("Wrong location accuracy granted");
    return false;
  }
}
