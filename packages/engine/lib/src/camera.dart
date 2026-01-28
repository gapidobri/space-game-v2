import 'package:vector_math/vector_math.dart';

class Camera {
  final Vector2 position = Vector2.zero();

  Matrix4 get cameraMatrix {
    final m = Matrix4.identity();
    m.translateByVector3(Vector3(-position.x, -position.y, 0.0));
    return m;
  }
}
