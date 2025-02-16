import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/dtos/patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PatientRegisterViewModel extends ChangeNotifier {
  final PatientRepository _patientRepository;

  PatientRegisterViewModel(this._patientRepository);

  late final registerPatientCommand = Command1(_registerPatient);
  late final updatePatientCommand = Command1(_updatePatient);

  AsyncResult<Patient> _registerPatient(PatientDto patient) {
    return _patientRepository.createPatient(patient.toEntity());
  }

  AsyncResult<Patient> _updatePatient(PatientDto patient) {
    return _patientRepository.updatePatient(patient.toEntity());
  }
}
