// ignore_for_file: unnecessary_this

import 'dart:math';

import 'package:flutter/material.dart';

class MyPipe extends StatelessWidget {
  Rect getTopPipeRect(BuildContext context, double leftPos, double currentTop) {
    double topPipeHeight = MediaQuery.of(context).size.height * 0.3;
    double pipeWidth = MediaQuery.of(context).size.width * 0.15;
    return Rect.fromLTWH(leftPos, 0, pipeWidth, topPipeHeight + currentTop);
  }

  Rect getBottomPipeRect(
      BuildContext context, double leftPos, double currentTop) {
    double topPipeHeight = MediaQuery.of(context).size.height * 0.4;
    double pipeWidth = MediaQuery.of(context).size.width * 0.15;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomPipeTop = topPipeHeight + currentTop + 170;
    return Rect.fromLTWH(
        leftPos, bottomPipeTop, pipeWidth, screenHeight - bottomPipeTop);
  }

  void movePipe() {
    leftPos -= 0.19;
  }

  MyPipe({Key? key, required this.leftPos, required this.top})
      : super(key: key);
  double leftPos;
  double top;
  @override
  Widget build(BuildContext context) {
    double pipeHeight = 400;

    return Stack(
      children: [
        Positioned(
          left: leftPos, // Set the left position here
          top: top, // Set the top position here
          child: Column(
            children: [
              // Upper pipe
              Transform.rotate(
                angle: pi,
                child: Image.asset(
                  "images/sprites/pipe-green.png",
                  height: pipeHeight,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 170,
              ),
              // Lower pipe
              Image.asset(
                "images/sprites/pipe-green.png",
                height: pipeHeight,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
