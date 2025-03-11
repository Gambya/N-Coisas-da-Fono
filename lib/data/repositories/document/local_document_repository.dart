import 'package:ncoisasdafono/data/repositories/document/document_repository.dart';
import 'package:ncoisasdafono/data/services/document/local_document_storage.dart';
import 'package:result_dart/src/types.dart';
import 'package:result_dart/src/unit.dart';

class LocalDocumentRepository implements DocumentRepository {
  final LocalDocumentStorage _storage;

  LocalDocumentRepository(this._storage);

  @override
  AsyncResult<Unit> deleteDocument(int id) {
    return _storage.deleteData(id);
  }
}
