import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/config/objectbox.g.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:result_dart/result_dart.dart';

class LocalAnnotationStorage {
  Future<Box> _getBox() async {
    return ObjectBoxDatabase.annotationBox;
  }

  AsyncResult<Annotation> saveData(Annotation annotation) async {
    try {
      final box = await _getBox();
      await box.putAsync(annotation);
      return Success(annotation);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Annotation> getData(int id) async {
    try {
      final box = await _getBox();
      final annotation = await box.getAsync(id);
      return annotation != null
          ? Success(annotation)
          : Failure(LocalStorageException('Data not found'));
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Annotation>> getAllData() async {
    try {
      final box = await _getBox();
      final allData = await box.getAllAsync() as List<Annotation>;

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

  AsyncResult<List<Annotation>> query(int id) async {
    try {
      final box = await _getBox();
      QueryBuilder<Annotation> queryBuilder =
          box.query() as QueryBuilder<Annotation>;
      queryBuilder.link(Annotation_.patient, Patient_.id.equals(id));
      final queryResult = queryBuilder.build();
      final result = await queryResult.findAsync();
      queryResult.close();
      return Success(result);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }
}
