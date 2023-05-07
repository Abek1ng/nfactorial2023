// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'helper.dart';
import 'dart:async';
import 'dart:math';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/pipes.dart';
import 'package:flappy_bird/score.dart';
import 'package:flappy_bird/sounds.dart';
import 'package:flutter/material.dart';

import 'menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<int> scores = [];

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  void resetGame() {
    previousScore = score;
    scores.add(score);
    setState(() {
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
    });
  }

  int getMaxScore() {
    return scores.isEmpty ? 0 : scores.reduce(max);
  }

  bool isPaused = false;

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  AssetImage birdImage =
      const AssetImage("images/sprites/background-night.png");
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

  MyPipe pipe1 = MyPipe(leftPos: 0, top: getPipeTop());
  MyPipe pipe2 = MyPipe(leftPos: 0, top: getPipeTop());
  MyPipe pipe3 = MyPipe(leftPos: 0, top: getPipeTop());

  final double birdWidth = 50;
  final double birdHeight = 50;
  void jump() {
    setState(() {
      time = 0;
      initHeight = birdY;
    });
  }

  void checkPoint(double birdPixelX) {
    if (pipe1Left + 50 <= birdPixelX && !pipe1Passed) {
      score++;
      pipe1Passed = true;
    } else if (pipe2Left + 50 <= birdPixelX && !pipe2Passed) {
      score++;
      pipe2Passed = true;
    } else if (pipe3Left + 50 <= birdPixelX && !pipe3Passed) {
      score++;
      pipe3Passed = true;
    }
  }

  void checkPipesCoordinates() {
    pipe1Left -= 0.19;
    if (pipe2Started && pipe3Started) {
      pipe2Left -= 0.19;
      pipe3Left -= 0.19;
    }

    if (pipe2Started && !pipe3Started) {
      pipe2Left -= 0.19;
    }
    if (pipe1Left <= MediaQuery.of(context).size.width / 1.5 && !pipe2Started) {
      pipe2Left = pipe1Left + MediaQuery.of(context).size.width / 1.5;
      pipe2Started = true;
    }
    if (pipe2Left <= MediaQuery.of(context).size.width / 1.5 && !pipe3Started) {
      pipe3Left = pipe2Left + MediaQuery.of(context).size.width / 1.5;
      pipe3Started = true;
    }
    if (pipe1Left <= -60 && pipe2Started) {
      pipe1Passed = false;
      pipe1Left = pipe3Left + MediaQuery.of(context).size.width / 1.5;
    }
    if (pipe2Left <= -60 && pipe3Started) {
      pipe2Passed = false;

      pipe2Left = pipe1Left + MediaQuery.of(context).size.width / 1.5;
    }
    if (pipe3Left <= -60) {
      pipe3Passed = false;

      pipe3Left = pipe2Left + MediaQuery.of(context).size.width / 1.5;
    }
  }

  void checkCollision(double birdPixelX) {
    Rect birdRect = getBirdRect(context);
    if (getCurPipe(score) == 1) {
      hasCollision =
          birdRect.overlaps(pipeRects[0]) || birdRect.overlaps(pipeRects[1]);
    }
    if (getCurPipe(score) == 2) {
      hasCollision =
          birdRect.overlaps(pipeRects[0]) || birdRect.overlaps(pipeRects[1]);
    }
    if (getCurPipe(score) == 3) {
      hasCollision =
          birdRect.overlaps(pipeRects[2]) || birdRect.overlaps(pipeRects[3]);
    }

    // Check if the bird is within the gap between the pipes.

    if (hasCollision) {
      print("Collision!");
    }
  }

  Rect getBirdRect(BuildContext context) {
    double birdPixelX = toX(context, birdX);
    double birdPixelY = toY(context, birdY);
    double birdSize =
        24 * 0.75; // The bird's original size is 34x24, and its scale is 0.75.
    return Rect.fromLTWH(birdPixelX, birdPixelY, birdSize, birdSize);
  }

  void start() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (isPaused) return;
      double birdPixelX = toX(context, birdX);
      baseX -= 0.19;
      checkPoint(birdPixelX);
      checkPipesCoordinates();
      pipeRects = [
        pipe1.getTopPipeRect(context, pipe1Left, pipe1Top),
        pipe1.getBottomPipeRect(context, pipe1Left, pipe1Top),
        pipe2.getTopPipeRect(context, pipe2Left, pipe2Top),
        pipe2.getBottomPipeRect(context, pipe2Left, pipe2Top),
        pipe3.getTopPipeRect(context, pipe3Left, pipe3Top),
        pipe3.getBottomPipeRect(context, pipe3Left, pipe3Top),
      ];
      checkCollision(birdPixelX);
      if (baseX <= -MediaQuery.of(context).size.width) {
        baseX = 0;
      }

      setState(() {
        time += 0.001;
        height = -4.9 * time * time + 1.9 * time;
        velocity = -4.9 * 4 * time + 1.9;
        birdY = initHeight - height;
        if (prevHeight < birdY) {
          isFalling = false;
        } else {
          isFalling = true;
        }

        prevHeight = birdY;
        setBirdPath(setBirdImage(isFalling));
        birdAngle = birdRotationAngle(velocity);
      });
      if (birdY >= 0.65 || (hasCollision)) {
        // playHit();
        time = 0;
        velocity = 0;
        timer.cancel();
        gameOver = true;
        isStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          // await playWing();
          setScore(score);
          //await playSwoosh();
          if (!isStarted) {
            start();
            isStarted = true;
          } else {
            jump();
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/sprites/background-day.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: GestureDetector(
                child: AnimatedContainer(
                  alignment: Alignment(birdX, birdY),
                  duration: Duration(milliseconds: 0),
                  child: Transform.rotate(angle: birdAngle, child: MyBird()),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(pipe1Left, pipe1Top),
              child: pipe1,
            ),
            Transform.translate(
              offset: Offset(pipe2Left, pipe2Top),
              child: pipe2,
            ),
            Transform.translate(
              offset: Offset(pipe3Left, pipe3Top),
              child: pipe3,
            ),
            Transform.translate(
              offset: Offset(baseX, 0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/sprites/base.png"),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(baseX + MediaQuery.of(context).size.width, 0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/sprites/base.png"),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                alignment: Alignment.topCenter,
                child: MyScore(),
              ),
            ),
            AnimatedPositioned(
              top: isStarted ? -MediaQuery.of(context).size.height : 0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  !gameOver
                      ? 'images/sprites/message.png'
                      : "images/sprites/gameover.png",
                  scale: 0.75,
                ),
              ),
            ),
            gameOver
                ? Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.3,
                    left: MediaQuery.of(context).size.width * 0.5 - 50,
                    child: ElevatedButton(
                      onPressed: resetGame,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 236, 185, 103)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Restart",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 355,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 105, 76, 30))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuPage(
                      currentScore: score,
                      maxScore: getMaxScore(),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 105, 76, 30))),
              onPressed: () {
                togglePause();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    isPaused ? "Resume" : "Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
