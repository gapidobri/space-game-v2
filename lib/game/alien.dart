import 'dart:async';
import 'dart:math';

import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:space_game/game/game.dart';

class Alien extends PhysicsBody with GameRef<SpaceGame> {
  Alien({super.position});

  late final RectangleComponent dAcceleration;
  late final RectangleComponent dVelocity;

  @override
  FutureOr<void> setup() async {
    anchor = Anchor.center;

    add(
      SpriteComponent(
        sprite: await Sprite.load(
          'assets/images/atlas.png',
          src: Rect.fromLTWH(50, 50, 50, 50),
        ),
        anchor: Anchor.center,
      ),
    );

    dAcceleration = add(
      RectangleComponent(size: Vector2(20, 1))..paint.color = Colors.white,
    );
    dVelocity = add(
      RectangleComponent(size: Vector2(20, 1))..paint.color = Colors.green,
    );
  }

  @override
  void update(double dt) {
    final diff = game.currentLevel.rocket.position - position;

    final cancel = -velocity;
    final follow = diff * 0.5;

    final cancelW = acos(velocity.normalized().dot(diff.normalized())) / pi;

    acceleration = cancel * cancelW + follow * (1 - cancelW);

    dAcceleration.size.x = acceleration.length;
    dAcceleration.angle = acceleration.getAngle();

    dVelocity.size.x = velocity.length;
    dVelocity.angle = velocity.getAngle();
  }
}
