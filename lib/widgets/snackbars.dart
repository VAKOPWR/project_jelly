import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/service/location_service.dart';

void checkLocationAccess() {
  requestLocationPermission().then((locationGranted) {
    if (!locationGranted) {
      Get.find<LocationService>().pausePositionStream();
      Get.snackbar('No Location Avaliable',
          "Try modifying application permissions in the settings",
          icon: Icon(Icons.location_disabled_rounded,
              color: Colors.white, size: 35),
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
          duration: Duration(days: 1),
          backgroundColor: Colors.red[400],
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      Get.find<LocationService>().resumePositionStream();
      try {
        Get.closeAllSnackbars();
      } catch (LateInitializationError) {
        log('Nothing to close');
      }
    }
  });
}
