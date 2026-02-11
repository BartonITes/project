import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/esp32_service.dart';
import '../widgets/ecg_chart.dart';
import '../utils/heartbeat_sound.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final Esp32Service esp32 = Esp32Service();
  final HeartbeatSound sound = HeartbeatSound();

  int bpm = 0;
  bool playing = false;
  List<double> ecgData = [];

  @override
  void initState() {
    super.initState();

    esp32.connect();

    esp32.bpmStream.listen((value) {
      setState(() {
        bpm = value;
      });

      if (playing) {
        sound.start(bpm);
      }
    });

    esp32.ecgStream.listen((value) {
      setState(() {
        ecgData.add(value);
        if (ecgData.length > 200) {
          ecgData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    esp32.disconnect();
    sound.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "$bpm BPM",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            EcgChart(data: ecgData),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  playing = !playing;
                });

                if (playing) {
                  sound.start(bpm == 0 ? 140 : bpm);
                } else {
                  sound.stop();
                }
              },
              child: Text(playing ? "Stop Sound" : "Play Sound"),
            ),
          ],
        ),
      ),
    );
  }
}
