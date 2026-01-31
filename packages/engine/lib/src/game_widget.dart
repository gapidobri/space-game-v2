import 'package:engine/src/game.dart';
import 'package:engine/src/rendering/painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key, required this.game});

  final Game game;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  late final GamePainter painter;
  late final Ticker ticker;

  Duration last = Duration.zero;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    HardwareKeyboard.instance.addHandler(onKeyboardEvent);

    painter = GamePainter(widget.game);

    ticker = createTicker(onTick);
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();

    HardwareKeyboard.instance.removeHandler(onKeyboardEvent);

    super.dispose();
  }

  bool onKeyboardEvent(KeyEvent event) {
    switch (event) {
      case KeyDownEvent e:
        widget.game.pressedKeys.add(e.physicalKey);
        break;
      case KeyUpEvent e:
        widget.game.pressedKeys.remove(e.physicalKey);
        break;
    }
    return true;
  }

  void onTick(Duration elapsed) {
    final dt = (elapsed - last).inMicroseconds / 1e6;
    last = elapsed;

    widget.game.update(dt);

    painter.repaint();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: CustomPaint(painter: painter, size: Size.infinite),
    );
  }
}
