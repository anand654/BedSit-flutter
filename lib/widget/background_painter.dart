import 'package:flutter/material.dart';

class BackGroundPainter extends CustomPainter {
  final double secondPtHeight;
  final Color color;
  final double qx1;
  final double qy1;
  final double qx2;
  final double qy2;

  BackGroundPainter({
    @required this.secondPtHeight,
    @required this.color,
    this.qx1 = 1,
    this.qy1 = 1,
    this.qx2 = 1,
    this.qy2 = 1,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * secondPtHeight);
    ovalPath.quadraticBezierTo(width * this.qx1, height * this.qy1,
        width * this.qx2, height * this.qy2);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = this.color;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(BackGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackGroundPainter oldDelegate) => false;
}
