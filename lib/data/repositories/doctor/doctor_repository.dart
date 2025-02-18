import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class DoctorRepository {
  AsyncResult<Doctor> createDoctor(Doctor doctor);
  AsyncResult<Doctor> updateDoctor(Doctor doctor);
  AsyncResult<Unit> deleteDoctor(int id);
  AsyncResult<Doctor> getDoctor(int id);
  Stream<Doctor> doctorObserver();
  void dispose();
}
