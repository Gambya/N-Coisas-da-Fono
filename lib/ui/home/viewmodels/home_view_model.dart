import 'package:flutter/widgets.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  final DoctorRepository _doctorRepository;

  HomeViewModel(this._doctorRepository);

  Stream<Doctor> get doctorStream => _doctorRepository.doctorObserver();

  late final loadDoctorCommand = Command0(_loadDoctor);

  AsyncResult<Doctor> _loadDoctor() async {
    final doctor = await _doctorRepository.getDoctor();
    notifyListeners();
    return doctor;
  }
}
