import 'package:hive/hive.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/data/services/patient/patient_hive_adapter.dart';
import 'package:result_dart/result_dart.dart';

class LocalPatientStorage {
  late LazyBox _box;

  LocalPatientStorage() {
    _startStorage();
  }

  _startStorage() async {
    await _openBox();
  }

  _openBox() async {
    Hive.registerAdapter(PatientHiveAdapter());
    _box = await Hive.openLazyBox('patient');
  }

  AsyncResult<String> saveData(String key, String value) async {
    try {
      await _box.put(key, value);
      return Success(value);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<String> getData(String key) async {
    try {
      final data = await _box.get(key);
      return data != null
          ? Success(data)
          : Failure(LocalStorageException('Data not found'));
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<String>> getAllData() async {
    try {
      final keys = _box.keys.toList();
      List<String> allData = [];

      for (var key in keys) {
        final data = await _box.get(key);
        if (data != null) {
          allData.add(data);
        }
      }
      return Success(allData);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Unit> deleteData(String key) async {
    try {
      await _box.delete(key);
      return Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }
}
