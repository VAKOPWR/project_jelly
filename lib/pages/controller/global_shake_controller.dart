import 'package:get/get.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/request_service.dart';

class GlobalShakeController extends GetxController {
  var isShaking = false.obs;
  List<BasicUser> shakingFriends = [];
  int lastShakeTimestamp = 0;
  int shakeCount = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    shakingFriends = await Get.find<RequestService>()
        .getFriendsBasedOnEndpoint('/user/nearby');
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
      if (Get.currentRoute != '/shake') {
        Get.toNamed('/shake');
      }
    }
  }
}
