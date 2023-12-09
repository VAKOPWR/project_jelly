// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_jelly/classes/message_status.dart';

class OwnMessage extends StatelessWidget {
  const OwnMessage({
    Key? key,
    required this.message,
    required this.time,
    required this.messageStatus,
    this.imageUrl,
  }) : super(key: key);

  final String message;
  final String time;
  final MessageStatus messageStatus;
  final String? imageUrl;

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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.green[300],
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
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
                  bottom: 20,
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
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(iconData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
