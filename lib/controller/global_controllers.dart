import 'package:get/get.dart';
// import 'package:project_jelly/controller/location_controller.dart';
import 'package:project_jelly/controller/network_controller.dart';

class GlobalControllers {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    // Get.put<LocationController>(LocationController(), permanent: true);
  }
}
