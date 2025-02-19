import 'package:flutter/widgets.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;
  final DoctorRepository _doctorRepository;

  HomeViewModel(this._consultationRepository, this._doctorRepository);

  Stream<List<Consultation>> get consultationStream =>
      _consultationRepository.consultationObserver();

  late final loadConsultationCommand = Command0(_loadConsultations);
  late final loadDoctorCommand = Command0(_loadDoctor);

  AsyncResult<List<Consultation>> _loadConsultations() async {
    final consultations = await _consultationRepository.getConsultations();
    notifyListeners();
    return consultations;
  }

  AsyncResult<Doctor> _loadDoctor() async {
    final doctor = await _doctorRepository.getDoctor();
    notifyListeners();
    return doctor;
  }
}
