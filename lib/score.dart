// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

String numPath(String number) {
  switch (number) {
    case "0":
      return "images/sprites/0.png";
    case "1":
      return "images/sprites/1.png";
    case "2":
      return "images/sprites/2.png";
    case "3":
      return 'images/sprites/3.png';
    case "4":
      return "images/sprites/4.png";
    case "5":
      return "images/sprites/5.png";
    case "6":
      return "images/sprites/6.png";
    case "7":
      return "images/sprites/7.png";
    case "8":
      return "images/sprites/8.png";
    case "9":
      return "images/sprites/9.png";
    default:
      throw ArgumentError('Invalid number');
  }
}

String firstDigit = "0";
String secondDigit = "0";
void setScore(int score) {
  if (score > 9) {
    firstDigit = score.toString()[0];
    secondDigit = score.toString()[1];
  } else {
    secondDigit = score.toString()[0];
  }
}
// ignore: must_be_immutable
class MyScore extends StatelessWidget {
  MyScore({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          (numPath(firstDigit)),
          scale: 0.8,
        ),
        Image.asset(
          numPath(secondDigit),
          scale: 0.8,
        )
      ],
    );
  }
}

