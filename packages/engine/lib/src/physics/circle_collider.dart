import 'package:engine/src/physics/collider.dart';

class CircleCollider extends Collider {
  final double radius;

  CircleCollider({
    required this.radius,
    super.position,
    super.angle,
    super.scale,
    super.anchor,
  });
}
