import 'dart:ui';

import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/components/transform_component.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class RectangleComponent extends TransformComponent {
  RectangleComponent({
    super.position,
    super.angle,
    super.scale,
    super.anchor,
    Paint? paint,
    Vector2? size,
  }) : paint = paint ?? Paint(),
       size = size ?? Vector2.zero();

  @override
  Vector2 size;
  Paint paint;

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitRectangleComponent(this, arg);
}
