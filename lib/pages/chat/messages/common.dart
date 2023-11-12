import 'package:flutter/material.dart';

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

Widget buildReadStatusIcon(bool hasRead) {
  return Container(
    child: hasRead
        ? Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.done_all, size: 20.0, color: Colors.green),
      ],
    )
        : const Icon(Icons.check, size: 20.0, color: Colors.grey),
  );
}
