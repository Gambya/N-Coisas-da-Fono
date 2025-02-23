import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository _repository;

  PatientViewModel(this._repository);

  Stream<List<Patient>> get patientsStream => _repository.patientObserver();

  late final loadPatientsCommand = Command0(_loadPatients);

  AsyncResult<List<Patient>> _loadPatients() async {
    final patients = await _repository.getPatients();
    notifyListeners();
    return patients;
  }
}
