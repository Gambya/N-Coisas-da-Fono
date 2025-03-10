import 'dart:async';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/services/doctor/local_doctor_storage.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_dart/result_dart.dart';

class LocalDoctorRepository implements DoctorRepository {
  final _streamController = StreamController<Doctor>.broadcast();
  final LocalDoctorStorage _storage;

  LocalDoctorRepository(this._storage);

  @override
  AsyncResult<Doctor> createDoctor(Doctor doctor) {
    return _storage
        .saveData(doctor) //
        .onSuccess((doctor) => _streamController.add)
        .pure(doctor);
  }

  @override
  AsyncResult<Unit> deleteDoctor(int id) {
    return _storage.deleteData(id);
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Stream<Doctor> doctorObserver() {
    return _streamController.stream;
  }

  @override
  AsyncResult<Doctor> getDoctor() {
    return _storage
        .getData()
        .onSuccess((doctor) => _streamController.add(doctor));
  }

  @override
  AsyncResult<Doctor> updateDoctor(Doctor doctor) {
    return _storage
        .saveData(doctor) //
        .onSuccess((doctor) => _streamController.add)
        .pure(doctor);
  }
}
