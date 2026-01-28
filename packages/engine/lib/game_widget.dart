import 'package:engine/game.dart';
import 'package:engine/painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key, required this.game});

  final Game game;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  late final GamePainter renderer;
  late final Ticker ticker;

  Duration last = Duration.zero;

  @override
  void initState() {
    super.initState();

    renderer = GamePainter(widget.game);

    ticker = createTicker(onTick);
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration elapsed) {
    final dt = (elapsed - last).inMicroseconds / 1e6;
    last = elapsed;

    widget.game.update(dt);

    renderer.repaint();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: renderer);
  }
}
