import 'package:flutter/material.dart';

class TrapeziumRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(13, 0.0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(TrapeziumRightClipper oldClipper) => false;
}
