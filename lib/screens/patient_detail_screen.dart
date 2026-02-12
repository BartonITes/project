import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/esp32_service.dart';
import '../widgets/ecg_chart.dart';
import '../utils/heartbeat_sound.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState
    extends State<PatientDetailScreen> {
  final Esp32Service esp32 = Esp32Service();
  final HeartbeatSound sound = HeartbeatSound();

  int bpm = 0;
  bool playing = false;
  bool connected = false;
  List<double> ecgData = [];

  @override
  void initState() {
    super.initState();

    esp32.connect();

    esp32.connectionStream.listen((status) {
      setState(() {
        connected = status;
      });
    });

    esp32.bpmStream.listen((value) {
      setState(() {
        bpm = value;
      });

      if (playing) sound.start(bpm);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context,
                Patient(
                  id: p.id,
                  name: p.name,
                  gestationalWeeks:
                      p.gestationalWeeks,
                  condition: bpm >= 120 &&
                          bpm <= 160
                      ? "Normal"
                      : "Routine Monitoring",
                  bpm: bpm,
                  lastCheckup: DateTime.now(),
                ));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              connected ? "Connected" : "Connecting...",
              style: TextStyle(
                  color: connected
                      ? Colors.green
                      : Colors.orange),
            ),
            const SizedBox(height: 20),
            Text("$bpm BPM",
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF2D7A))),
            const SizedBox(height: 20),
            EcgChart(data: ecgData),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF2D7A),
              ),
              onPressed: () {
                setState(() {
                  playing = !playing;
                });

                if (playing) {
                  sound.start(bpm);
                } else {
                  sound.stop();
                }
              },
              child: Text(
                  playing ? "Stop Sound" : "Play Sound"),
            )
          ],
        ),
      ),
    );
  }
}
