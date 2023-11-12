import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/service/permissions_service.dart';

Future<String> getCityNameFromCoordinates(
    LatLng coordinates, double zoom) async {
  if (Get.find<PermissionsService>().isInternetConnected == false) {
    return "The Earth";
  }
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      if (zoom > 8) {
        if (placemark.locality != null) {
          if (placemark.locality!.length > 12) {
            return placemark.locality!.substring(0, 12) + '...';
          } else {
            return placemark.locality!;
          }
        } else {
          return "Middle of Nowhere";
        }
      } else if (zoom > 6) {
        if (placemark.country != null) {
          if (placemark.country!.length > 12) {
            return placemark.country!.substring(0, 12) + '...';
          } else {
            return placemark.country!;
          }
        } else {
          return "Middle of Nowhere";
        }
      } else {
        return "The Earth";
      }
    } else {
      return "Middle of Nowhere";
    }
  } on PlatformException {
    return "The Earth";
  }
}
