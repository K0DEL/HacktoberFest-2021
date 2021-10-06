import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  Path x;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Color(0xffffffff).withOpacity(0);
    path = Path();
    path.lineTo(size.width * 0.47, size.height * 0.66);
    path.cubicTo(size.width * 0.47, size.height * 0.69, size.width * 0.45, size.height * 0.72, size.width * 0.43, size.height * 0.72);
    path.cubicTo(size.width * 0.41, size.height * 0.72, size.width * 0.39, size.height * 0.69, size.width * 0.39, size.height * 0.66);
    path.cubicTo(size.width * 0.39, size.height * 0.62, size.width * 0.41, size.height * 0.59, size.width * 0.43, size.height * 0.59);
    path.cubicTo(size.width * 0.45, size.height * 0.59, size.width * 0.47, size.height * 0.62, size.width * 0.47, size.height * 0.66);
    canvas.drawPath(path, paint);

    x = path;
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
