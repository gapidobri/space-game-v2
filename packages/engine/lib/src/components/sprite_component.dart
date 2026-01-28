import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/components/transform_component.dart';
import 'package:engine/src/sprite.dart';

class SpriteComponent extends TransformComponent {
  Sprite? sprite;

  SpriteComponent({super.position, super.rotation, super.scale});

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitSpriteComponent(this, arg);
}
