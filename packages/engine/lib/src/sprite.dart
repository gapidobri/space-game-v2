import 'dart:collection';
import 'dart:ui';

import 'package:engine/engine.dart';
import 'package:flutter/services.dart';

class Sprite {
  final Image image;
  final Rect? src;
  final Anchor anchor;

  const Sprite({required this.image, this.src, Anchor? anchor})
    : anchor = anchor ?? Anchor.topLeft;

  Vector2 get size {
    if (src != null) {
      return Vector2(src!.width, src!.height);
    }
    return Vector2(image.width.toDouble(), image.height.toDouble());
  }

  static final _cache = HashMap<String, Image>();

  static Future<Sprite> load(String path, {Rect? src, Anchor? anchor}) async {
    late Image image;

    if (_cache.containsKey(path)) {
      image = _cache[path]!;
    } else {
      final assetImageByteData = await rootBundle.load(path);
      final codec = await instantiateImageCodec(
        assetImageByteData.buffer.asUint8List(),
      );
      image = (await codec.getNextFrame()).image;
      _cache[path] = image;
    }

    return Sprite(image: image, src: src, anchor: anchor);
  }
}

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
