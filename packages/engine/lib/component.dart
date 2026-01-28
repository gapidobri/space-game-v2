import 'dart:async';

import 'package:engine/component_visitor.dart';

class Component {
  final List<Component> _children = [];
  Component? _parent;

  List<Component> get children => _children;

  Component? get parent => _parent;

  void add(Component component) {
    _children.add(component);
    component._parent = this;
  }

  void remove(Component object) {
    object._parent = null;
    _children.remove(object);
  }

  void removeFromParent() {
    if (_parent == null) return;
    _parent?.remove(this);
    _parent = null;
  }

  Future<void> setup() async {}

  void update(double dt) {}

  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitComponent(this, arg);
}
