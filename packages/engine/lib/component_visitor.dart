import 'package:engine/component.dart';
import 'package:engine/components/components.dart';

class ComponentVisitor<T> {
  void visitComponent(Component component, T arg) {
    for (final child in component.children) {
      child.accept(this, arg);
    }
  }

  void visitTransformComponent(TransformComponent component, T arg) =>
      visitComponent(component, arg);

  void visitRectangleComponent(RectangleComponent component, T arg) =>
      visitComponent(component, arg);

  void visitSpriteComponent(SpriteComponent component, T arg) =>
      visitComponent(component, arg);
}
