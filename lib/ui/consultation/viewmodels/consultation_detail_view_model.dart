import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ConsultationDetailViewModel extends ChangeNotifier {
  late Consultation _consultation;
  final ConsultationRepository _consultationRepository;

  ConsultationDetailViewModel(this._consultationRepository);

  Consultation? get consultation => _consultation;

  late final onSaveConsultationCommand = Command0(_onSave);

  void setConsultation(Consultation consultationDto) {
    _consultation = consultationDto;
  }

  AsyncResult<Consultation> _onSave() async {
    return await _consultationRepository //
        .updateConsultation(_consultation)
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }
}
