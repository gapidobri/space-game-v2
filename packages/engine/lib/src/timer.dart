class Timer {
  Timer({required this.duration, this.repeat = false, required this.onTick});

  final double duration;
  final bool repeat;
  final void Function() onTick;

  double _collector = 0.0;
  bool _done = false;

  void update(double dt) {
    if (_done) return;

    _collector += dt;
    if (_collector > duration) {
      _collector -= duration;
      if (!repeat) {
        _done = true;
      }
      onTick();
    }
  }
}
