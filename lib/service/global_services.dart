import 'package:get/get.dart';
import 'package:project_jelly/service/auth_service.dart';
import 'package:project_jelly/service/location_service.dart';

import 'battery_service.dart';

class GlobalServices {
  static Future<void> init() async {
    await Get.putAsync(() async => await LocationService());
    await Get.putAsync(() async => await AuthService());
    await Get.putAsync(() async => await BatteryService().init());
  }
}
