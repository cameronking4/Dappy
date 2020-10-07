import 'dart:math';
import 'package:flutter/material.dart';

class TopBarClipper extends CustomClipper<Path> {
  final bool topLeft;
  final bool bottomRight;
  final bool bottomLeft;
  final bool topRight;
  final double radius;
  TopBarClipper(
      {this.bottomRight = false,
      this.bottomLeft = false,
      this.topRight = false,
      this.topLeft = false,
      this.radius = 26.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (topLeft) {
      path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
          degreeToRadians(90), false);
    } else {
      path.lineTo(0.0, 0.0);
    }

    if (topRight) {
      path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
          degreeToRadians(270), degreeToRadians(90), false);
    } else {
      path.lineTo(size.width, 0);
    }

    if (bottomRight) {
      path.arcTo(
          Rect.fromLTWH(
              size.width - radius, size.height - radius, radius, radius),
          degreeToRadians(0),
          degreeToRadians(90),
          false);

      // path.quadraticBezierTo(
      //     size.width, size.height - radius, size.width - radius, size.height);
    } else {
      path.lineTo(size.width, size.height);
    }

    if (bottomLeft) {
      path.arcTo(Rect.fromLTWH(0, size.height - radius, radius, radius),
          degreeToRadians(90), degreeToRadians(90), false);
    } else {
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TopBarClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (pi / 180) * degree;
    return redian;
  }
}
