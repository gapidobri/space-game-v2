import 'dart:math';

import 'package:engine/src/anchor.dart';
import 'package:engine/src/component.dart';
import 'package:engine/src/component_visitor.dart';
import 'package:engine/src/utils.dart';
import 'package:vector_math/vector_math_64.dart';

class TransformComponent extends Component {
  TransformComponent({
    Vector2? position,
    double? angle,
    Vector2? scale,
    this.anchor = Anchor.topLeft,
  }) : position = position ?? Vector2.zero(),
       _angle = angle ?? 0.0,
       scale = scale ?? Vector2.all(1.0);

  Vector2 position;
  double _angle;
  Vector2 scale;
  Anchor anchor;

  // Matrix4 worldTransform = Matrix4.identity();

  double get angle => _angle;

  set angle(double angle) => _angle = angle.normalisedAngle();

  Matrix4 get localTransform {
    final m = Matrix4.identity();
    m.translateByVector3(Vector3(position.x, position.y, 0));
    m.rotateZ(_angle);
    m.scaleByVector3(Vector3(scale.x, scale.y, 1));

    return m;
  }

  Matrix4 get globalTransform {
    Matrix4 transform = localTransform;
    Component? nextParent = parent;
    while (nextParent != null) {
      if (nextParent is TransformComponent) {
        transform = nextParent.localTransform * transform;
      }
      nextParent = nextParent.parent;
    }
    return transform;
  }

  Vector2 get absolutePosition => globalTransform.getTranslation().xy;

  double get absoluteAngle => globalTransform.getZRotation();

  Vector2 get absoluteScale => globalTransform.getScale().xy;

  // void updateWorldTransform(Matrix4 parentWorldTransform) {
  //   worldTransform = parentWorldTransform * localTransform;
  // }

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitTransformComponent(this, arg);

  @override
  String toString() =>
      '$runtimeType(x: ${position.x}, y: ${position.y}, angle: $_angle)';
}
