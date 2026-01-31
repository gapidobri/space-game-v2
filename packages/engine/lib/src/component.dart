import 'dart:async';

import 'package:engine/engine.dart';
import 'package:engine/src/component_visitor.dart';

enum ComponentState { uninitialized, initializing, ready }

class Component {
  Component({Iterable<Component>? children}) {
    if (children != null) {
      addAll(children);
    }
  }

  final List<Component> _children = [];
  Component? _parent;

  ComponentState state = ComponentState.uninitialized;

  List<Component> get children => _children;

  Component? get parent => _parent;

  T add<T extends Component>(T component) {
    _children.add(component);
    component._parent = this;
    return component;
  }

  Iterable<T> addAll<T extends Component>(Iterable<T> components) {
    _children.addAll(components);
    for (final component in components) {
      component._parent = this;
    }
    return components;
  }

  void remove(Component component) {
    component._parent = null;
    _children.remove(component);
  }

  void removeAll(Iterable<Component> components) {
    for (final component in components) {
      remove(component);
    }
  }

  void removeFromParent() {
    _parent?.remove(this);
  }

  void forEachChild(bool Function(Component) callback) {
    if (!callback(this)) return;
    for (final child in children) {
      child.forEachChild(callback);
    }
  }

  Game? findGame() => parent?.findGame();

  FutureOr<void> setup() async {}

  void update(double dt) {}

  void accept<T>(ComponentVisitor<T> visitor, T arg) =>
      visitor.visitComponent(this, arg);

  @override
  String toString() => runtimeType.toString();
}
