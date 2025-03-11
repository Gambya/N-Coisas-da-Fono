import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/annotation/annotation_repository.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class AnnotationViewModel extends ChangeNotifier {
  final AnnotationRepository _annotationRepository;
  late Annotation annotation;

  AnnotationViewModel(this._annotationRepository);

  late final onRegisterAnnotationCommand = Command0(_registerAnnotation);
  late final onSaveAnnotationCommand = Command0(_updateAnnotation);

  AsyncResult<Annotation> _registerAnnotation() async {
    final result = await _annotationRepository.createAnnotation(annotation);
    notifyListeners();
    return result;
  }

  AsyncResult<Annotation> _updateAnnotation() {
    final result = _annotationRepository.updateAnnotation(annotation);
    notifyListeners();
    return result;
  }
}
