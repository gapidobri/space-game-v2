import 'package:vector_math/vector_math_64.dart';

class Camera {
  Camera({required this.resolution});

  final Vector2 resolution;

  Vector2 position = Vector2.zero();

  Matrix4 get cameraMatrix {
    final m = Matrix4.identity();
    m.translateByVector3(Vector3(-position.x, -position.y, 0.0));
    return m;
  }
}
