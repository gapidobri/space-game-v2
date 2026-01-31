import 'dart:ui';

import 'package:engine/src/anchor.dart';
import 'package:engine/src/camera.dart';
import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/components/components.dart';
import 'package:engine/src/utils.dart';
import 'package:vector_math/vector_math_64.dart';

final whitePaint = Paint()..color = Color(0xFFFFFFFF);

class RenderVisitor extends ComponentVisitor<void> {
  late Camera camera;
  late Canvas canvas;
  late Size size;

  void _applyTransform(Matrix4 transform, {Vector2? size, Anchor? anchor}) {
    final cameraSpaceTransform = camera.cameraMatrix.multiplied(transform);

    final translation = cameraSpaceTransform.getTranslation();
    canvas.translate(translation.x, translation.y);

    final angle = cameraSpaceTransform.getZRotation();
    canvas.rotate(angle);

    final scale = cameraSpaceTransform.getScale();
    canvas.scale(scale.x, scale.y);

    if (size != null && anchor != null) {
      canvas.translate(-size.x * anchor.x, -size.y * anchor.y);
    }
  }

  @override
  void visitRectangleComponent(RectangleComponent component, void arg) {
    canvas.save();
    _applyTransform(
      component.globalTransform,
      size: component.size,
      anchor: component.anchor,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, component.size.x, component.size.y),
      component.paint,
    );
    canvas.restore();

    super.visitRectangleComponent(component, arg);
  }

  @override
  void visitSpriteComponent(SpriteComponent component, void arg) {
    if (component.sprite == null) {
      super.visitSpriteComponent(component, arg);
      return;
    }

    final sprite = component.sprite!;

    canvas.save();
    _applyTransform(
      component.globalTransform,
      size: component.sprite!.size,
      anchor: component.anchor,
    );
    if (component.sprite!.src != null) {
      canvas.drawImageRect(
        sprite.image,
        sprite.src!,
        Rect.fromLTWH(0, 0, sprite.src!.width, sprite.src!.height),
        whitePaint,
      );
    } else {
      canvas.drawImage(component.sprite!.image, Offset.zero, whitePaint);
    }
    canvas.restore();

    super.visitSpriteComponent(component, arg);
  }
}
