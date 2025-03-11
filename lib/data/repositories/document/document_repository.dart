import 'package:result_dart/result_dart.dart';

abstract interface class DocumentRepository {
  AsyncResult<Unit> deleteDocument(int id);
}
