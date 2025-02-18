import 'package:ncoisasdafono/domain/entities/patient.dart';

class PatientDto {
  int? id;
  String name;
  String email;
  String phone;
  String? cpf;
  String? rg;

  PatientDto({
    this.id,
    this.name = "",
    this.email = "",
    this.phone = "",
    this.cpf,
    this.rg,
  });

  Patient toEntity() {
    return Patient(
      id: id ??= 0,
      name: name,
      email: email,
      phone: phone,
      cpf: cpf,
      rg: rg,
    );
  }
}
