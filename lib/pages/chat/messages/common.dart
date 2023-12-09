import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jelly/classes/message_status.dart';

String formatLastSentTime(DateTime lastSentTime) {
  Duration difference = DateTime.now().difference(lastSentTime);
  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inDays}d ago';
  }
}

Widget buildReadStatusIcon(MessageStatus messageStatus) {
  return Container(
    child: messageStatus == MessageStatus.SEEN
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.done_all, size: 20.0, color: Colors.green),
            ],
          )
        : const Icon(Icons.check, size: 20.0, color: Colors.grey),
  );
}

//TODO: choose colors here
String formatMessageTime(DateTime messageTime) {
  return ("${messageTime.toLocal().hour}:${messageTime.minute}");
}

String? handleImagesToText(XFile? image) {
  //some magic
  if (XFile == null) {
    return null;
  }
  return "mocked//url";
}

ImageProvider<Object> handleTextToImages(String? imageUrl) {
  //more magic
  if (imageUrl == null) {
    return FileImage(File('assets/default_image.jpg'));
  } else {
    return FileImage(File('assets/mock_image.png'));
  }
}
