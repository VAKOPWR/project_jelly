import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:http/http.dart' as http;

class RequestService extends getx.GetxService {
  Dio dio = Dio();
  String ApiPath = "/api/v1";

  String getBackendUrl() {
    return "http://jelly-backend.azurewebsites.net${ApiPath}";
  }

  void setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          options.headers['Authorization'] =
              await FirebaseAuth.instance.currentUser!.getIdToken();
          options.headers['Content-Type'] = 'application/json; charset=UTF-8';
          return handler.next(options);
        },
      ),
    );
  }

  Future<Uint8List> getUint8ListFromImageUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Decode the image bytes
      final Uint8List uint8List = response.bodyBytes;

      return uint8List;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<dynamic> postUserLocation(Position locationData) async {
    try {
      Map<String, dynamic> requestBody = {
        "latitude": locationData.latitude,
        "longitude": locationData.longitude
      };
      Response response = await dio.post(
        '${getBackendUrl}/post-endpoint',
        data: requestBody,
      );
      return response.statusCode;
    } catch (error) {
      log(error as String);
    }
  }

  Future<List<Friend>> getFriendsLocation() async {
    try {
      Response response = await dio.get(
        '${getBackendUrl}/get-endpoint',
      );
      if (response.statusCode == 200) {
        var people = (json.decode(response.data) as List)
            .map((i) => Friend.fromJson(i))
            .toList();
        return people;
      }
      return List.empty();
    } catch (error) {
      log(error as String);
      return List.empty();
    }
  }

  Future<Map<String, Uint8List?>> getFriendsIcons() async {
    Map<String, Uint8List?> icons = {};
    try {
      Response response = await dio.get(
        '${getBackendUrl}/get-endpoint',
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.data) as List;
        for (var icon in data) {
          icons[icon['id']] = await getUint8ListFromImageUrl(icon['icon']);
        }
        return icons;
      }
      return icons;
    } catch (error) {
      log(error as String);
      return icons;
    }
  }
}
