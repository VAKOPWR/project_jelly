import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project_jelly/logic/permissions.dart';

class PermissionsService extends GetxService {
  bool isInternetConnected = false;
  bool isLocationAccessGranted = true;

  @override
  Future<void> onInit() async {
    isInternetConnected = await InternetConnectionChecker().hasConnection;
    isLocationAccessGranted = await requestLocationPermission();
    super.onInit();
  }

  void internetConnectionChanged(bool newInternetConnectionStatus) {
    isInternetConnected = newInternetConnectionStatus;
  }

  void locationAccessChanged(bool newLocationAccessStatus) {
    isLocationAccessGranted = newLocationAccessStatus;
  }
}
