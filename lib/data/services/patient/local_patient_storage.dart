import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:objectbox/objectbox.dart';
import 'package:result_dart/result_dart.dart';

class LocalPatientStorage {
  late final ObjectBoxDatabase _db;

  LocalPatientStorage(this._db);

  Future<Box> getBox() async {
    final store = await _db.getStore();
    return store.box<Patient>();
  }

  AsyncResult<Patient> saveData(Patient patient) async {
    try {
      final box = await getBox();
      await box.putAsync(patient);
      return Success(patient);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Patient> getData(int id) async {
    try {
      final box = await getBox();
      final patient = await box.getAsync(id);
      return patient != null
          ? Success(patient)
          : Failure(LocalStorageException('Data not found'));
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Patient>> getAllData() async {
    try {
      final box = await getBox();
      final allData = await box.getAllAsync() as List<Patient>;

      return Success(allData);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Unit> deleteData(int id) async {
    try {
      final box = await getBox();
      await box.removeAsync(id);
      return Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Patient>> query([Condition<dynamic>? query]) async {
    try {
      final box = await getBox();
      final queryResult = box.query(query).build().find();
      final result = _convertList(queryResult);
      return Success(result);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  List<Patient> _convertList(List<dynamic> dados) {
    List<Patient> pacientes = [];

    for (var dado in dados) {
      // Verifique se o dado é um mapa (Map)
      if (dado is Map<String, dynamic>) {
        try {
          // Crie um objeto Patient a partir do mapa
          Patient paciente = Patient.fromJson(
              dado); // Assumindo que Patient tem um método fromJson
          pacientes.add(paciente);
        } catch (e) {
          throw Exception('Erro ao converter o dado para um objeto Patient');
        }
      }
    }

    return pacientes;
  }
}
