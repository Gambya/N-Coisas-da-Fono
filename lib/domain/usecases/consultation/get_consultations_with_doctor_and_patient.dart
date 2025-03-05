import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';

class GetConsultationsWithDoctorAndPatient {
  final ConsultationRepository _consultationRepository;

  GetConsultationsWithDoctorAndPatient(
    this._consultationRepository,
  );

  late final Stream<List<ConsultationWithDoctorAndPatientDto>>
      _consultationStream = _getStream();

  Stream<List<ConsultationWithDoctorAndPatientDto>> get consultationStream =>
      _consultationStream;

  Stream<List<ConsultationWithDoctorAndPatientDto>> _getStream() {
    return _consultationRepository
        .consultationObserver()
        .asyncMap((consultations) async {
      final consultationsWithDoctorAndPatient =
          <ConsultationWithDoctorAndPatientDto>[];
      for (final consultation in consultations) {
        final consultationTemp = ConsultationWithDoctorAndPatientDto(
          id: consultation.id,
          title: consultation.title,
          description: consultation.description,
          duration: consultation.duration.toString(),
          value: consultation.value,
          status: ConsultationStatus.values.byName(consultation.status),
        );
        consultationTemp.dateTime = consultation.dateTime!;
        consultationTemp.doctor = consultation.doctor.target!;
        consultationTemp.patient = consultation.patient.target!;
        consultationsWithDoctorAndPatient.add(consultationTemp);
      }
      return consultationsWithDoctorAndPatient;
    });
  }
}
