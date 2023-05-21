// ignore_for_file: unnecessary_this

import 'dart:math';

import 'package:flutter/material.dart';

class MyPipe extends StatelessWidget {
  Rect getTopPipeRect(BuildContext context, double leftPos, double currentTop) {
    double topPipeHeight = 330;
    double pipeWidth = 60;
    return Rect.fromLTWH(leftPos, 0, pipeWidth, topPipeHeight + currentTop);
  }

  Rect getBottomPipeRect(
    BuildContext context, double leftPos, double currentTop) {
    double topPipeHeight = 330;
    double pipeWidth = 60;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomPipeTop = topPipeHeight + currentTop + 190;
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
          left: leftPos,
          top: top, 
          child: Column(
            children: [
              // Upper pipe
              Container(
                child: Transform.rotate(
                  angle: pi,
                  child: Image.asset(
                    "images/sprites/pipe-green.png",
                    height: pipeHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 190,
              ),
              // Lower pipe
              Container(
                child: Image.asset(
                  "images/sprites/pipe-green.png",
                  height: pipeHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

 
