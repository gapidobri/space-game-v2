import 'dart:math';
import 'dart:ui';

import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:space_game/game/game.dart';

class Rocket extends PhysicsBody with GameRef<SpaceGame> {
  Rocket({double fuel = 1000, double health = 1000})
    : _fuel = fuel,
      _health = health,
      maxFuel = fuel,
      maxHealth = health,
      super(mass: 1000);

  late final Emitter _emitter;
  late final Sound _boosterSound;

  final double maxFuel;
  final double maxHealth;

  double _thrustPower = 0;

  double _angleAcceleration = 0;
  double _angleVelocity = 0;

  double _fuel;
  double _health;

  double get fuel => _fuel;

  double get health => _health;

  Vector2 get thrustVector => Vector2(sin(angle), -cos(angle)) * _thrustPower;

  @override
  Future<void> setup() async {
    add(
      SpriteComponent(
        sprite: await Sprite.load(
          'assets/images/atlas.png',
          src: Rect.fromLTWH(0, 50, 50, 50),
        ),
        scale: Vector2.all(0.5),
        anchor: Anchor.center,
      ),
    );

    add(CircleCollider(radius: 25));

    _emitter = Emitter(
      position: Vector2(0, 10),
      particleSystem: game.currentLevel.particleSystem,
      colorPalette: [Colors.orange, Colors.red, Colors.yellow],
      speed: 100,
      particleRate: 100,
      oneShot: false,
    );
    add(_emitter);

    _boosterSound = await AudioEngine.load(
      'assets/audio/rocket.wav',
      loop: true,
      volume: 0.5,
    );
  }

  @override
  void update(double dt) {
    // fuel depletion
    // _fuel -= _thrustPower * dt;
    // if (_fuel <= 0) {
    //   _fuel = 0;
    //   _thrustPower = 0;
    // }

    // booster particles
    if (_thrustPower != 0) {
      _emitter.start();
      // _boosterSound.play();
    } else {
      _emitter.stop();
      // _boosterSound.pause();
    }

    // rotation physics
    _angleVelocity += _angleAcceleration * dt;
    _angleVelocity = clampDouble(_angleVelocity, -5, 5);
    angle += _angleVelocity * dt;

    acceleration = thrustVector;

    _thrustPower = 0;
    _angleAcceleration = 0;
  }

  void boost() {
    _thrustPower = 100;
  }

  void rotateLeft() {
    _angleAcceleration = -5;
  }

  void rotateRight() {
    _angleAcceleration = 5;
  }
}
