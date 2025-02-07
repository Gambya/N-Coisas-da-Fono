import 'dart:async';
import 'dart:convert';

import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/services/consultation/local_consultation_storage.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_dart/result_dart.dart';

class LocalConsultationRepository implements ConsultationRepository {
  final _streamController = StreamController<Consultation>.broadcast();
  final LocalConsultationStorage _storage;

  LocalConsultationRepository(this._storage);

  @override
  AsyncResult<Consultation> createConsultation(Consultation consultation) {
    return _storage
        .saveData(consultation.id, jsonEncode(consultation.toJson())) //
        .pure(consultation);
  }

  @override
  AsyncResult<Unit> deleteConsultation(String id) {
    return _storage.deleteData(id);
  }

  @override
  AsyncResult<Consultation> getConsultation(String id) {
    return _storage
        .getData(id) //
        .map((json) => Consultation.fromJson(jsonDecode(json)));
  }

  @override
  AsyncResult<List<Consultation>> getConsultations() {
    return _storage
        .getAllData() //
        .map((jsonList) => jsonList
            .map((json) => Consultation.fromJson(jsonDecode(json)))
            .toList());
  }

  @override
  AsyncResult<Consultation> updateConsultation(Consultation consultation) {
    return _storage
        .saveData(consultation.id, jsonEncode(consultation.toJson())) //
        .pure(consultation);
  }

  @override
  Stream<Consultation> consultationObserver() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
