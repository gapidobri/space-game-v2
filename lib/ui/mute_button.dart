import 'package:flutter/material.dart';
import 'package:space_game/game/game.dart';

class MuteButton extends StatefulWidget {
  const MuteButton({super.key, required this.game});

  final SpaceGame game;

  @override
  State<MuteButton> createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  bool muted = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => muted = !muted);
        if (muted) {
          widget.game.backgroundMusic.pause();
        } else {
          widget.game.backgroundMusic.play();
        }
      },
      icon: Icon(
        muted ? Icons.music_off : Icons.music_note,
        color: Colors.white,
      ),
    );
  }
}
