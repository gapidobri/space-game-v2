import 'package:engine/src/camera.dart';
import 'package:engine/src/component.dart';
import 'package:engine/src/physics/physics_engine.dart';
import 'package:engine/src/rendering/render_visitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

class Game extends Component {
  Game({Camera? camera})
    : camera = camera ?? Camera(resolution: Vector2(800, 450));

  Camera camera;

  final Set<PhysicalKeyboardKey> pressedKeys = {};

  bool paused = false;

  final _renderVisitor = RenderVisitor();

  @override
  @mustCallSuper
  void setup() async {
    _renderVisitor.camera = camera;
  }

  @override
  @mustCallSuper
  void update(double dt) {
    if (paused) return;

    _initializePending();
    _callUpdates(dt);
    _calculatePhysics(dt);
  }

  void _initializePending() => forEachChild((c) {
    if (c.state != ComponentState.uninitialized) {
      return true;
    }

    (() async {
      c.state = ComponentState.initializing;
      await c.setup();
      c.state = ComponentState.ready;
    })();

    return true;
  });

  void _callUpdates(double dt) {
    void recurse(Component parent) {
      if (parent.state == ComponentState.ready) {
        parent.update(dt);
        for (final child in parent.children) {
          recurse(child);
        }
      }
    }

    for (final child in children) {
      recurse(child);
    }
  }

  void _calculatePhysics(double dt) {
    PhysicsEngine.calculate(dt, this);
  }

  void render(Canvas canvas, Size size) {
    _renderVisitor.canvas = canvas;
    _renderVisitor.size = size;
    accept(_renderVisitor, null);
  }

  @override
  Game? findGame() => this;
}
