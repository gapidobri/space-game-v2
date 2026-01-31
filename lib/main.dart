import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:space_game/game/game.dart';

void main() {
  final game = SpaceGame();

  runApp(App(game: game));
}

class App extends StatelessWidget {
  const App({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
