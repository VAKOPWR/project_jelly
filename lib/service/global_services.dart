// ignore: unused_import
import 'dart:developer';

import 'package:get/get.dart';
import 'package:project_jelly/service/auth_service.dart';

class GlobalServices {
  static Future<void> init() async {
    await Get.putAsync(() async => await AuthService());
  }
}
