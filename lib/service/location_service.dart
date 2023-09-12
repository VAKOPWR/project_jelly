import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:project_jelly/classes/friend.dart';

class LocationService {
  Future<http.Response> sendLocation(LocationData locationData) async {
    log('location sent');
    return http.post(
      Uri.parse(
          'https://jelly-backend-1694012118516.azurewebsites.net/api/v1/location/store'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "userId": "Orest",
        "latitude": locationData.latitude!,
        "longitude": locationData.longitude!
      }),
    );
  }

  Future<List<Friend>> getFriendsLocation() async {
    log('friends received');
    final response = await http.get(Uri.parse(
        'https://jelly-backend-1694012118516.azurewebsites.net/api/v1/location/all'));
    if (response.statusCode == 200) {
      var people = (json.decode(response.body) as List)
          .map((i) => Friend.fromJson(i))
          .toList();
      return people;
    }
    throw Exception('Failed to load album');
  }
}
