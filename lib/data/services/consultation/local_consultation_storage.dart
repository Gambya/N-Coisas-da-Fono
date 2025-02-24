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
      // final allData = await box.getAllAsync() as List<Consultation>;
      final result = _convertList(allData);
      return Success(result);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  List<Consultation> _convertList(List<dynamic> dados) {
    List<Consultation> pacientes = [];

    for (var dado in dados) {
      // Verifique se o dado é um mapa (Map)
      if (dado is Map<String, dynamic>) {
        try {
          Consultation paciente = Consultation.fromJson(dado);
          pacientes.add(paciente);
        } catch (e) {
          throw Exception('Erro ao converter o dado para um objeto Patient');
        }
      }
    }

    return pacientes;
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
