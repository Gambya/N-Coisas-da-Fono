import 'dart:async';
import 'dart:convert';

import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/data/services/patient/local_patient_storage.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_dart/result_dart.dart';

class LocalPatientRepository implements PatientRepository {
  final _streamController = StreamController<List<Patient>>.broadcast();
  final LocalPatientStorage _storage;

  LocalPatientRepository(this._storage);

  @override
  AsyncResult<Patient> createPatient(Patient patient) {
    return _storage
        .saveData(patient.id, patient) //
        .onSuccess((_) async {
      final result = await getPatients();
      result.onSuccess((consultations) => _streamController.add(consultations));
    }).pure(patient);
  }

  @override
  AsyncResult<Unit> deletePatient(String id) {
    return _storage
        .deleteData(id) //
        .onSuccess((_) async {
      final result = await getPatients();
      result.onSuccess((patients) => _streamController.add(patients));
    });
  }

  @override
  AsyncResult<Patient> getPatient(String id) {
    return _storage
        .getData(id) //
        .map((json) => Patient.fromJson(jsonDecode(json)));
  }

  @override
  AsyncResult<List<Patient>> getPatients() async {
    return await _storage
        .getAllData() //
        .map((jsonList) =>
            jsonList.map((json) => Patient.fromJson(jsonDecode(json))).toList())
        .onSuccess((patients) => _streamController.add);
  }

  @override
  AsyncResult<Patient> updatePatient(Patient patient) {
    return _storage
        .saveData(patient.id, patient) //
        .onSuccess((_) async {
      final result = await getPatients();
      result.onSuccess((patients) => _streamController.add(patients));
    }).pure(patient);
  }

  @override
  Stream<List<Patient>> patientObserver() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
