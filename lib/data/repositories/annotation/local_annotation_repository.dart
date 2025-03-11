import 'dart:async';

import 'package:ncoisasdafono/data/repositories/annotation/annotation_repository.dart';
import 'package:ncoisasdafono/data/services/annotation/local_annotation_storage.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:result_dart/result_dart.dart';

class LocalAnnotationRepository implements AnnotationRepository {
  final _streamController = StreamController<List<Annotation>>.broadcast();
  final LocalAnnotationStorage _storage;

  LocalAnnotationRepository(this._storage);

  @override
  Stream<List<Annotation>> annotationObserver() {
    return _streamController.stream;
  }

  @override
  AsyncResult<Annotation> createAnnotation(Annotation annotation) async {
    return await _storage
        .saveData(annotation) //
        .flatMap((annotation) => getAnnotations(annotation.patient.targetId))
        .onSuccess((annotation) => _streamController.add(annotation))
        .pure(annotation);
  }

  @override
  AsyncResult<Unit> deleteAnnotation(int id, int patientId) async {
    return await _storage
        .deleteData(id) //
        .onSuccess((_) async {
      final result = await getAnnotations(patientId);
      result.onSuccess((annotation) => _streamController.add(annotation));
    });
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  AsyncResult<Annotation> getAnnotation(int id) async {
    return await _storage.getData(id);
  }

  @override
  AsyncResult<List<Annotation>> getAnnotations(int patientId) async {
    return await _storage
        .query(patientId)
        .onSuccess((patients) => _streamController.add(patients));
  }

  @override
  AsyncResult<Annotation> updateAnnotation(Annotation annotation) {
    return _storage
        .saveData(annotation) //
        .onSuccess((_) async {
      final result = await getAnnotations(annotation.patient.targetId);
      result.onSuccess((annotations) => _streamController.add(annotations));
    }).pure(annotation);
  }
}
