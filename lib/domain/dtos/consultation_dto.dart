import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';

class ConsultationDto {
  int? id;
  String title;
  String description;
  late DateTime dateTime;
  String duration;
  String value;
  ConsultationStatus status;
  Patient? patient;
  Doctor? doctor;

  ConsultationDto({
    this.id,
    this.title = "",
    this.description = "",
    this.duration = "",
    this.value = "",
    this.status = ConsultationStatus.agendada,
    this.patient,
    this.doctor,
  }) {
    dateTime = DateTime.now();
  }

  Consultation toEntity() {
    int? durationValue = int.tryParse(duration);
    Consultation consultation = Consultation(
      id: id ?? 0,
      title: title,
      description: description,
      dateTime: dateTime,
      duration: durationValue ?? 0,
      value: value,
      status: status.name,
    );
    if (patient != null) {
      consultation.patient.target = patient!;
    }
    if (doctor != null) {
      consultation.doctor.target = doctor!;
    }
    return consultation;
  }
}
