import 'package:engine/engine.dart';
import 'package:flutter/services.dart';
import 'package:space_game/game/game.dart';
import 'package:space_game/game/rocket.dart';

class HumanPlayer extends Component with GameRef<SpaceGame> {
  HumanPlayer({required Rocket rocket}) : _rocket = rocket;

  final Rocket _rocket;

  @override
  void update(double dt) {
    for (final key in game.pressedKeys) {
      switch (key) {
        case PhysicalKeyboardKey.space:
          _rocket.boost();
          break;

        case PhysicalKeyboardKey.arrowLeft:
          _rocket.rotateLeft();
          break;

        case PhysicalKeyboardKey.arrowRight:
          _rocket.rotateRight();
          break;
      }
    }
  }
}
