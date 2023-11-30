import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VisibilityService extends GetxService {
  bool isInfoSheetVisible = false;
  bool isBottomSheetOpen = false;
  MarkerId? highlightedMarker = null;
  String? highlightedMarkerType = null;
}
