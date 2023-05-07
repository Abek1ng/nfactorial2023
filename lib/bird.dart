// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'dart:math';

import 'package:flutter/material.dart';

String birdPath = "images/sprites/yellowbird-midflap.png";
String birdColor = "yellow";

class MyBird extends StatelessWidget {
  final double size;

  MyBird({super.key, this.size = 0.75});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      birdPath,
      scale: size,
    );
  }
}

double birdRotationAngle(double velocity) {
  double rotationFactor = min(velocity, 10) * 0.1;
  return max(-pi / 4, -rotationFactor);
}

void setBirdPath(String path) {
  birdPath = path;
}

String setBirdImage(bool isFalling) {
  if (birdColor == "yellow") {
    return isFalling
        ? "images/sprites/yellowbird-downflap.png"
        : "images/sprites/yellowbird-upflap.png";
  }
  if (birdColor == "blue") {
    return isFalling
        ? "images/sprites/bluebird-downflap.png"
        : "images/sprites/bluebird-upflap.png";
  }
  if (birdColor == "red") {
    return isFalling
        ? "images/sprites/redbird-downflap.png"
        : "images/sprites/redbird-upflap.png";
  }
  return "";
}
