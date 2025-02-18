import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ConsultationRegisterViewModel extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;
  final PatientRepository _patientRepository;
  final DoctorRepository _doctorRepository;

  ConsultationRegisterViewModel(
    this._consultationRepository,
    this._patientRepository,
    this._doctorRepository,
  );

  Stream<List<Patient>> get patientsStream =>
      _patientRepository.patientObserver();

  late final registerConsultationCommand = Command1(_registerConsultation);

  AsyncResult<Consultation> _registerConsultation(
      ConsultationDto consultation) {
    return _consultationRepository.createConsultation(consultation.toEntity());
  }

  void loadPatients() async {
    await _patientRepository.getPatients();
    notifyListeners();
  }

  Future<int?> loadDoctor() async {
    final doctor = await _doctorRepository.getDoctor().getOrNull();
    notifyListeners();
    if (doctor != null) return doctor.id;
    return null;
  }
}
