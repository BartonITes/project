import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/patient_repository.dart';
import 'add_patient_screen.dart';
import 'patient_detail_screen.dart';

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
      appBar: AppBar(
        title: const Text("Fetal Monitor"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final p = patients[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ListTile(
              title: Text(p.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text("Gestational Age: ${p.gestationalWeeks} weeks"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePatient(p.id),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailScreen(patient: p),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF2D7A),
        child: const Icon(Icons.add),
        onPressed: () async {
          final patient = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPatientScreen()),
          );
          if (patient != null) addPatient(patient);
        },
      ),
    );
  }
}
