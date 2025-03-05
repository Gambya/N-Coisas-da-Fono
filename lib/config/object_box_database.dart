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

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _store = await openStore(
      directory: directory.path,
    );
    _consultationBox = _store.box<Consultation>();
    _doctorBox = _store.box<Doctor>();
    _patientBox = _store.box<Patient>();
  }

  static void close() {
    _store.close();
  }

  /// Retorna o Box<Consultation>
  static Box<Consultation> get consultationBox => _consultationBox;

  /// Retorna o Box<Doctor>
  static Box<Doctor> get doctorBox => _doctorBox;

  /// Retorna o Box<Patient>
  static Box<Patient> get patientBox => _patientBox;

  /// Retorna o Store (se necessário para operações avançadas)
  static Store get store => _store;
}
