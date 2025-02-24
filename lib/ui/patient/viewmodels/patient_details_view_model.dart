import 'package:flutter/foundation.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PatientDetailsViewModel extends ChangeNotifier {
  final PatientRepository _patientRepository;
  late Patient patient;

  PatientDetailsViewModel(this._patientRepository);

  late final onSavePatientCommand = Command0(_onSave);

  AsyncResult<Patient> _onSave() {
    return _patientRepository //
        .updatePatient(patient)
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }
}
