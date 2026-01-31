import 'dart:collection';
import 'dart:ui';

import 'package:engine/engine.dart';
import 'package:flutter/services.dart';

class Sprite {
  final Image image;
  final Rect? src;

  const Sprite({required this.image, this.src});

  Vector2 get size {
    if (src != null) {
      return Vector2(src!.width, src!.height);
    }
    return Vector2(image.width.toDouble(), image.height.toDouble());
  }

  static final _cache = HashMap<String, Image>();

  static Future<Sprite> load(String path, {Rect? src}) async {
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

    return Sprite(image: image, src: src);
  }
}
