import 'package:decimal/decimal.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';

class ConsultationDto {
  late String id;
  String title;
  String description;
  late DateTime dateTime;
  int duration;
  late Decimal value;
  ConsultationStatus status;
  String patientId;
  String doctorId;

  ConsultationDto({
    this.title = "",
    this.description = "",
    this.duration = 0,
    this.status = ConsultationStatus.agendada,
    this.patientId = "",
    this.doctorId = "",
  }) {
    dateTime = DateTime.now();
    value = Decimal.parse('0.0');
  }

  Consultation toEntity() {
    return Consultation(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      duration: duration,
      value: value,
      status: status,
      patientId: patientId,
      doctorId: doctorId,
    );
  }
}
