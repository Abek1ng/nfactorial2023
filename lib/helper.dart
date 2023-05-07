import 'dart:math';
import 'package:flutter/material.dart';

double randomDoubleInRange(double min, double max) {
  final random = Random();
  return min + random.nextDouble() * (max - min);
}

double getPipeTop() {
  return randomDoubleInRange(-130, 0);
}

double toX(BuildContext context, double alignmentX) {
  return (alignmentX + 1) / 2 * MediaQuery.of(context).size.width;
}

double toY(BuildContext context, double alignmentY) {
  return (alignmentY + 1) / 2 * MediaQuery.of(context).size.height;
}

int getCurPipe(int score) {
  return (score % 3) + 1;
}
