import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final nameCtrl = TextEditingController();
  final weeksCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Patient")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Patient Name"),
            ),
            TextField(
              controller: weeksCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Gestational Weeks"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2D7A),
              ),
              onPressed: () {
                if (nameCtrl.text.isEmpty ||
                    weeksCtrl.text.isEmpty) return;

                Navigator.pop(
                  context,
                  Patient(
                    id: const Uuid().v4(),
                    name: nameCtrl.text,
                    gestationalWeeks:
                        int.parse(weeksCtrl.text),
                    condition: "Normal",
                    bpm: 140,
                    lastCheckup: DateTime.now(),
                  ),
                );
              },
              child: const Text("Add Patient"),
            )
          ],
        ),
      ),
    );
  }
}
