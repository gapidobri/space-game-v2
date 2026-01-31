import 'dart:async';

import 'package:engine/engine.dart';
import 'package:space_game/game/game.dart';

class Background extends Component with GameRef<SpaceGame> {
  Background({required this.parallax});

  final double parallax;

  late final TransformComponent _transformComponent;
  late final Vector2 _tileSize;

  @override
  FutureOr<void> setup() async {
    final sprite = await Sprite.load('assets/images/stars.png');
    _tileSize = sprite.size;

    final yTileCount = (game.size.y / _tileSize.x).ceil() + 1;
    final xTileCount = (game.size.x / _tileSize.x).ceil() + 1;

    final tiles = <SpriteComponent>[];
    for (int y = 0; y < yTileCount; y++) {
      for (int x = 0; x < xTileCount; x++) {
        tiles.add(
          SpriteComponent(
            sprite: sprite,
            position: Vector2(_tileSize.x * (x - 1), _tileSize.y * (y - 1)),
          ),
        );
      }
    }

    _transformComponent = add(TransformComponent(children: tiles));
  }

  @override
  void update(double dt) {
    _transformComponent.position =
        (game.camera.position * -parallax) % _tileSize;
  }
}
