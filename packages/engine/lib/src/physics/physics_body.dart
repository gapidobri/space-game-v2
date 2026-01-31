import 'package:engine/engine.dart';

class PhysicsBody extends TransformComponent {
  PhysicsBody({
    super.position,
    super.angle,
    super.scale,
    this.mass = 0,
    this.static = false,
  });

  final double mass;
  final bool static;

  Vector2 acceleration = Vector2.zero();
  Vector2 velocity = Vector2.zero();
}
