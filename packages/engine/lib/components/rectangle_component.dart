import 'dart:ui';

import 'package:engine/component_visitor.dart';
import 'package:engine/components/transform_component.dart';

class RectangleComponent extends TransformComponent {
  RectangleComponent({
    super.position,
    super.rotation,
    super.scale,
    required this.paint,
  });

  final Paint paint;

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitRectangleComponent(this, arg);
}
