import 'dart:async';
import 'package:ncoisasdafono/config/objectbox.g.dart';
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
    return checkCpfRgEmail(patient).flatMap((_) {
      return _storage
          .saveData(patient)
          .flatMap((_) => getPatients())
          .onSuccess((patients) => _streamController.add(patients))
          .pure(patient);
    });
  }

  AsyncResult<Unit> checkCpfRgEmail(Patient patient) {
    return _checkCpf(patient.cpf!).flatMap((_) {
      return _checkRg(patient.rg!).flatMap((_) {
        return _checkEmail(patient.email);
      });
    });
  }

  AsyncResult<Unit> _checkCpf(String cpf) {
    return _storage.query(Patient_.cpf.equals(cpf)).flatMap((result) {
      if (result.isNotEmpty) {
        return Failure(Exception('CPF já cadastrado'));
      } else {
        return Success(unit);
      }
    });
  }

  AsyncResult<Unit> _checkRg(String rg) {
    return _storage.query(Patient_.rg.equals(rg)).flatMap((result) {
      if (result.isNotEmpty) {
        return Failure(Exception('RG já cadastrado'));
      } else {
        return Success(unit);
      }
    });
  }

  AsyncResult<Unit> _checkEmail(String email) {
    return _storage.query(Patient_.email.equals(email)).flatMap((result) {
      if (result.isNotEmpty) {
        return Failure(Exception('Email já cadastrado'));
      } else {
        return Success(unit);
      }
    });
  }

  @override
  AsyncResult<Unit> deletePatient(int id) {
    return _storage
        .deleteData(id) //
        .onSuccess((_) async {
      final result = await getPatients();
      result.onSuccess((patients) => _streamController.add(patients));
    });
  }

  @override
  AsyncResult<Patient> getPatient(int id) {
    return _storage.getData(id);
  }

  @override
  AsyncResult<List<Patient>> getPatients() async {
    return await _storage
        .getAllData()
        .onSuccess((patients) => _streamController.add(patients));
  }

  @override
  AsyncResult<Patient> updatePatient(Patient patient) {
    return _storage
        .saveData(patient) //
        .onSuccess((_) async {
      final result = await getPatients();
      result.onSuccess((patients) => _streamController.add);
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
