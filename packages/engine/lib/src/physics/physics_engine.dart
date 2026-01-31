import 'package:engine/engine.dart';

class PhysicsEngine {
  static void calculate(double dt, Component root) {
    // TODO: optimise
    root.forEachChild((c) {
      if (c is! PhysicsBody || c.static) {
        return true;
      }

      c.acceleration += _calculateGravityAcceleration(c) * dt;
      c.velocity += c.acceleration * dt;
      c.position += c.velocity * dt;

      return false;
    });
  }

  static Vector2 _calculateGravityAcceleration(PhysicsBody body) {
    Vector2 acceleration = Vector2.zero();

    // TODO

    return acceleration;
  }
}
