import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Consultation {
  int id;
  String title;
  String description;
  @Property(type: PropertyType.date)
  DateTime? dateTime;
  int duration;
  String value;
  String status;

  Consultation({
    this.id = 0,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.duration,
    required this.value,
    required this.status,
  });

  final doctor = ToOne<Doctor>();
  final patient = ToOne<Patient>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Consultation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Consultation.fromJson(Map<String, dynamic> json) {
    Consultation consultations = Consultation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: json['dateTime'],
      duration: json['duration'],
      value: json['value'],
      status: json['status'],
    );
    if (json['doctor'] != null) {
      consultations.doctor.target = Doctor.fromJson(json['doctor']);
    }
    if (json['patient'] != null) {
      consultations.patient.target = Patient.fromJson(json['patient']);
    }
    return consultations;
  }
}

enum ConsultationStatus { agendada, confirmada, realizada, cancelada }
