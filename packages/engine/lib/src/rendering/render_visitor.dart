import 'package:engine/src/anchor.dart';
import 'package:engine/src/camera.dart';
import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/components/components.dart';
import 'package:engine/src/utils.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart';

final whitePaint = Paint()..color = Color(0xFFFFFFFF);

class RenderVisitor extends ComponentVisitor<void> {
  late Camera camera;
  late Canvas canvas;
  late Size size;

  int _objectCount = 0;
  int _renderCount = 0;

  int getRenderCount() => _renderCount;

  void resetRenderCount() => _renderCount = 0;

  int getObjectCount() => _objectCount;

  void resetObjectCount() => _objectCount = 0;

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
    _objectCount++;

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

    _renderCount++;

    super.visitRectangleComponent(component, arg);
  }

  @override
  void visitSpriteComponent(SpriteComponent component, void arg) {
    _objectCount++;

    if (component.sprite == null) {
      super.visitSpriteComponent(component, arg);
      return;
    }

    final sprite = component.sprite!;

    final cameraSpace = camera.cameraMatrix.multiplied(
      component.globalTransform,
    );

    final topLeft = cameraSpace
        .multiplied(
          Matrix4.translationValues(
            -component.size.x * component.anchor.x,
            -component.size.y * component.anchor.y,
            0.0,
          ),
        )
        .getTranslation();

    final topRight = cameraSpace
        .multiplied(
          Matrix4.translationValues(
            component.size.x * (1 - component.anchor.x),
            -component.size.y * component.anchor.y,
            0.0,
          ),
        )
        .getTranslation();

    final bottomLeft = cameraSpace
        .multiplied(
          Matrix4.translationValues(
            -component.size.x * component.anchor.x,
            component.size.y * (1 - component.anchor.y),
            0.0,
          ),
        )
        .getTranslation();

    final bottomRight = cameraSpace
        .multiplied(
          Matrix4.translationValues(
            component.size.x * (1 - component.anchor.x),
            component.size.y * (1 - component.anchor.y),
            0.0,
          ),
        )
        .getTranslation();

    // canvas.save();
    // canvas.drawRect(Rect.fromLTWH(topLeft.x, topLeft.y, 1, 1), whitePaint);
    // canvas.drawRect(Rect.fromLTWH(topRight.x, topRight.y, 1, 1), whitePaint);
    // canvas.drawRect(
    //   Rect.fromLTWH(bottomLeft.x, bottomLeft.y, 1, 1),
    //   whitePaint,
    // );
    // canvas.drawRect(
    //   Rect.fromLTWH(bottomRight.x, bottomRight.y, 1, 1),
    //   whitePaint,
    // );
    // canvas.restore();

    final edges = [topLeft, topRight, bottomLeft, bottomRight];

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    for (final edge in edges) {
      if (edge.x < minX) minX = edge.x;
      if (edge.x > maxX) maxX = edge.x;
      if (edge.y < minY) minY = edge.y;
      if (edge.y > maxY) maxY = edge.y;
    }

    if (maxX < 0 || maxY < 0 || minX > size.width || minY > size.height) {
      super.visitSpriteComponent(component, arg);
      return;
    }

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

    _renderCount++;

    super.visitSpriteComponent(component, arg);
  }

  @override
  void visitTextComponent(TextComponent component, void arg) {
    _objectCount++;

    final p = TextPainter(
      text: component.text,
      textDirection: TextDirection.ltr,
    );
    p.layout();
    p.paint(canvas, Offset(0, 0));

    super.visitTextComponent(component, arg);
  }
}
