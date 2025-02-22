import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';

class ConsultationWithDoctorAndPatientDto {
  int? id;
  String title;
  String description;
  late DateTime dateTime;
  String duration;
  String value;
  ConsultationStatus status;
  late Patient patient;
  late Doctor doctor;

  ConsultationWithDoctorAndPatientDto({
    this.id,
    this.title = "",
    this.description = "",
    this.duration = "",
    this.value = "",
    this.status = ConsultationStatus.agendada,
  }) {
    dateTime = DateTime.now();
  }

  Consultation toConsultation() {
    final durationTemp = int.tryParse(duration);
    return Consultation(
      id: id!,
      title: title,
      description: description,
      dateTime: dateTime,
      duration: durationTemp ?? 0,
      value: value,
      status: status.name,
      patientId: patient.id,
      doctorId: doctor.id,
    );
  }
}
