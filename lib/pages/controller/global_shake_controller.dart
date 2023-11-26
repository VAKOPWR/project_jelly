import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/friend.dart';

class GlobalShakeController extends GetxController {
  var isShaking = false.obs;
  List<Friend> shakingFriends = [];
  int lastShakeTimestamp = 0;
  int shakeCount = 0;

  @override
  void onInit() {
    super.onInit();
    shakingFriends = _generateFakeShakingFriends();
  }

  void updateShakingState(bool shaking) {
    isShaking.value = shaking;
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

  List<Friend> _generateFakeShakingFriends() {
    return List<Friend>.generate(
        3,
            (int index) => Friend(
            id: (index + 1).toString(),
            name: 'Friend $index',
            avatar: 'assets/andrii.jpeg',
            location: LatLng(37.4219999, -122.0840575),
            batteryPercentage: index,
            movementSpeed: index,
            isOnline: true,
            offlineStatus: ''));
  }
}
