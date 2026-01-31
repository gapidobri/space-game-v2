import 'dart:math';

import 'package:engine/src/game.dart';
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
    final scaleX = size.width / _game.camera.resolution.x;
    final scaleY = size.height / _game.camera.resolution.y;

    final scale = min(scaleX, scaleY);
    canvas.scale(scale);

    final newSize = Size(size.width / scale, size.height / scale);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, newSize.width, newSize.height),
      Paint(),
    );

    _game.render(canvas, newSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void repaint() => _repaint.value++;
}
