import 'package:engine/component_visitor.dart';
import 'package:engine/components/transform_component.dart';
import 'package:engine/sprite.dart';

class SpriteComponent extends TransformComponent {
  Sprite? sprite;

  SpriteComponent({super.position, super.rotation, super.scale});

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitSpriteComponent(this, arg);
}
