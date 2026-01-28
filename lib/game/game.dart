import 'package:engine/engine.dart';
import 'package:space_game/game/level.dart';

class SpaceGame extends Game {
  SpaceGame() : super(world: Level(), camera: Camera());
}
