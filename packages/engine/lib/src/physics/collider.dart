import 'package:engine/src/components/transform_component.dart';

abstract class Collider extends TransformComponent {
  Collider({super.position, super.angle, super.scale, super.anchor});
}
