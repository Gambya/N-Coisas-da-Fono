import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/config/objectbox.g.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:result_dart/result_dart.dart';

class LocalDocumentStorage {
  Future<Box> _getBox() async {
    return ObjectBoxDatabase.documentBox;
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
