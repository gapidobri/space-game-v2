import 'package:engine/engine.dart';
import 'package:flutter/services.dart';

class Rocket extends SpriteComponent {
  @override
  Future<void> setup() async {
    sprite = await Sprite.load(
      'assets/images/atlas.png',
      src: Rect.fromLTWH(0, 50, 50, 50),
      anchor: Anchor.center,
    );
  }

  @override
  void update(double dt) {
    if (Game.game.pressedKeys.contains(PhysicalKeyboardKey.space)) {
      position.x += 50 * dt;
    }
  }
}
