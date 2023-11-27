// ignore: unused_import
import 'dart:developer';

import 'package:get/get.dart';
import 'package:project_jelly/service/auth_service.dart';
import 'package:project_jelly/service/permissions_service.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/request_service.dart';
import 'package:project_jelly/service/snackbar_service.dart';
import 'package:project_jelly/service/style_service.dart';
import 'package:project_jelly/service/visibility_service.dart';

class GlobalServices {
  static Future<void> init() async {
    await Get.putAsync(() async => await MapService());
    await Get.putAsync(() async => await AuthService());
    await Get.putAsync(() async => await StyleService());
    await Get.putAsync(() async => await PermissionsService());
    await Get.putAsync(() async => await SnackbarService());
    await Get.put(VisibilitySevice());
  }
}
