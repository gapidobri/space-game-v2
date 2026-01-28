import 'package:engine/game.dart';
import 'package:flutter/material.dart';

class GamePainter extends CustomPainter {
  final Game _game;
  final ValueNotifier<int> _repaint;

  GamePainter._(Game game, ValueNotifier<int> repaint)
    : _game = game,
      _repaint = repaint,
      super(repaint: repaint);

  factory GamePainter(Game game) => GamePainter._(game, ValueNotifier<int>(0));

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF000000),
    );

    _game.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void repaint() => _repaint.value++;
}
