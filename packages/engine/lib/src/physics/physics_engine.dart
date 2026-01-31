import 'package:engine/engine.dart';

class PhysicsEngine {
  static void calculate(double dt, Component root) {
    root.forEachChild((c) {
      if (c is! PhysicsBody || c.static) {
        return true;
      }

      // c.acceleration += _calculateGravityAcceleration(c, root) * dt;
      c.velocity += c.acceleration * dt;
      c.position += c.velocity * dt;

      return false;
    });
  }

  static Vector2 _calculateGravityAcceleration(
    PhysicsBody body,
    Component root,
  ) {
    const double G = 10;

    Vector2 acceleration = Vector2.zero();

    root.forEachChild((c) {
      if (body == c || c is! PhysicsBody) {
        return true;
      }

      final direction = c.position - body.position;
      final distanceSquared = direction.length2;

      if (distanceSquared < 25) return false;

      final forceMagnitude = G * c.mass / distanceSquared;

      acceleration += direction.normalized() * forceMagnitude;

      return false;
    });

    return acceleration;
  }
}
