import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class PatientRepository {
  AsyncResult<Patient> createPatient(Patient patient);
  AsyncResult<Patient> updatePatient(Patient patient);
  AsyncResult<Unit> deletePatient(int id);
  AsyncResult<List<Patient>> getPatients();
  AsyncResult<Patient> getPatient(int id);
  Stream<List<Patient>> patientObserver();
  void dispose();
}
