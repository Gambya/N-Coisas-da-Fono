import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:objectbox/objectbox.dart';
import 'package:result_dart/result_dart.dart';

class LocalDoctorStorage {
  late final ObjectBoxDatabase _db;

  LocalDoctorStorage(this._db);

  Future<Box> getBox() async {
    final store = await _db.getStore();
    return store.box<Doctor>();
  }

  AsyncResult<Doctor> saveData(Doctor doctor) async {
    try {
      final box = await getBox();
      await box.putAsync(doctor);
      return Success(doctor);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Doctor> getData() async {
    try {
      final box = await getBox();
      final doctor = await box.getAllAsync();
      return doctor != null
          ? Success(doctor.firstOrNull)
          : Failure(LocalStorageException('Data not found'));
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
}
