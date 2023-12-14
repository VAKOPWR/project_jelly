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
            child: imageUrl != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                              left: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                              right: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                            Row(
                              children: [
                                Icon(
                                  iconData,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(children: [
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
                    )
                  ]),
          )),
    );
  }
}
