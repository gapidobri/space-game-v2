class Anchor {
  final double x, y;

  const Anchor(this.x, this.y);

  static const topLeft = Anchor(0, 0);
  static const topCenter = Anchor(0.5, 0);
  static const topRight = Anchor(1, 0);
  static const centerLeft = Anchor(0, 0.5);
  static const center = Anchor(0.5, 0.5);
  static const centerRight = Anchor(1, 0.5);
  static const bottomLeft = Anchor(0, 1);
  static const bottomCenter = Anchor(0.5, 1);
  static const bottomRight = Anchor(1, 1);
}
