import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:objectbox/objectbox.dart';
import 'package:result_dart/result_dart.dart';

class LocalPatientStorage {
  Future<Box> _getBox() async {
    return ObjectBoxDatabase.patientBox;
  }

  AsyncResult<Patient> saveData(Patient patient) async {
    try {
      final box = await _getBox();
      await box.putAsync(patient);
      return Success(patient);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Patient> getData(int id) async {
    try {
      final box = await _getBox();
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
      final box = await _getBox();
      final allData = await box.getAllAsync() as List<Patient>;

      return Success(allData);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Unit> deleteData(int id) async {
    try {
      final box = await _getBox();
      await box.removeAsync(id);
      return Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Patient>> query([Condition<dynamic>? query]) async {
    try {
      final box = await _getBox();
      final queryResult = await box.query(query).build().findAsync();
      final result = queryResult as List<Patient>;
      return Success(result);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }
}
