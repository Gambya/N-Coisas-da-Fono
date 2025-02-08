import 'dart:async';
import 'dart:convert';

import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/data/services/patient/local_patient_storage.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_dart/result_dart.dart';

class LocalPatientRepository implements PatientRepository {
  final _streamController = StreamController<Patient>.broadcast();
  final LocalPatientStorage _storage;

  LocalPatientRepository(this._storage);

  @override
  AsyncResult<Patient> createPatient(Patient patient) {
    return _storage
        .saveData(patient.id, jsonEncode(patient.toJson())) //
        .pure(patient);
  }

  @override
  AsyncResult<Unit> deletePatient(String id) {
    return _storage.deleteData(id);
  }

  @override
  AsyncResult<Patient> getPatient(String id) {
    return _storage
        .getData(id) //
        .map((json) => Patient.fromJson(jsonDecode(json)));
  }

  @override
  AsyncResult<List<Patient>> getPatients() {
    return _storage
        .getAllData() //
        .map((jsonList) => jsonList
            .map((json) => Patient.fromJson(jsonDecode(json)))
            .toList());
  }

  @override
  AsyncResult<Patient> updatePatient(Patient patient) {
    return _storage
        .saveData(patient.id, jsonEncode(patient.toJson())) //
        .pure(patient);
  }

  @override
  Stream<Patient> patientObserver() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
