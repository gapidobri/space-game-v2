import 'dart:math';
import 'dart:ui';

import 'package:engine/component_visitor.dart';
import 'package:engine/components/rectangle_component.dart';
import 'package:engine/components/sprite_component.dart';
import 'package:engine/components/transform_component.dart';
import 'package:vector_math/vector_math.dart';

final whitePaint = Paint()..color = Color(0xFFFFFFFF);

class RenderVisitor extends ComponentVisitor<Matrix4> {
  late Canvas canvas;
  late Size size;

  @override
  void visitTransformComponent(TransformComponent component, Matrix4 arg) {
    final worldTransform = arg.multiplied(component.localTransform);
    for (final child in component.children) {
      child.accept(this, worldTransform);
    }
  }

  @override
  void visitRectangleComponent(RectangleComponent component, Matrix4 arg) {
    final worldTransform = arg.multiplied(component.localTransform);
    final translation = worldTransform.getTranslation();

    canvas.drawRect(
      Rect.fromLTWH(translation.x, translation.y, 100, 100),
      component.paint,
    );

    super.visitRectangleComponent(component, arg);
  }

  @override
  void visitSpriteComponent(SpriteComponent component, Matrix4 arg) {
    final worldTransform = arg.multiplied(component.localTransform);
    final translation = worldTransform.getTranslation();
    final rotation = atan2(worldTransform.row1.x, worldTransform.row0.x);

    if (component.sprite != null) {
      final sprite = component.sprite!;

      canvas.save();
      if (rotation != 0) {
        canvas.translate(
          sprite.size.x * sprite.anchor.x,
          sprite.size.y * sprite.anchor.y,
        );
        canvas.rotate(rotation);
        canvas.translate(
          -sprite.size.x * sprite.anchor.x,
          -sprite.size.y * sprite.anchor.y,
        );
      }
      if (component.sprite!.src != null) {
        canvas.drawImageRect(
          sprite.image,
          sprite.src!,
          Rect.fromLTWH(0, 0, sprite.src!.width, sprite.src!.height),
          whitePaint,
        );
      } else {
        canvas.drawImage(
          component.sprite!.image,
          Offset(translation.x, translation.y),
          whitePaint,
        );
      }
      canvas.restore();
    }

    super.visitSpriteComponent(component, arg);
  }
}
