import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/components/transform_component.dart';
import 'package:engine/src/sprite.dart';
import 'package:vector_math/vector_math_64.dart';

class SpriteComponent extends TransformComponent {
  Sprite? sprite;

  SpriteComponent({
    this.sprite,
    super.position,
    super.angle,
    super.scale,
    super.anchor,
  });

  @override
  Vector2 get size => sprite?.size ?? Vector2.zero();

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitSpriteComponent(this, arg);
}
