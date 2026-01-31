import 'dart:math';

import 'package:engine/src/component.dart';
import 'package:vector_math/vector_math_64.dart';

void printComponentTree(Component root) {
  void recurse(Component component, String indent) {
    print('$indent└─ $component');
    for (final child in component.children) {
      recurse(child, '$indent   ');
    }
  }

  print(root);
  for (final child in root.children) {
    recurse(child, '');
  }
}

const tau = 2 * pi;

extension Angle on double {
  double normalisedAngle() {
    if (this >= -pi && this <= pi) {
      return this;
    }

    final normalized = this % tau;

    return normalized > pi ? normalized - tau : normalized;
  }
}

extension ListExtension<T> on List<T> {
  T random() => this[Random().nextInt(length)];
}

extension RandomExtension on Random {
  double nextDoubleBetween(double min, double max) =>
      min + nextDouble() * (max - min);
}

extension Matrix4Extension on Matrix4 {
  double getZRotation() => atan2(entry(1, 0), entry(0, 0));

  Vector3 getScale() =>
      Vector3(row0.xyz.length, row1.xyz.length, row2.xyz.length);
}

extension Vector2Extension on Vector2 {
  double getAngle() => atan2(y, x);
}
