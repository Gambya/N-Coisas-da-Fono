import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AnnotationRepository {
  AsyncResult<Annotation> createAnnotation(Annotation annotation);
  AsyncResult<Annotation> updateAnnotation(Annotation annotation);
  AsyncResult<Unit> deleteAnnotation(int id, int patientId);
  AsyncResult<List<Annotation>> getAnnotations(int patientId);
  AsyncResult<Annotation> getAnnotation(int id);
  Stream<List<Annotation>> annotationObserver();
  void dispose();
}
