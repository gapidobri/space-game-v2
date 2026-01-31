import 'package:just_audio/just_audio.dart';
import 'package:uuid/v4.dart';

class AudioEngine {
  static final _players = <String, AudioPlayer>{};
  static var _pausedPlayers = <AudioPlayer>[];

  static Future<Sound> load(
    String path, {
    bool loop = false,
    bool autoDispose = true,
    double volume = 1.0,
  }) async {
    final player = AudioPlayer();
    final id = UuidV4().generate();

    _players[id] = player;

    await player.setAsset(path);
    await player.setVolume(volume);
    if (loop) {
      await player.setLoopMode(LoopMode.one);
    }

    if (autoDispose) {
      player.playerStateStream.firstWhere((event) {
        if (event.processingState == ProcessingState.completed) {
          _stop(id);
          return true;
        }
        return false;
      });
    }

    return Sound._(id);
  }

  static Future<void> resume() async {
    await Future.wait(_pausedPlayers.map((p) => p.play()));
    _pausedPlayers = [];
  }

  static Future<void> pause() async {
    if (_pausedPlayers.isNotEmpty) return;
    _pausedPlayers = _players.values.where((p) => p.playing).toList();
    await Future.wait(_pausedPlayers.map((p) => p.pause()));
  }

  static void _play(String playerId) {
    _players[playerId]?.play();
  }

  static void _pause(String playerId) {
    _players[playerId]?.pause();
  }

  static void _stop(String playerId) async {
    final player = _players[playerId];
    if (player == null) return;
    await player.dispose();
    _players.remove(playerId);
  }
}

class Sound {
  final String _playerId;

  Sound._(String playerId) : _playerId = playerId;

  void play() => AudioEngine._play(_playerId);

  void pause() => AudioEngine._pause(_playerId);

  void stop() => AudioEngine._stop(_playerId);
}
