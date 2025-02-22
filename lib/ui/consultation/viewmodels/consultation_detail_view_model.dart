import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ConsultationDetailViewModel extends ChangeNotifier {
  late ConsultationWithDoctorAndPatientDto _consultation;
  final ConsultationRepository _consultationRepository;

  ConsultationDetailViewModel(this._consultationRepository);

  ConsultationWithDoctorAndPatientDto? get consultation => _consultation;

  late final registerConsultationCommand = Command0(_registerConsultation);
  late final onSaveConsultationCommand = Command0(_onSave);

  AsyncResult<Consultation> _registerConsultation() {
    return _consultationRepository
        .createConsultation(_consultation.toConsultation());
  }

  void setConsultation(ConsultationWithDoctorAndPatientDto consultationDto) {
    _consultation = consultationDto;
  }

  AsyncResult<Consultation> _onSave() async {
    return await _consultationRepository //
        .updateConsultation(_consultation.toConsultation())
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }
}
