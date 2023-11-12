import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project_jelly/service/permissions_service.dart';
import 'package:project_jelly/service/snackbar_service.dart';

class InternetCheckerBanner {
  late StreamSubscription listen;
  StreamSubscription initialize({String title = "No internet!"}) {
    listen = InternetConnectionChecker().onStatusChange.listen((event) {
      Get.find<SnackbarService>().setLocationSnackbarStatus(false);
      if (event == InternetConnectionStatus.connected) {
        Get.find<PermissionsService>().internetConnectionChanged(true);
        try {
          Get.closeCurrentSnackbar();
        } catch (LateInitializationError) {
          debugPrint('Nothing to close');
        }
        Get.find<SnackbarService>().checkLocationAccess();
      } else {
        debugPrint("No internet!");
        Get.find<PermissionsService>().internetConnectionChanged(false);
        Get.closeCurrentSnackbar();
        Get.snackbar(
            title, "No internet connection found. Check your connection",
            icon: Icon(Icons.wifi_off_rounded, color: Colors.white, size: 35),
            snackPosition: SnackPosition.TOP,
            isDismissible: false,
            duration: Duration(days: 1),
            backgroundColor: Colors.red[400],
            margin: EdgeInsets.zero,
            snackStyle: SnackStyle.GROUNDED);
      }
    });
    return listen;
  }

  void dispose() {
    listen.cancel();
  }
}
