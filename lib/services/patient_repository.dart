import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';

class PatientRepository {
  static const key = 'patients';

  Future<List<Patient>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => Patient.fromJson(e))
        .toList();
  }

  Future<void> save(List<Patient> patients) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      key,
      jsonEncode(patients.map((e) => e.toJson()).toList()),
    );
  }
}
