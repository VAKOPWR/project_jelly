import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/service/permissions_service.dart';
import 'package:project_jelly/service/location_service.dart';

class SnackbarService extends GetxService {
  bool isLocationSnackbarOpen = false;

  void checkLocationAccess() {
    requestLocationPermission().then((locationGranted) {
      if (!locationGranted) {
        Get.find<LocationService>().pausePositionStream();
        Get.find<PermissionsService>().locationAccessChanged(false);
        if (isLocationSnackbarOpen == false &&
            Get.find<PermissionsService>().isInternetConnected) {
          Get.closeCurrentSnackbar();
          Get.snackbar('No Location Avaliable',
              "Try modifying application permissions in the settings.",
              icon: Icon(Icons.location_disabled_rounded,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(days: 1),
              backgroundColor: Colors.red[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
          isLocationSnackbarOpen = true;
        }
      } else {
        Get.find<LocationService>().resumePositionStream();
        Get.find<PermissionsService>().locationAccessChanged(true);
        if (Get.find<PermissionsService>().isInternetConnected) {
          try {
            Get.closeCurrentSnackbar();
          } catch (LateInitializationError) {
            log('Nothing to close');
          }
        }
        isLocationSnackbarOpen = false;
      }
    });
  }

  void setLocationSnackbarStatus(bool newSnackbarStatus) {
    isLocationSnackbarOpen = newSnackbarStatus;
  }
}
