import 'dart:math';
import 'package:flappy_bird/score.dart';
import 'package:flutter/material.dart';

import 'pipes.dart';

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

ButtonStyle navigationBarButtonStyle() {
  return ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 105, 76, 30)));
}

class PipeAnimation extends StatelessWidget {
  const PipeAnimation({
    Key? key,
    required this.pipeLeft,
    required this.pipeTop,
    required this.pipe,
  }) : super(key: key);

  final double pipeLeft;
  final double pipeTop;
  final MyPipe pipe;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(pipeLeft, pipeTop),
      child: pipe,
    );
  }
}

AssetImage birdImage = const AssetImage("images/sprites/background-night.png");
double birdAngle = 0;
double velocity = 0;
int previousScore = 0;
int score = 0;
bool isFalling = false;
double prevHeight = 0;
double birdY = 0.25;
double birdX = -0.3;
double time = 0;
double height = 0;
double initHeight = 0;
bool hasCollision = false;
bool isInGap = false;
bool isStarted = false;
bool gameOver = false;
double gameOverOpacity = 1.0;
double baseX = 0;
List<Rect> pipeRects = [];
double pipe1Left = 400;
double pipe2Left = 400;
double pipe3Left = 400;

double pipe1Top = 0;
double pipe2Top = 0;
double pipe3Top = 0;

bool pipe1Started = false;
bool pipe2Started = false;
bool pipe3Started = false;

bool pipe1Passed = false;
bool pipe2Passed = false;
bool pipe3Passed = false;

List<int> scores = [];

int getMaxScore() {
  return scores.isEmpty ? 0 : scores.reduce(max);
}

void resetGame() {
  setScore(00);
  previousScore = score;
  scores.add(score);
  birdAngle = 0;
  velocity = 0;
  score = 0;
  isFalling = false;
  prevHeight = 0;
  birdY = 0.25;
  birdX = -0.3;
  time = 0;
  height = 0;
  initHeight = 0;
  hasCollision = false;
  isInGap = false;
  isStarted = false;
  gameOver = false;
  gameOverOpacity = 1.0;
  baseX = 0;
  pipeRects = [];
  pipe1Left = 400;
  pipe2Left = 400;
  pipe3Left = 400;
  pipe1Top = getPipeTop();
  pipe2Top = getPipeTop();
  pipe3Top = getPipeTop();
  pipe1Started = false;
  pipe2Started = false;
  pipe3Started = false;
  pipe1Passed = false;
  pipe2Passed = false;
  pipe3Passed = false;
}
