import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ConsultationViewModel extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;

  ConsultationViewModel(this._consultationRepository);

  Stream<List<Consultation>> get consultationStream =>
      _consultationRepository.consultationObserver();

  late final loadConsultationCommand = Command0(_loadConsultations);

  AsyncResult<List<Consultation>> _loadConsultations() async {
    final consultations = await _consultationRepository.getConsultations();
    notifyListeners();
    return consultations;
  }

  Stream<List<Consultation>> getFilteredConsultations(String query) {
    if (query.isEmpty) {
      loadConsultationCommand.execute();
      return consultationStream;
    }

    _consultationRepository.searchConsultation(query);
    return consultationStream;
  }

  @override
  void dispose() {
    _consultationRepository.dispose();
    super.dispose();
  }
}
