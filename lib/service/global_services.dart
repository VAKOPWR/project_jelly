import 'package:get/get.dart';
import 'package:project_jelly/service/location_service.dart';

class GlobalServices {
  static Future<void> init() async {
    await Get.putAsync(() async => await LocationService());
  }
}
