import 'package:flutter/foundation.dart';
import 'package:ncoisasdafono/data/repositories/annotation/annotation_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PatientDetailsViewModel extends ChangeNotifier {
  final PatientRepository _patientRepository;
  final AnnotationRepository _annotationRepository;
  late Patient patient;

  PatientDetailsViewModel(
    this._patientRepository,
    this._annotationRepository,
  );

  late final onSavePatientCommand = Command0(_onSave);
  late final onLoadAnnotationCommand = Command1(_onLoadAnnotation);

  Stream<List<Annotation>> get annotations =>
      _annotationRepository.annotationObserver();

  AsyncResult<Patient> _onSave() {
    return _patientRepository //
        .updatePatient(patient)
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }

  AsyncResult<List<Annotation>> _onLoadAnnotation(int id) {
    return _annotationRepository //
        .getAnnotations(id)
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }
}
