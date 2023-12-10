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
          minWidth: 120.0,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              if (imageUrl != null)
                Image.asset(
                  'assets/mock_image.png',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
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
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary),
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
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.5),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      iconData,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                    ),
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
