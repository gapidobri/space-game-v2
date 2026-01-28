import 'package:engine/camera.dart';
import 'package:engine/game.dart';
import 'package:space_game/game/level.dart';

class SpaceGame extends Game {
  SpaceGame() : super(world: Level(), camera: Camera());
}
