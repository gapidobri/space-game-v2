import 'package:engine/engine.dart';
import 'package:space_game/game/rocket.dart';

class Level extends World {
  @override
  Future<void> setup() async {
    add(Rocket());
  }
}
