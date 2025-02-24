import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_dart/result_dart.dart';

class GetConsultationsWithDoctorAndPatient {
  final ConsultationRepository _consultationRepository;
  final DoctorRepository _doctorRepository;
  final PatientRepository _patientRepository;

  GetConsultationsWithDoctorAndPatient(
    this._consultationRepository,
    this._doctorRepository,
    this._patientRepository,
  );

  Stream<List<ConsultationWithDoctorAndPatientDto>> get consultationStream =>
      _consultationRepository
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
