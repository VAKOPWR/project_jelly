import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_jelly/classes/message_status.dart';
import 'package:project_jelly/pages/chat/messages/common.dart';
import 'package:project_jelly/service/map_service.dart';

class ReplyMessageGroup extends StatelessWidget {
  const ReplyMessageGroup({Key? key,
    required this.message,
    required this.time,
    required this.messageStatus,
    this.imageUrl,
    this.profilePictureUrl,
    required this.senderNickname,
    });

  final MessageStatus  messageStatus;
  final String message;
  final String time;
  final String senderNickname;
  final String? imageUrl;
  final String? profilePictureUrl;


  //TODO: colors here

  @override
  Widget build(BuildContext context) {

    IconData iconData;

    switch (messageStatus) {
      case MessageStatus.SEEN:
        iconData = Icons.done_all;
        break;
      case MessageStatus.SENT:
        iconData = Icons.done;
        break;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: 30.0,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: handleTextToImages(profilePictureUrl),
              radius: 15.0,
            ),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      left: 8,
                      right: 50,
                      top: 5,
                      bottom: 10,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Icon(iconData),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}