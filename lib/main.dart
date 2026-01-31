import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:space_game/game/game.dart';
import 'package:space_game/ui/mute_button.dart';

void main() async {
  final game = SpaceGame();

  runApp(App(game: game));
}

class App extends StatelessWidget {
  const App({super.key, required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          GameWidget(game: game),
          Positioned(top: 32.0, right: 32.0, child: MuteButton(game: game)),
        ],
      ),
    );
  }
}
