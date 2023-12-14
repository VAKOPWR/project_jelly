import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Uint8List> modifyImage(
    Uint8List imageData, bool isOnline, String statusText) async {
  ui.Image originalImage = await decodeImageFromList(imageData);

  double circleRadius = originalImage.width / 2.0;
  double canvasSize = circleRadius * 2.3;
  double indicatorRadius = circleRadius / 4;
  Color borderColor = Color.fromRGBO(248, 70, 85, 1);

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
      recorder, Rect.fromPoints(Offset(0, 0), Offset(canvasSize, canvasSize)));

  Paint paintBorder = Paint()
    ..color = borderColor
    ..style = PaintingStyle.fill;

  canvas.drawCircle(
      Offset(circleRadius, circleRadius), circleRadius * 0.99, paintBorder);

  if (isOnline) {
    Paint paintIndicator = Paint()
      ..color = const ui.Color.fromARGB(255, 79, 225, 86);
    canvas.drawCircle(
        Offset(canvasSize / 1.15 - indicatorRadius,
            canvasSize / 1.15 - indicatorRadius),
        indicatorRadius,
        paintIndicator);
  } else {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: statusText,
        style: GoogleFonts.bebasNeue(
            color: Colors.deepPurpleAccent,
            fontSize: 60.0,
            fontWeight: FontWeight.w900),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(canvasSize - textPainter.width - 20,
            canvasSize - textPainter.height - 15));
  }

  Path clipPath = Path()
    ..addOval(Rect.fromCircle(
        center: Offset(circleRadius, circleRadius), radius: circleRadius));

  canvas.clipPath(clipPath);

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
    Paint paintIndicator = Paint()..color = ui.Color.fromARGB(255, 79, 225, 86);
    canvas.drawCircle(
        Offset(canvasSize / 1.15 - indicatorRadius,
            canvasSize / 1.15 - indicatorRadius),
        indicatorRadius,
        paintIndicator);
  } else {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: statusText,
        style: GoogleFonts.bebasNeue(
          color: Colors.purpleAccent,
          fontSize: 60.0,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(canvasSize - textPainter.width - 20,
            canvasSize - textPainter.height - 15));
  }

  final img = await recorder
      .endRecording()
      .toImage(canvasSize.toInt(), canvasSize.toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
