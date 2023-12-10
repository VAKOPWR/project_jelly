import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:battery/battery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/classes/chat.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:http/http.dart' as http;
import 'package:project_jelly/classes/message.dart';
import 'package:project_jelly/misc/stealth_choice.dart';
import 'package:project_jelly/service/map_service.dart';

import '../classes/chat_DTO.dart';

class RequestService extends getx.GetxService {
  Dio dio = Dio();
  String ApiPath = "http://10.90.50.101/api/v1";
  DateTime? lastBatteryUpdate;
  Battery battery = Battery();
  int batteryLevel = 100;

  void setupInterceptor(String? idToken) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          if (isTokenExpired()) {
            idToken = await refreshToken();
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
      Response response = await dio.post(
        "${ApiPath}/user/create",
        options: Options(
          receiveTimeout: Duration(seconds: 5),
        ),
      );
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
    DateTime now = DateTime.now();
    if (lastBatteryUpdate == null ||
        now.difference(lastBatteryUpdate!) > Duration(minutes: 5)) {
      batteryLevel = await battery.batteryLevel;
    }
    try {
      String requestBody = json.encode({
        "latitude": locationData.latitude,
        "longitude": locationData.longitude,
        "speed": locationData.speed.toInt(),
        "batteryLevel": batteryLevel
      });
      Response response = await dio.put(
        "${ApiPath}/user/status/update",
        data: requestBody,
      );
      return response.statusCode;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<List<Friend>> getFriendsLocation() async {
    try {
      Response response = await dio.get(
        "${ApiPath}/friend/statuses",
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
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
      Response response = await dio.get(
        "${ApiPath}/friend/online",
      );
      if (response.statusCode == 200) {
        var data = response.data;
        for (var icon in data) {
          icons[icon['id'].toString()] =
              await getUint8ListFromImageUrl(icon['profilePicture']);
          getx.Get.find<MapService>()
              .friendsData[MarkerId(icon['id'].toString())]!
              .isOnline = icon['isOnline'];
          getx.Get.find<MapService>()
              .friendsData[MarkerId(icon['id'].toString())]!
              .offlineStatus = icon['lastOnline'];
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
      String url = '/friend/delete/$friendId';

      Response response = await dio.delete("${ApiPath}${url}");

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
      Response response = await dio.put("${ApiPath}${endpoint}");
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

  Future<bool> updateStealthChoiceOnUserLevel(
      StealthChoice userStealthChoice) async {
    String endpoint = '/user/ghost/update/${userStealthChoice.name}';
    try {
      Response response = await dio.put("${ApiPath}${endpoint}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update the steath choice status on user level. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print(
          'Error updating steath choice status on user level: ${error.toString()}');
      return false;
    }
  }

  Future<bool> updateStealthChoiceOnRelationshipLevel(
      String idFriendWhoWillBeInGhostMode,
      StealthChoice friendStealthChoice) async {
    String endpoint =
        '/friend/ghost/update/${idFriendWhoWillBeInGhostMode}/${friendStealthChoice.name}';
    try {
      Response response = await dio.put("${ApiPath}${endpoint}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update the steath choice status on relationship level. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print(
          'Error updating steath choice status on relationship level: ${error.toString()}');
      return false;
    }
  }

  Future<List<ChatDTO>> loadChatsRequest() async{
    String endpoint = '/chats';
    print("${ApiPath}${endpoint}");

    try{
      Response response = await dio.get("${ApiPath}${endpoint}");
      if (response.statusCode == 200){
        var data = response.data;
        print(data);
        return (data as List).map((item) => ChatDTO.fromJson(item)).toList();
      }
      else {
        print('Error loading chats. Status code: ${response.statusCode}');
        return List.empty();
      }
    }
    catch (error){
      print('Error loading chats: ${error.toString()}');
      return List.empty();
    }
  }

  Future<List<Message>> loadNewMessages() async {
    String endpoint = '/chats/message/new/';

    print(Get.find<MapService>().messagesLastChecked.toIso8601String());
    print(Get.find<MapService>().chats.keys.toList());
    try {
      Response response = await dio.post(
        "${ApiPath}${endpoint}${Get.find<MapService>().messagesLastChecked.toIso8601String()}",
        data: {
          'groupIds': Get.find<MapService>().chats.keys.toList(),
        },
      );
      if (response.statusCode == 200) {
        var data = response.data;
        return (data as List).map((item) => Message.fromJson(item)).toList();
      } else {
        print('Error loading messages. Status code: ${response.statusCode}');
        return List.empty();
      }
    } catch (error) {
      print('Error loading messages: ${error.toString()}');
      return List.empty();
    }
  }


  Future<List<Message>> loadMessagesPaged(Long groupId, int page) async {
    String endpoint = '/chats/loadMessagesPaged';

    try {
      String url = "${ApiPath}${endpoint}?groupId=${groupId}&page=${page}";

      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        var data = response.data;
        return (data as List).map((item) => Message.fromJson(item)).toList();
      } else {
        print('Error loading messages. Status code: ${response.statusCode}');
        return List.empty();
      }
    } catch (error) {
      print('Error loading messages: ${error.toString()}');
      return List.empty();
    }
  }

  Future<bool> sendMessage(int chatId, String text) async{
    String endpoint = '/chats/message';

    try {
      String url = "${ApiPath}${endpoint}";

      print(url);

      Map<String, dynamic> queryData = {
        'groupId': chatId,
        'senderId': Get.find<MapService>().currUserId,
        'text': text,
      };

      print(queryData);

      Response response = await dio.post(url, data: queryData);

      print(response.statusCode);
      if (response.statusCode == 200) {

        return true;
      } else {
        print('Error sending message. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending message: ${error.toString()}');
      return false;
    }
  }

  Future<int?> getCurrUserIdRequest() async {
    String endpoint = '/user/getId/${FirebaseAuth.instance.currentUser!.email}';

    try{
      String url = "${ApiPath}${endpoint}";

      Response response = await dio.get(url);

      if (response.statusCode == 200) {

        return response.data as int;
      } else {
        print('Error getting user id. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error getting user id: ${error.toString()}');
      return null;
    }
    }

  Future<List<ChatDTO>> fetchNewChats() async {
    String endpoint = '/chats/new';

    Map<String, dynamic> queryData = {
      'groupIds': Get.find<MapService>().chats.keys.toList(),
    };
    print(queryData);
    try {
      Response response = await dio.post(
        "${ApiPath}${endpoint}",
        data: {
          'groupIds': queryData,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = response.data;
        print(response.data);
        return (data as List).map((item) => ChatDTO.fromJson(item)).toList();
      } else {
        print('Error loading new chats. Status code: ${response.statusCode}');
        return List.empty();
      }
    } catch (error) {
      print('Error loading new chats: ${error.toString()}');
      return List.empty();
    }
  }
  }

