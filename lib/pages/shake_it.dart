import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/service/request_service.dart';

class ShakeItScreen extends StatefulWidget {
  ShakeItScreen({Key? key}) : super(key: key);

  @override
  _ShakeItScreenState createState() => _ShakeItScreenState();
}

class _ShakeItScreenState extends State<ShakeItScreen> {
  List<BasicUser> usersWhoAreShaking = [];
  bool isShaking = false;

  @override
  void initState() {
    super.initState();
    _fetchShakingUsers();
  }

  Future<void> _fetchShakingUsers() async {
    List<BasicUser> _usersWhoAreShaking = await Get.find<RequestService>()
        .getFriendsBasedOnEndpoint('/user/nearby');

    setState(() {
      usersWhoAreShaking = _usersWhoAreShaking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shake IT",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: Colors.green,
        elevation: 0,
        titleSpacing: 16.0,
      ),
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  margin: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isShaking
                            ? "Shaking! Who else is?"
                            : "Also Shaking Near You",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        height: 1.0,
                        width: 250,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground, // Line color
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: usersWhoAreShaking.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: 8.0), // Adjust the value as needed
                              child: _buildFriendRow(usersWhoAreShaking[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Icon(
              Icons.speaker_phone_rounded,
              size: 160.0,
              color: Theme.of(context).canvasColor,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRow(BasicUser userWhoIsShaking) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userWhoIsShaking.avatar ??
            'https://shireoakinternational.asia/wp-content/webp-express/webp-images/doc-root/wp-content/uploads/2022/12/Person-650x650.jpg.webp'),
        radius: 29,
      ),
      title: Text(
        userWhoIsShaking.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      onTap: () async {
        bool success = await Get.find<RequestService>()
            .sendFriendRequest(userWhoIsShaking.id);
        if (success) {
          Get.snackbar("Congratulations!",
              "Your friend request sent to ${userWhoIsShaking.name}",
              icon: Icon(Icons.sentiment_satisfied_alt_outlined,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        } else {
          Get.snackbar("Ooops!",
              "Failed to send friend request to ${userWhoIsShaking.name}",
              icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        }
      },
    );
  }
}
