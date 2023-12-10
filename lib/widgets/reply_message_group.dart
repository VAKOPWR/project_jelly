import 'package:flutter/material.dart';
import 'package:project_jelly/pages/chat/messages/common.dart';

class ReplyMessageGroup extends StatelessWidget {
  const ReplyMessageGroup({
    Key? key,
    required this.message,
    required this.time,
    this.imageUrl,
    this.profilePictureUrl,
    required this.senderNickname,
  });

  final String message;
  final String time;
  final String senderNickname;
  final String? imageUrl;
  final String? profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: 80.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: handleTextToImages(profilePictureUrl),
                radius: 15.0,
              ),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                color: Color.fromRGBO(30, 30, 30, 1),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Text(
                      senderNickname,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (imageUrl != null)
                      Image.asset(
                        'assets/mock_image.png',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 22,
                      ),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
