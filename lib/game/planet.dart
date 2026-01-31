import 'dart:ui';

import 'package:engine/engine.dart';

class Planet extends PhysicsBody {
  Planet({
    required int type,
    bool hasAstronaut = false,
    super.mass = 200_000,
    super.position,
  }) : _type = type,
       _hasAstronaut = hasAstronaut,
       super(static: true);

  final int _type;
  bool _hasAstronaut;
  final List<Color> _colorPalette = [];

  @override
  Future<void> setup() async {
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
  }
}
