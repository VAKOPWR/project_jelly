import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:http/http.dart' as http;
import 'package:project_jelly/service/map_service.dart';

class RequestService extends getx.GetxService {
  Dio dio = Dio();
  String ApiPath = "http://10.90.50.101/api/v1";

  void setupInterceptor(String? idToken) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          print('Request');
          if (isTokenExpired()) {
            idToken = await refreshToken();
            print('checking token');
          }
          options.headers['Authorization'] = idToken ?? '';
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
  }

  bool isTokenExpired() {
    return true;
  }

  Future<String?> refreshToken() async {
    String? idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
    return idToken;
  }

  Future<dynamic> createUser() async {
    try {
      print("${ApiPath}/user/create");
      Response response = await dio.post(
        "${ApiPath}/user/create",
        options: Options(
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<Uint8List> getUint8ListFromImageUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final Uint8List uint8List = response.bodyBytes;

      return uint8List;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<dynamic> putUserUpdate(Position locationData) async {
    try {
      String requestBody = json.encode({
        "latitude": locationData.latitude,
        "longitude": locationData.longitude,
        "speed": locationData.speed.toInt()
      });
      print(requestBody);
      Response response = await dio.put(
        "${ApiPath}/user/status/update",
        data: requestBody,
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<List<Friend>> getFriendsLocation() async {
    print('Getting friends location');
    try {
      Response response = await dio.get(
        "${ApiPath}/friend/statuses",
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        print(responseData);
        if (responseData is List) {
          var people = responseData.map((i) => Friend.fromJson(i)).toList();
          return people;
        } else {
          return List.empty();
        }
      }
      return List.empty();
    } catch (error) {
      print('Error: $error');
      return List.empty();
    }
  }

  Future<Map<String, Uint8List?>> getFriendsIcons() async {
    Map<String, Uint8List?> icons = {};
    try {
      print('User avatars');
      Response response = await dio.get(
        "${ApiPath}/friend/basic",
      );
      if (response.statusCode == 200) {
        var data = response.data;
        print(data);
        for (var icon in data) {
          icons[icon['id'].toString()] =
              await getUint8ListFromImageUrl(icon['profilePicture']);
          getx.Get.find<MapService>()
              .friendsData[MarkerId(icon['id'].toString())]!
              .isOnline = icon['isOnline'];
          getx.Get.find<MapService>()
              .friendsData[MarkerId(icon['id'].toString())]!
              .offlineStatus = '**';
        }
        return icons;
      }
      return icons;
    } catch (error) {
      print(error.toString());
      return icons;
    }
  }

  Future<Map<String, Uint8List?>> findFriend(String nickname) async {
    Map<String, Uint8List?> icons = {};
    try {
      Response response = await dio.get(
        "${ApiPath}/user/search/${nickname}",
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
      print(error.toString());
      return icons;
    }
  }

  Future<List<BasicUser>> getFriendsBasedOnEndpoint(String endpoint) async {
    try {
      Response response = await dio.get("${ApiPath}${endpoint}");
      if (response.statusCode == 200) {
        var data = response.data;
        return (data as List).map((item) => BasicUser.fromJson(item)).toList();
      } else {
        print('Failed to load friends from $endpoint');
        return List.empty();
      }
    } catch (error) {
      print('Error fetching friends from $endpoint: ${error.toString()}');
      return List.empty();
    }
  }

  Future<List<BasicUser>> searchFriends(String query) async {
    try {
      Response response = await dio.get("${ApiPath}/friend/search/$query");
      if (response.statusCode == 200) {
        var data = response.data;
        return (data as List).map((item) => BasicUser.fromJson(item)).toList();
      } else {
        print('Failed to search friends with query $query');
        return List.empty();
      }
    } catch (error) {
      print('Error searching friends with query $query: ${error.toString()}');
      return List.empty();
    }
  }

  Future<bool> acceptFriendRequest(String friendId) async {
    try {
      String url = '/friend/accept/$friendId';

      Response response = await dio.put("${ApiPath}${url}");

      if (response.statusCode == 200) {
        print('Friend request accepted');
        return true;
      } else {
        print(
            'Failed to accept friend request. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error accepting friend request: ${error.toString()}');
      return false;
    }
  }

  Future<bool> deleteFriend(int friendId) async {
    try {
      String url = '/friend/delete/$friendId';

      Response response = await dio.delete("${ApiPath}${url}");

      if (response.statusCode == 200) {
        print('Friend was successfully deleted');
        return true;
      } else {
        print('Failed to delete friend. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error deleting friend: ${error.toString()}');
      return false;
    }
  }

  Future<bool> declineFriendRequest(String friendId) async {
    try {
      String url = '/friend/decline/$friendId';

      Response response = await dio.put("${ApiPath}${url}");

      if (response.statusCode == 200) {
        print('Friend request accepted');
        return true;
      } else {
        print(
            'Failed to accept friend request. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error accepting friend request: ${error.toString()}');
      return false;
    }
  }

  Future<bool> sendFriendRequest(String identifier) async {
    try {
      String url = '/friend/invite/$identifier';
      Response response = await dio.post("${ApiPath}${url}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to send friend request. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending friend request: ${error.toString()}');
      return false;
    }
  }

  Future<bool> updateShakingStatus(bool isShaking) async {
    String endpoint = '/user/shaking/update/${isShaking ? 'true' : 'false'}';
    try {
      Response response = await dio.get("${ApiPath}${endpoint}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update the shaking status. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error updating shaking status: ${error.toString()}');
      return false;
    }
  }
}
