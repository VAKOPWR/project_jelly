import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StyleService extends GetxService {
  Future loadMapStyles() async {
    var _darkMapStyle = GetStorage().read('darkMapStyle');
    _darkMapStyle = null;
    if (_darkMapStyle == null) {
      String darkMapStyle =
          await rootBundle.loadString('assets/map/dark_map_v2.json');
      GetStorage().write('darkMapStyle', darkMapStyle);
    }
    GetStorage().write('lightMapStyle', null);
    var _lightMapStyle = GetStorage().read('lightMapStyle');
    if (_lightMapStyle == null) {
      String lightMapStyle =
          await rootBundle.loadString('assets/map/light_map.json');
      GetStorage().write('lightMapStyle', lightMapStyle);
    }
  }
}
