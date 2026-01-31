import 'package:engine/engine.dart';
import 'package:flutter/services.dart';
import 'package:space_game/game/level.dart';

class SpaceGame extends Game {
  late Level currentLevel;

  @override
  void setup() {
    super.setup();

    currentLevel = add(Level(planetCount: 10, astronautCount: 3));
  }

  @override
  void update(double dt) {
    super.update(dt);

    camera.position = currentLevel.rocket.absolutePosition;

    if (pressedKeys.contains(PhysicalKeyboardKey.keyD)) {
      printComponentTree(this);
    }
  }
}
