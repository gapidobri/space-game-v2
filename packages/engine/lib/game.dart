import 'dart:async';

import 'package:engine/camera.dart';
import 'package:engine/component.dart';
import 'package:engine/renderer/render_visitor.dart';
import 'package:engine/world.dart';
import 'package:flutter/material.dart';

class Game {
  Game({required this.world, required this.camera});

  final World world;
  final Camera camera;

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

    camera.position.x -= 50 * dt;

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
