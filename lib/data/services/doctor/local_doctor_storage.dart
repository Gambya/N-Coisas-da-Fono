import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:objectbox/objectbox.dart';
import 'package:result_dart/result_dart.dart';

class LocalDoctorStorage {
  Future<Box> _getBox() async {
    return ObjectBoxDatabase.doctorBox;
  }

  AsyncResult<Doctor> saveData(Doctor doctor) async {
    try {
      final box = await _getBox();
      await box.putAsync(doctor);
      return Success(doctor);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Doctor> getData() async {
    try {
      final box = await _getBox();
      final doctor = await box.getAllAsync();
      return Success(doctor.firstOrNull);
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
}
