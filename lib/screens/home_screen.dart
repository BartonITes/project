import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_repository.dart';
import 'add_patient_screen.dart';
import 'patient_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = PatientRepository();
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    patients = await repo.load();
    setState(() {});
  }

  void addPatient(Patient p) {
    patients.add(p);
    repo.save(patients);
    setState(() {});
  }

  void deletePatient(String id) {
    patients.removeWhere((p) => p.id == id);
    repo.save(patients);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text("Fetal Monitor"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final patient = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddPatientScreen()),
              );
              if (patient != null) addPatient(patient);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Add Patient",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,
        itemBuilder: (_, index) {
          final p = patients[index];

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(p.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gestational age: ${p.gestationalWeeks} weeks"),
                  Text(
                      "Last checkup: ${DateFormat.yMMMd().add_jm().format(p.lastCheckup)}"),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Chip(
                        label: Text(p.condition),
                        backgroundColor:
                            Colors.green.shade100,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text("${p.bpm} BPM"),
                        backgroundColor:
                            Colors.pink.shade100,
                      )
                    ],
                  )
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePatient(p.id),
              ),
              onTap: () async {
                final updatedPatient =
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          PatientDetailScreen(patient: p)),
                );

                if (updatedPatient != null) {
                  patients[index] = updatedPatient;
                  repo.save(patients);
                  setState(() {});
                }
              },
            ),
          );
        },
      ),
    );
  }
}
