import 'dart:math';
import 'dart:ui';

import 'package:engine/engine.dart';
import 'package:flutter/material.dart';

class Planet extends PhysicsBody {
  Planet({
    required int type,
    bool hasAstronaut = false,
    super.mass = 300_000,
    super.position,
  }) : _type = type,
       _hasAstronaut = hasAstronaut,
       super(static: true);

  final int _type;
  bool _hasAstronaut;
  final List<Color> _colorPalette = [];

  @override
  Future<void> setup() async {
    anchor = Anchor.center;
    if (_hasAstronaut) {
      // TODO: create indicator
    }

    final sprite = await Sprite.load(
      'assets/images/atlas.png',
      src: Rect.fromLTWH(50.0 * _type, 0, 50, 50),
    );

    add(
      SpriteComponent(
        sprite: sprite,
        scale: Vector2.all(2),
        anchor: Anchor.center,
      ),
    );

    add(CircleCollider(radius: 50, anchor: Anchor.center));

    // final pixels = await (await sprite.rasterize()).image.pixelsInUint8();
    // final pixelCount = (pixels.length / 4).toInt();
    // final random = Random();
    //
    // for (int i = 0; i < 10;) {
    //   final pi = random.nextInt(pixelCount) * 4;
    //
    //   final color = Color.fromARGB(
    //     pixels[pi + 3],
    //     pixels[pi],
    //     pixels[pi + 1],
    //     pixels[pi + 2],
    //   );
    //   if (color.a == 0) {
    //     continue;
    //   }
    //   _colorPalette.add(color);
    //   i++;
    // }
  }
}
