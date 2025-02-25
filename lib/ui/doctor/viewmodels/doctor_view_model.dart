import 'package:flutter/widgets.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _doctorRepository;

  DoctorViewModel(this._doctorRepository);

  Stream<Doctor> get doctorsStream => _doctorRepository.doctorObserver();

  late final loadDoctorsCommand = Command0(_loadDoctors);

  AsyncResult<Doctor> _loadDoctors() {
    return _doctorRepository
        .getDoctor() //
        .onSuccess((_) => notifyListeners())
        .onFailure((e) => Failure(e));
  }
}
