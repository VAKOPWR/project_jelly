// ignore: unused_import
import 'dart:developer';

import 'package:get/get.dart';
import 'package:project_jelly/service/auth_service.dart';
import 'package:project_jelly/service/permissions_service.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/service/snackbar_service.dart';
import 'package:project_jelly/service/style_service.dart';

class GlobalServices {
  static Future<void> init() async {
    await Get.putAsync(() async => await LocationService());
    // await Get.putAsync(() async => await AuthService());
    await Get.putAsync(() async => await StyleService());
    await Get.putAsync(() async => await PermissionsService());
    await Get.putAsync(() async => await SnackbarService());
  }
}
