import 'package:engine/src/component.dart';
import 'package:engine/src/game.dart';

mixin GameRef<T extends Game> on Component {
  T? _game;

  T get game => _game ??= _findGame();

  @override
  Game? findGame() => _game ?? super.findGame();

  T _findGame() {
    final game = findGame();
    assert(game != null, 'Cound not find Game $T');
    assert(game is T, 'Found ${game.runtimeType} instead of $T');
    return game! as T;
  }
}
