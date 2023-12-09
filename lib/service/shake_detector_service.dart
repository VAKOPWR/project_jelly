import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:project_jelly/controller/global_shake_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService extends GetxService {
  Future<ShakeDetectorService> init() async {
    accelerometerEvents.listen(handleAccelerometerEvent);
    return this;
  }

  void handleAccelerometerEvent(AccelerometerEvent event) {
    final double shakeThresholdGravity = 2.7;
    final int shakeSlopTimeMS = 500;
    final int shakeCountResetTime = 3000;

    double gForce =
        math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z) /
            9.81;

    var now = DateTime.now().millisecondsSinceEpoch;
    if (gForce > shakeThresholdGravity) {
      if (Get.find<GlobalShakeController>().lastShakeTimestamp +
              shakeSlopTimeMS <
          now) {
        Get.find<GlobalShakeController>().lastShakeTimestamp = now;
        Get.find<GlobalShakeController>().shakeCount++;
      }
    }

    if (Get.find<GlobalShakeController>().lastShakeTimestamp +
            shakeCountResetTime <
        now) {
      Get.find<GlobalShakeController>().shakeCount = 0;
    }

    if (Get.find<GlobalShakeController>().shakeCount >= 2) {
      Get.find<GlobalShakeController>().shakeCount = 0;
      Get.find<GlobalShakeController>().lastShakeTimestamp = now;
      bool detectedShake = true;

      if (detectedShake) {
        Get.find<GlobalShakeController>().updateShakingState(true);
      }
    }
  }
}
