import 'package:engine/engine.dart';
import 'package:engine/src/component_visitor.dart';
import 'package:flutter/painting.dart';

class TextComponent extends TransformComponent {
  TextComponent({
    required this.text,
    super.position,
    super.angle,
    super.scale,
    super.anchor,
  });

  final TextSpan text;

  @override
  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitTextComponent(this, arg);
}
