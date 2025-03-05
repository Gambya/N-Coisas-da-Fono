import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/config/objectbox.g.dart';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_dart/result_dart.dart';

class LocalConsultationStorage {
  Future<Box> _getBox() async {
    return ObjectBoxDatabase.consultationBox;
  }

  AsyncResult<Consultation> saveData(Consultation consultation) async {
    try {
      final box = await _getBox();
      await box.putAsync(consultation);
      return Success(consultation);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Consultation> getData(int id) async {
    try {
      final box = await _getBox();
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
      final box = await _getBox();
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
      final box = await _getBox();
      await box.removeAsync(id);
      return Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<List<Consultation>> query(String query) async {
    try {
      final box = await _getBox();
      QueryBuilder<Consultation> queryBuilder = box.query(
        Consultation_.title.contains(query, caseSensitive: true) |
            Consultation_.description.contains(query, caseSensitive: true),
      ) as QueryBuilder<Consultation>;

      final queryResult = queryBuilder.build();
      List<Consultation> consultations = await queryResult.findAsync();
      if (consultations.isEmpty) {
        QueryBuilder<Consultation> queryBuilderLinkOne =
            box.query() as QueryBuilder<Consultation>;
        queryBuilderLinkOne.link(
            Consultation_.patient, Patient_.name.contains(query));
        final queryBuilderLinkOneResult = queryBuilderLinkOne.build();
        consultations = await queryBuilderLinkOneResult.findAsync();
        queryBuilderLinkOneResult.close();
        queryResult.close();
        return Success(consultations);
      }

      QueryBuilder<Consultation> queryBuilderLink =
          box.query() as QueryBuilder<Consultation>;
      queryBuilderLink.link(
          Consultation_.patient, Patient_.name.contains(query));
      final queryBuilderLinkResult = queryBuilderLink.build();
      List<Consultation> consultationsWithPatient =
          await queryBuilderLinkResult.findAsync();

      final allMatches = {
        ...consultations,
        ...consultationsWithPatient,
      }.toList();

      queryResult.close();
      queryBuilderLinkResult.close();

      return Success(allMatches);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }
}
