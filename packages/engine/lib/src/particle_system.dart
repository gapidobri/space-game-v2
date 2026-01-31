import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:engine/engine.dart';
import 'package:engine/src/timer.dart';

class ParticleSystem extends Component {
  final List<Particle> _particles = [];

  void spawnEmitter({
    required Vector2 position,
    required double angle,
    required double speed,
    required List<Color> colorPalette,
  }) {
    final emitter = Emitter(
      particleSystem: this,
      position: position,
      angle: angle,
      speed: speed,
      colorPalette: colorPalette,
    );
    add(emitter);
  }

  void addParticle(Particle particle) {
    _particles.add(particle);
    add(particle);
  }

  void clear() {
    removeAll(_particles);
    _particles.clear();
  }

  @override
  void update(double dt) {
    for (final particle in _particles) {
      if (particle._isDead) {
        remove(particle);
      }
    }
    _particles.removeWhere((p) => p._isDead);
  }
}

class Emitter extends TransformComponent {
  Emitter({
    super.position,
    super.angle,
    required this.particleSystem,
    required this.speed,
    required this.colorPalette,
    this.oneShot = true,
    this.particleRate,
  });

  final ParticleSystem particleSystem;
  final double speed;
  final List<Color> colorPalette;
  final bool oneShot;
  final double? particleRate;

  late final Timer? _timer;

  bool _enabled = true;

  @override
  FutureOr<void> setup() {
    final random = Random();

    if (oneShot) {
      for (int i = 0; i < speed / 2; i++) {
        particleSystem.addParticle(
          Particle(
            position:
                position +
                Vector2(
                  (random.nextDouble() - 0.5) * 5,
                  (random.nextDouble() - 0.5) * 5,
                ),
            angle: angle + (random.nextDouble() - 0.5) * pi,
            speed: 5 + random.nextDouble() * speed,
            lifetime: 1 + random.nextDouble() * 5,
            size: Vector2.all(2 + random.nextDouble() * 2),
            color: colorPalette.random(),
          ),
        );
      }

      removeFromParent();
    }

    if (particleRate != null) {
      _timer = Timer(
        duration: 1 / particleRate!,
        repeat: true,
        onTick: () {
          particleSystem.addParticle(
            Particle(
              position: absolutePosition,
              angle:
                  absoluteAngle -
                  pi / 2 +
                  (random.nextDoubleBetween(-0.3, 0.3)),
              speed: speed,
              lifetime: random.nextDoubleBetween(0.3, 0.7),
              color: colorPalette.random(),
              size: Vector2.all(2),
            ),
          );
        },
      );
    }
  }

  @override
  void update(double dt) {
    if (_enabled) {
      _timer?.update(dt);
    }
  }

  void start() {
    _enabled = true;
  }

  void stop() {
    _enabled = false;
  }
}

class Particle extends PhysicsBody {
  Particle({
    super.position,
    super.angle,
    Vector2? size,
    this.color = const Color(0xFFFFFFFF),
    this.lifetime = 2,
    this.speed = 1,
  }) : size = size ?? Vector2.all(10),
       super(mass: 0);

  final Vector2 size;
  final Color color;
  final double lifetime;
  final double speed;

  late final Timer _timer;

  bool _isDead = false;

  late final RectangleComponent _rectangleComponent;

  @override
  FutureOr<void> setup() {
    _rectangleComponent = RectangleComponent()
      ..paint.color = color
      ..size = size
      ..anchor = Anchor.center;
    add(_rectangleComponent);

    // add(RectangleHitbox(size: size));

    velocity = Vector2(cos(angle), sin(angle)) * -speed;

    _timer = Timer(duration: lifetime, onTick: () => _isDead = true);
  }

  @override
  void update(double dt) {
    _timer.update(dt);
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is Planet) {
  //     final normal = (position - other.position).normalized();
  //
  //     final reflectedVelocity = velocity - normal * (2 * velocity.dot(normal));
  //
  //     velocity = reflectedVelocity * 0.5;
  //
  //     final planetRadius = 50;
  //     final mySize = size.x / 2;
  //
  //     final targetDistance = planetRadius + mySize;
  //     final actualDistance = position.distanceTo(other.position);
  //
  //     final penetration = targetDistance - actualDistance;
  //     if (penetration > 0) {
  //       position += normal * penetration;
  //     }
  //   }
  //   super.onCollision(intersectionPoints, other);
  // }
}
