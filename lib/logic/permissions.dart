import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestGalleryPermission() async {
  final status = await Permission.storage.status;

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    final result = await Permission.storage.request();

    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    return false;
  }
}

Future<bool> requestContactsPermission() async {
  final status = await Permission.contacts.status;
  log((status.isDenied).toString());

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    final result = await Permission.contacts.request();

    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    return false;
  }
}
