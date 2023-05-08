import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
final player = AudioCache();
Future<void> playWing() async {
   player.play("wing.wav");
}
Future<void> playSwoosh() async {
  player.play("swoosh.wav");
}
Future<void> playDie() async {
  player.play("die.wav");
}
Future<void> playHit() async {
  player.play("hit.wav");
}
Future<void> playPoint() async {
  player.play("point.wav");
}