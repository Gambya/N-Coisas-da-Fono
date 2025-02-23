import 'package:objectbox/objectbox.dart';

@Entity()
class Consultation {
  int id;
  String title;
  String description;
  @Property(type: PropertyType.date)
  late DateTime dateTime;
  int duration;
  String value;
  String status;
  int patientId;
  int? doctorId;

  Consultation({
    this.id = 0,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.duration,
    required this.value,
    required this.status,
    required this.patientId,
    required this.doctorId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Consultation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum ConsultationStatus { agendada, confirmada, realizada, cancelada }
