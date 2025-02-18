import 'package:decimal/decimal.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';

class ConsultationDto {
  int? id;
  String title;
  String description;
  late DateTime dateTime;
  String duration;
  String value;
  ConsultationStatus status;
  int? patientId;
  int? doctorId;

  ConsultationDto({
    this.id,
    this.title = "",
    this.description = "",
    this.duration = "",
    this.value = "",
    this.status = ConsultationStatus.agendada,
    this.patientId,
    this.doctorId,
  }) {
    dateTime = DateTime.now();
  }

  Consultation toEntity() {
    int? durationValue = int.tryParse(duration);
    Decimal? decimalValue = Decimal.tryParse(value);
    return Consultation(
      id: id ??= 0,
      title: title,
      description: description,
      dateTime: dateTime,
      duration: durationValue!,
      value: decimalValue!.toString(),
      status: status.toString(),
      patientId: patientId!,
      doctorId: doctorId!,
    );
  }
}
