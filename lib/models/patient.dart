class Patient {
  final String id;
  final String name;
  final int gestationalWeeks;
  final String condition;
  final int bpm;
  final DateTime lastCheckup;

  Patient({
    required this.id,
    required this.name,
    required this.gestationalWeeks,
    required this.condition,
    required this.bpm,
    required this.lastCheckup,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gestationalWeeks': gestationalWeeks,
        'condition': condition,
        'bpm': bpm,
        'lastCheckup': lastCheckup.toIso8601String(),
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'],
        name: json['name'],
        gestationalWeeks: json['gestationalWeeks'],
        condition: json['condition'],
        bpm: json['bpm'],
        lastCheckup: DateTime.parse(json['lastCheckup']),
      );
}
