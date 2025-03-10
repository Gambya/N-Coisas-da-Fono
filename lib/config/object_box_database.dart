import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';

class ObjectBoxDatabase {
  static late final Store _store;
  static late final Box<Consultation> _consultationBox;
  static late final Box<Doctor> _doctorBox;
  static late final Box<Patient> _patientBox;
  static late final Box<Annotation> _annotationBox;

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _store = await openStore(
      directory: directory.path,
    );
    _consultationBox = _store.box<Consultation>();
    _doctorBox = _store.box<Doctor>();
    _patientBox = _store.box<Patient>();
    _annotationBox = _store.box<Annotation>();
  }

  static void close() {
    _store.close();
  }

  static Box<Consultation> get consultationBox => _consultationBox;

  static Box<Doctor> get doctorBox => _doctorBox;

  static Box<Patient> get patientBox => _patientBox;

  static Box<Annotation> get annotationBox => _annotationBox;

  static Store get store => _store;
}
