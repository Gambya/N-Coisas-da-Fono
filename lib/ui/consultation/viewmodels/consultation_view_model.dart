import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/usecases/consultation/get_consultations_with_doctor_and_patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ConsultationViewModel extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;
  final GetConsultationsWithDoctorAndPatient _consultationsWithDoctorAndPatient;
  late Stream<List<ConsultationWithDoctorAndPatientDto>> _consultationStream;

  ConsultationViewModel(
      this._consultationRepository, this._consultationsWithDoctorAndPatient) {
    _consultationStream = _consultationsWithDoctorAndPatient.consultationStream;
  }

  Stream<List<ConsultationWithDoctorAndPatientDto>> get consultationStream =>
      _consultationStream;

  late final loadConsultationCommand = Command0(_loadConsultations);

  AsyncResult<List<Consultation>> _loadConsultations() async {
    final consultations = await _consultationRepository.getConsultations();
    notifyListeners();
    return consultations;
  }

  void getFilteredConsultations(String query) {
    debugPrint('getFilteredConsultations called with query: $query');
    if (query.isEmpty) {
      loadConsultationCommand.execute();
    }

    _consultationStream = _consultationStream.asyncMap((consultations) =>
        consultations
            .where((c) =>
                c.patient.name.toLowerCase().contains(query.toLowerCase()) ||
                c.title.toLowerCase().contains(query.toLowerCase()) ||
                c.value.contains(query))
            .toList());
  }
}
