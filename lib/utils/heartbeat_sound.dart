import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class HeartbeatSound {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  void start(int bpm) {
    stop();

    final interval = Duration(milliseconds: (60000 / bpm).round());

    _timer = Timer.periodic(interval, (_) async {
      await _player.play(AssetSource('sounds/heartbeat.wav'));
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
