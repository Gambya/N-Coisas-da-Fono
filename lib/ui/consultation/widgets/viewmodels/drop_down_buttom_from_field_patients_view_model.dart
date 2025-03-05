import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class DropDownButtomFromFieldPatientsViewModel extends ChangeNotifier {
  final PatientRepository _patientRepository;

  DropDownButtomFromFieldPatientsViewModel(this._patientRepository);

  late final _patients = <String>[];
  late String _selectedPatient = '';
  late int _selectedPatientId = 0;

  List<String> get patients => _patients;
  String get selectedPatient => _selectedPatient;
  int get selectedPatientId => _selectedPatientId;

  late final onLoadPatientsCommand = Command0(_loadPatients);
  Stream<List<Patient>> get patientsStream =>
      _patientRepository.patientObserver();

  AsyncResult<List<Patient>> _loadPatients() async {
    return await _patientRepository
        .getPatients() //
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }

  void setPatients(List<String> patients) {
    _patients.clear();
    _patients.addAll(patients);
    notifyListeners();
  }

  void setSelectedPatient(String patient) {
    _selectedPatient = patient;
    notifyListeners();
  }

  void setSelectedPatientId(int patientId) {
    _selectedPatientId = patientId;
    notifyListeners();
  }
}
