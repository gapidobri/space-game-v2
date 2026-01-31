import 'package:engine/engine.dart';
import 'package:flutter/services.dart';
import 'package:space_game/game/background.dart';
import 'package:space_game/game/level.dart';

class SpaceGame extends Game {
  late Level currentLevel;

  late Sound backgroundMusic;

  @override
  void setup() async {
    super.setup();

    currentLevel = add(Level(planetCount: 10, astronautCount: 3));

    camera.add(Background(parallax: 0.2));

    backgroundMusic = await AudioEngine.load(
      'assets/music/the-80s-nights.wav',
      loop: true,
    );
    // backgroundMusic.play();
  }

  @override
  void update(double dt) {
    super.update(dt);

    camera.position = currentLevel.rocket.absolutePosition - size / 2;

    if (pressedKeys.contains(PhysicalKeyboardKey.keyD)) {
      printComponentTree(this);
    }
  }
}
