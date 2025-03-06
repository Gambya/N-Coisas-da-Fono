import 'dart:async';
import 'package:ncoisasdafono/data/exceptions/exceptions.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/services/consultation/local_consultation_storage.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_dart/result_dart.dart';

class LocalConsultationRepository implements ConsultationRepository {
  final _streamController = StreamController<List<Consultation>>.broadcast();
  final LocalConsultationStorage _storage;

  LocalConsultationRepository(this._storage);

  @override
  AsyncResult<Consultation> createConsultation(Consultation consultation) {
    return _storage
        .saveData(consultation) //
        .onSuccess((consultation) async {
      await getConsultations().onSuccess((consultations) {
        _streamController.add(consultations);
      });
    }).pure(consultation);
  }

  @override
  AsyncResult<Unit> deleteConsultation(int id) {
    return _storage
        .deleteData(id) //
        .onSuccess((_) async {
      final result = await getConsultations();
      result.onSuccess((consultations) => _streamController.add(consultations));
    });
  }

  @override
  AsyncResult<Consultation> getConsultation(int id) {
    return _storage.getData(id);
  }

  @override
  AsyncResult<List<Consultation>> getConsultations() {
    return _storage
        .getAllData() //
        .onSuccess((consultations) => _streamController.add(consultations));
  }

  @override
  AsyncResult<List<Consultation>> getConsultationsByDate(DateTime date) {
    return _storage
        .queryByDate(date) //
        .onSuccess((consultations) => _streamController.add(consultations));
  }

  @override
  AsyncResult<Consultation> updateConsultation(Consultation consultation) {
    return _storage
        .saveData(consultation) //
        .onSuccess((_) async {
      final result = await getConsultations();
      result.onSuccess((consultations) => _streamController.add(consultations));
    }).pure(consultation);
  }

  @override
  AsyncResult<List<Consultation>> searchConsultation(
      String query, DateTime date) {
    return _storage
        .query(query, date) //
        .onSuccess((consultations) => _streamController.add(consultations))
        .onFailure((e) => LocalStorageException("error on search query"));
  }

  @override
  Stream<List<Consultation>> consultationObserver() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
