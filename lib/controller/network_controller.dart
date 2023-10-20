// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:project_jelly/classes/overlay.dart';

// class NetworkController extends GetxController {
//   final Connectivity _connectivity = Connectivity();
//   bool isAlertSet = false;
//   bool isDeviceConnected = false;

//   @override
//   void onInit() {
//     super.onInit();
//     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> _updateConnectionStatus(
//       ConnectivityResult connectivityResult) async {
//     isDeviceConnected = await InternetConnectionChecker().hasConnection;
//     if (!isDeviceConnected && !isAlertSet) {
//       Get.dialog(
//         WifiOffOverlay(),
//         barrierDismissible: false,
//       );

//       isAlertSet = true;
//     } else {
//       isAlertSet = false;
//       Get.back();
//     }
//   }
// }

// // import 'dart:developer';

// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:internet_connection_checker/internet_connection_checker.dart';
// // import 'package:project_jelly/classes/overlay.dart';

// // class NetworkController extends GetxController {
// //   final Connectivity _connectivity = Connectivity();
// //   bool isAlertSet = false;
// //   bool isDeviceConnected = false;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
// //   }

// //   Future<void> _updateConnectionStatus(
// //       ConnectivityResult connectivityResult) async {
// //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
// //     if (!isDeviceConnected && !isAlertSet) {
// //       Get.snackbar('No Location Avaliable',
// //           "Try modifying application permissions in the settings",
// //           icon: Icon(Icons.location_disabled_rounded,
// //               color: Colors.white, size: 35),
// //           snackPosition: SnackPosition.TOP,
// //           duration: Duration(days: 1),
// //           backgroundColor: Colors.red[400],
// //           margin: EdgeInsets.zero,
// //           snackStyle: SnackStyle.GROUNDED);
// //       isAlertSet = true;
// //     } else {
// //       isAlertSet = false;
// //       try {
// //         Get.closeAllSnackbars();
// //       } catch (LateInitializationError) {
// //         log('Nothing to close');
// //       }
// //     }
// //   }
// // }
