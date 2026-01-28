import 'dart:async';

import 'package:engine/src/camera.dart';
import 'package:engine/src/component.dart';
import 'package:engine/src/rendering/render_visitor.dart';
import 'package:engine/src/world.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game {
  Game({required this.world, required this.camera}) {
    Game.game = this;
  }

  static late Game game;

  final World world;
  final Camera camera;
  final Set<PhysicalKeyboardKey> pressedKeys = {};

  final _renderVisitor = RenderVisitor();

  bool paused = false;

  void setup() async {
    // TODO: move to GameWidget
    WidgetsFlutterBinding.ensureInitialized();

    final futures = <Future<void>>[];

    void recurse(Component parent) {
      futures.add(parent.setup());
      for (final child in parent.children) {
        recurse(child);
      }
    }

    recurse(world);

    await Future.wait(futures);
  }

  void update(double dt) {
    if (paused) return;

    void recurse(Component parent) {
      parent.update(dt);
      for (final child in parent.children) {
        recurse(child);
      }
    }

    recurse(world);
  }

  void render(Canvas canvas, Size size) {
    _renderVisitor.canvas = canvas;
    _renderVisitor.size = size;
    world.accept(_renderVisitor, camera.cameraMatrix);
  }
}
