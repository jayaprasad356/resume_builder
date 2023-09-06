import 'package:flutter/material.dart';

class PaintTriangle extends CustomPainter {
  final Color backgroundColor;

  PaintTriangle({
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height;
    final x = size.width;

    final paint = Paint()..color = backgroundColor;
    final path = Path();

    path
      ..moveTo(0, y)
      ..lineTo((x / 2), (y / 1.5))
      ..lineTo(x, y);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
