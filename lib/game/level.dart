import 'dart:math';

import 'package:collection/collection.dart';
import 'package:engine/engine.dart';
import 'package:space_game/game/alien.dart';
import 'package:space_game/game/human_player.dart';
import 'package:space_game/game/planet.dart';
import 'package:space_game/game/rocket.dart';

class Level extends Component {
  Level({required this.planetCount, required this.astronautCount});

  final int planetCount;
  final int astronautCount;

  late final ParticleSystem particleSystem;

  late final Rocket rocket;
  final List<Planet> planets = [];
  final List<Alien> aliens = [];

  @override
  Future<void> setup() async {
    particleSystem = add(ParticleSystem());

    rocket = add(Rocket());
    add(HumanPlayer(rocket: rocket));

    _loadPlanets();

    aliens.add(Alien(position: Vector2(0, 100)));
    aliens.add(Alien(position: Vector2(100, 0)));
    addAll(aliens);
  }

  void _loadPlanets() {
    final rnd = Random();

    for (int i = 0; i < planetCount; i++) {
      Vector2 pos;
      do {
        pos = Vector2(
          (rnd.nextDouble() - 0.5) * 1000,
          (rnd.nextDouble() - 0.5) * 1000,
        );
      } while (planets.firstWhereOrNull(
            (p) => p.position.distanceTo(pos) <= 150,
          ) !=
          null);

      final type = rnd.nextInt(4);
      planets.add(
        Planet(position: pos, type: type, hasAstronaut: i < astronautCount),
      );
    }
    addAll(planets);
  }
}
