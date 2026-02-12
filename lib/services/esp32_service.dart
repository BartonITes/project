import 'dart:async';
import 'dart:math';

class Esp32Service {
  final _bpmController = StreamController<int>.broadcast();
  final _ecgController = StreamController<double>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<int> get bpmStream => _bpmController.stream;
  Stream<double> get ecgStream => _ecgController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  Timer? _timer;
  final Random _random = Random();
  double _time = 0;
  int _bpm = 140;

  void connect() {
    // simulate wifi delay
    Future.delayed(const Duration(seconds: 1), () {
      _connectionController.add(true);
    });

    _timer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      _time += 0.02;

      double ecgValue = sin(2 * pi * _time * (_bpm / 60));
      ecgValue += (_random.nextDouble() - 0.5) * 0.15;

      _ecgController.add(ecgValue);

      if (_random.nextDouble() < 0.02) {
        _bpm += _random.nextInt(3) - 1;
        _bpm = _bpm.clamp(120, 160);
        _bpmController.add(_bpm);
      }
    });

    _bpmController.add(_bpm);
  }

  void disconnect() {
    _timer?.cancel();
    _connectionController.add(false);
  }
}
