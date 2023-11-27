// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Uint8ListImageProvider extends ImageProvider<Uint8ListImageProvider> {
  final Uint8List uint8List;

  Uint8ListImageProvider(this.uint8List);

  @override
  ImageStreamCompleter load(
      Uint8ListImageProvider key, DecoderCallback decode) {
    return OneFrameImageStreamCompleter(
      _loadAsync(key),
    );
  }

  Future<ImageInfo> _loadAsync(Uint8ListImageProvider key) async {
    final Uint8List bytes = key.uint8List;
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(ImageInfo(image: img));
    });
    return completer.future;
  }

  @override
  Future<Uint8ListImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<Uint8ListImageProvider>(this);
  }
}
