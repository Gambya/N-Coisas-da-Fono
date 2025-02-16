import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/domain/dtos/doctor_dto.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class DoctorRegisterViewModel extends ChangeNotifier {
  final DoctorRepository _doctorRepository;

  DoctorRegisterViewModel(this._doctorRepository);

  late final registerDoctorCommand = Command1(_registerDoctor);

  AsyncResult<Doctor> _registerDoctor(DoctorDto doctor) {
    return _doctorRepository.createDoctor(doctor.toEntity());
  }
}
