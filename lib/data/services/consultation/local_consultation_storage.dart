import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/config/objectbox.g.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_dart/result_dart.dart';

class LocalConsultationStorage {
  late final ObjectBoxDatabase _db;

  LocalConsultationStorage(this._db);

  Future<Box> getBox() async {
    final store = await _db.getStore();
    return store.box<Consultation>();
  }

  AsyncResult<Consultation> saveData(Consultation consultation) async {
    try {
      final box = await getBox();
      await box.putAsync(consultation);
      return Success(consultation);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Consultation> getData(int id) async {
    try {
      final box = await getBox();
      final consultation = await box.getAsync(id);
      return consultation != null
          ? Success(consultation)
          : Failure(LocalStorageException('Data not found'));
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Consultation>> getAllData() async {
    try {
      final box = await getBox();
      final allData = box
          .query()
          .order(Consultation_.dateTime) //
          .build()
          .find();
      return Success(allData as List<Consultation>);
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
