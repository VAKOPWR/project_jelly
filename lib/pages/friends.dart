import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/Friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  void getData() {}

  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<Friend> _listFriends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // #TODO why Navigator.of(context).pop(); does not work? Fix this
            Navigator.pushReplacementNamed(context, '/map');
          },
        ),
      ),
      body: widget,
    );
  }

  Widget _buildRow(Friend friend) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
      ),
      title: Text(
        friend.name,
        style: _biggerFont,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://jsonplaceholder.typicode.com/users';
    var httpClient = HttpClient();
    List<Friend> listFriends = [];

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

          Friend friendModel = Friend(name, avatar, LatLng(latitude, longitude));
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
