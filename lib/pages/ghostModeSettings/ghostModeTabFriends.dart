import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/classes/person.dart';

import '../../widgets/SearchBarWidget.dart';
import '../FriendSpecificGhostMode.dart';

class GhostModeTabFriends extends StatefulWidget {
  const GhostModeTabFriends({super.key});

  @override
  _GhostModeTabFriends createState() => _GhostModeTabFriends();
}

class _GhostModeTabFriends extends State<GhostModeTabFriends> {

  void getData() {}

  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<Person> _listFriends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SearchBarWidget(
        content: _buildContent(),
      ),
    );
  }

  Widget _buildContent(){
    Widget widget;

    if (_isProgressBarShown) {
      widget = const Center(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      widget = ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();
            final friendIndex = i ~/ 2;
            // # TODO delete this condition
            if (friendIndex != _listFriends.length) {
              return _buildRow(_listFriends[friendIndex]);
            }
            return null;
          });
    }
    return widget;
  }


    Widget _buildRow(Person person) {
      return GestureDetector(
        onTap: (){
          _handleFriendClick(person);
        },
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
                'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
          ),
          title: Text(
            person.name,
            style: _biggerFont,
          ),
        ),
      );
    }

  void _handleFriendClick(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendSpecificGhostMode(
          person: person, // Replace 'personObject' with the actual Person object
        ),
      ),
    );
  }

    _fetchFriendsList() async {
      _isProgressBarShown = true;
      var url = 'https://jsonplaceholder.typicode.com/users';
      var httpClient = HttpClient();
      List<Person> listFriends = [];

      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        if (response.statusCode == HttpStatus.ok) {
          var json = await utf8.decoder.bind(response).join();
          List<dynamic> data = jsonDecode(json);

          for (var res in data) {
            var objName = res['name'];
            String name = objName.toString();

            var objLat = res['address']['geo']['lat'];
            double latitude;
            if (objLat is String) {
              latitude = double.tryParse(objLat) ?? 0.0;
            } else {
              latitude = objLat ?? 0.0;
            }

            var objLng = res['address']['geo']['lng'];
            double longitude;
            if (objLng is String) {
              longitude = double.tryParse(objLng) ?? 0.0;
            } else {
              longitude = objLng ?? 0.0;
            }

            String avatar =
                'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50';

            Person friendModel = Person(
                name: name,
                avatar: avatar,
                location: LatLng(latitude, longitude));
            listFriends.add(friendModel);
          }
        }
      } catch (exception) {
        print(exception.toString());
      }


      if (!mounted) return;

      setState(() {
        _listFriends = listFriends;
        _isProgressBarShown = false;
      });
    }
  }

  




