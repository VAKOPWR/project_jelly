import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<Uint8List> modifyImage(Uint8List imageData, Color borderColor,
    bool isOnline, String statusText) async {
  ui.Image originalImage = await decodeImageFromList(imageData);

  double circleRadius = originalImage.width / 2.0;
  double canvasSize = circleRadius *
      3.0; // Set the canvas size to be larger than the circular image

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset(0, 0),
          Offset(canvasSize, canvasSize))); // Use a larger canvas size

  Paint paintBorder = Paint()
    ..color = borderColor
    ..style = PaintingStyle.fill;

  // Draw the colorful border (circular mask)
  canvas.drawCircle(
      Offset(circleRadius, circleRadius), circleRadius, paintBorder);

  // Create a circular path for clipping the original image
  Path clipPath = Path()
    ..addOval(Rect.fromCircle(
        center: Offset(circleRadius, circleRadius), radius: circleRadius));

  // Clip the canvas with the circular path
  canvas.clipPath(clipPath);

  // Draw the original image onto the circular canvas
  canvas.drawImageRect(
    originalImage,
    Rect.fromPoints(
        Offset(0, 0),
        Offset(
            originalImage.width.toDouble(), originalImage.height.toDouble())),
    Rect.fromCircle(
        center: Offset(circleRadius, circleRadius), radius: circleRadius),
    Paint(),
  );

  if (isOnline) {
    // Draw online status indicator (green circle) at the bottom right
    double indicatorRadius = 10.0;
    Paint paintIndicator = Paint()..color = Colors.green;
    canvas.drawCircle(
        Offset(canvasSize - indicatorRadius, canvasSize - indicatorRadius),
        indicatorRadius,
        paintIndicator);
  } else {
    // Draw gray text indicating the status (e.g., '3h', '1d')
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: statusText,
        style: TextStyle(color: Colors.grey, fontSize: 12.0),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(canvasSize - textPainter.width - 5,
            canvasSize - textPainter.height - 5));
  }

  final img = await recorder.endRecording().toImage(
      canvasSize.toInt(), canvasSize.toInt()); // Convert canvas size to int
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
