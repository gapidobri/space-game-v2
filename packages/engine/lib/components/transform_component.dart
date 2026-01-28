import 'package:engine/component.dart';
import 'package:engine/component_visitor.dart';
import 'package:vector_math/vector_math.dart';

class TransformComponent extends Component {
  TransformComponent({Vector2? position, this.rotation = 0.0, Vector2? scale})
    : position = position ?? Vector2.zero(),
      scale = scale ?? Vector2.all(1.0);

  Vector2 position;
  double rotation;
  Vector2 scale;

  Matrix4 get localTransform {
    final m = Matrix4.identity();
    m.translateByVector3(Vector3(position.x, position.y, 0));
    m.rotateZ(rotation);
    m.scaleByVector3(Vector3(scale.x, scale.y, 1));
    return m;
  }

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitTransformComponent(this, arg);
}
