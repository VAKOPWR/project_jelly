import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/request_service.dart';

class GlobalShakeController extends GetxController {
  var isShaking = false.obs;
  int lastShakeTimestamp = 0;
  int shakeCount = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> updateShakingState(bool shaking) async {
    isShaking.value = shaking;
    await Get.find<RequestService>().updateShakingStatus(shaking);

    if (shaking) {
      showShakingPopup();
    }
  }

  void showShakingPopup() {
    if (isShaking.isTrue) {
      if (FirebaseAuth.instance.currentUser != null) {
        if (Get.currentRoute != '/shake') {
          Get.toNamed('/shake');
        }
      }
    }
  }
}
