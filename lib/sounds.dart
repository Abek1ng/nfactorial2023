import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
AudioPlayer player = AudioPlayer();
Future<void> playWing() async {
  await player.setSourceAsset("wing.wav");
  await player.play(AssetSource("wing.wav"));
}
Future<void> playSwoosh() async {
  await player.setSourceAsset("swoosh.wav");
  await player.play(AssetSource("swoosh.wav"));
}
Future<void> playDie() async {
  await player.setSourceAsset("die.wav");
  await player.play(AssetSource("die.wav"));
}
Future<void> playHit() async {
  await player.setSourceAsset("hit.wav");
  await player.play(AssetSource("hit.wav"));
}
Future<void> playPoint() async {
  await player.setSourceAsset("point.wav");
  await player.play(AssetSource("point.wav"));
}