import 'package:flutter/material.dart';

class CrisWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    const textStyle = TextStyle(
      color: Color(0x0E0B2545), // very subtle CRIS watermark
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0,
    );

    const stepX = 140.0;
    const stepY = 80.0;

    canvas.save();
    canvas.rotate(-0.25); // ~15 degree slant

    for (double x = -100; x < size.width + 200; x += stepX) {
      for (double y = -100; y < size.height + 200; y += stepY) {
        textPainter.text = const TextSpan(
          text: 'CRIS • भारतीय रेल • UTS',
          style: textStyle,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
