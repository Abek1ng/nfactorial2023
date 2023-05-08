// ignore_for_file: prefer_const_constructors

import 'helper.dart';
import 'dart:async';
import 'dart:math';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/pipes.dart';
import 'package:flappy_bird/score.dart';
import 'package:flappy_bird/sounds.dart';
import 'package:flutter/material.dart';

import 'menu_page.dart';
import 'painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

MyPipe pipe1 = MyPipe(leftPos: 0, top: getPipeTop());
MyPipe pipe2 = MyPipe(leftPos: 0, top: getPipeTop());
MyPipe pipe3 = MyPipe(leftPos: 0, top: getPipeTop());

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ValueNotifier<Rect> topTubeRectNotifier = ValueNotifier<Rect>(Rect.zero);
  ValueNotifier<Rect> bottomTubeRectNotifier = ValueNotifier<Rect>(Rect.zero);
  void updateTubeRects() {
    if (getCurPipe(score) == 1) {
      topTubeRectNotifier.value =
          pipe1.getTopPipeRect(context, pipe1Left, pipe1Top);
      bottomTubeRectNotifier.value =
          pipe1.getBottomPipeRect(context, pipe1Left, pipe1Top);
    } else if (getCurPipe(score) == 2) {
      topTubeRectNotifier.value =
          pipe2.getTopPipeRect(context, pipe2Left, pipe2Top);
      bottomTubeRectNotifier.value =
          pipe2.getBottomPipeRect(context, pipe2Left, pipe2Top);
    } else if (getCurPipe(score) == 3) {
      topTubeRectNotifier.value =
          pipe3.getTopPipeRect(context, pipe3Left, pipe3Top);
      bottomTubeRectNotifier.value =
          pipe3.getBottomPipeRect(context, pipe3Left, pipe3Top);
    }
  }

  double pipeSpeed = 3;
  bool isPaused = false;
  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  final double birdWidth = 50;
  final double birdHeight = 50;
  void jump() {
    playWing();
    time = 0;
    initHeight = birdY;
  }

  void checkPoint(double birdPixelX) {
    if (pipe1Left + 50 <= birdPixelX && !pipe1Passed) {
      playPoint();
      score++;
      pipe1Passed = true;
    } else if (pipe2Left + 50 <= birdPixelX && !pipe2Passed) {
      playPoint();
      score++;
      pipe2Passed = true;
    } else if (pipe3Left + 50 <= birdPixelX && !pipe3Passed) {
      playPoint();
      score++;
      pipe3Passed = true;
    }
  }

  void checkPipesCoordinates() {
    double screenWidth = MediaQuery.of(context).size.width / 1.5;
    pipe1Left -= pipeSpeed;
    if (pipe2Started && pipe3Started) {
      pipe2Left -= pipeSpeed;
      pipe3Left -= pipeSpeed;
    }

    if (pipe2Started && !pipe3Started) {
      pipe2Left -= pipeSpeed;
    }
    if (pipe1Left <= screenWidth && !pipe2Started) {
      pipe2Left = pipe1Left + screenWidth;
      pipe2Top = getPipeTop();
      pipe2Started = true;
    }
    if (pipe2Left <= screenWidth && !pipe3Started) {
      pipe3Left = pipe2Left + screenWidth;
      pipe3Top = getPipeTop();
      pipe3Started = true;
    }
    if (pipe1Left <= -60 && pipe2Started) {
      pipe1Passed = false;
      pipe1Top = getPipeTop();
      pipe1Left = pipe3Left + screenWidth;
    }
    if (pipe2Left <= -60 && pipe3Started) {
      pipe2Passed = false;
      pipe2Top = getPipeTop();
      pipe2Left = pipe1Left + screenWidth;
    }
    if (pipe3Left <= -60) {
      pipe3Passed = false;
      pipe3Top = getPipeTop();
      pipe3Left = pipe2Left + MediaQuery.of(context).size.width / 1.5;
    }
  }

  void checkCollision(double birdPixelX) {
    Rect birdRect = getBirdRect(context);
    if (getCurPipe(score) == 1) {
      hasCollision = birdRect.overlaps(
            pipe1.getTopPipeRect(context, pipe1Left, pipe1Top),
          ) ||
          birdRect.overlaps(
            pipe1.getBottomPipeRect(context, pipe1Left, pipe1Top),
          );
    }
    if (getCurPipe(score) == 2) {
      hasCollision = birdRect.overlaps(
            pipe2.getTopPipeRect(context, pipe2Left, pipe2Top),
          ) ||
          birdRect.overlaps(
            pipe2.getBottomPipeRect(context, pipe2Left, pipe2Top),
          );
    }
    if (getCurPipe(score) == 3) {
      hasCollision = birdRect.overlaps(
            pipe3.getTopPipeRect(context, pipe3Left, pipe3Top),
          ) ||
          birdRect.overlaps(
            pipe3.getBottomPipeRect(context, pipe3Left, pipe3Top),
          );
    }
  }

  Rect getBirdRect(BuildContext context) {
    double birdPixelX = toX(context, birdX);
    double birdPixelY = toY(context, birdY);
    double birdSize = 21 / 0.75;
    return Rect.fromLTWH(birdPixelX, birdPixelY, birdSize, birdSize);
  }

  void start() {
    double birdPixelX = toX(context, birdX);

    Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (isPaused) return;
      baseX -= pipeSpeed;
      checkPoint(birdPixelX);
      setScore(score);
      checkPipesCoordinates();
      updateTubeRects();
      checkCollision(birdPixelX);
      

      if (baseX <= -MediaQuery.of(context).size.width) {
        baseX = 0;
      }

      setState(() {
        time += 0.02;
        height = -4.9 * time * time + 2 * time;
        velocity = -4.9 * 4 * time + 2;
        birdY = initHeight - height;
      });
      if (prevHeight < birdY) {
        isFalling = false;
      } else {
        isFalling = true;
      }

      prevHeight = birdY;
      setBirdPath(setBirdImage(isFalling));
      birdAngle = birdRotationAngle(velocity);

      if (birdY >= 0.65 || (hasCollision)) {
        setState(() {
          gameOver ? null : playHit();
          time = 0;
          velocity = 0;
          timer.cancel();
          //isPaused = true;
          gameOver = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          if (!isStarted) {
            isStarted = true;
            start();
            jump();
          } else {
            if (!gameOver) {
              jump();
            }
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
            CustomPaint(
              foregroundPainter: DebugRectPainter(
                rectListenable: topTubeRectNotifier,
                rectColor: Colors.blue,
              ),
            ),
            CustomPaint(
              foregroundPainter: DebugRectPainter(
                rectListenable: bottomTubeRectNotifier,
                rectColor: Colors.blue,
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
                    left: MediaQuery.of(context).size.width * 0.5 - 75,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          resetGame();
                        });
                      },
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.restart_alt_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Restart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
              style: navigationBarButtonStyle(),
              onPressed: () {
                playSwoosh();
                togglePause();
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
                children: const [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "Menu",
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
