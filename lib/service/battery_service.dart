import 'package:battery/battery.dart';
import 'package:get/get.dart';

class BatteryService extends GetxService {
  final Battery _battery = Battery();
  final RxInt _batteryLevel = 0.obs;

  int get batteryLevel => _batteryLevel.value;

  Future<BatteryService> init() async {
    _batteryLevel.value = await _battery.batteryLevel;
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      updateBatteryLevel();
    });
    return this;
  }

  Future<void> updateBatteryLevel() async {
    final level = await _battery.batteryLevel;
    _batteryLevel.value = level;
  }
}
