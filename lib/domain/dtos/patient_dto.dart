import 'package:ncoisasdafono/domain/entities/patient.dart';

class PatientDto {
  int? id;
  String name;
  String email;
  String phone;
  String? photoUrl;
  String? cpf;
  String? rg;

  PatientDto({
    this.id,
    this.name = "",
    this.email = "",
    this.phone = "",
    this.photoUrl,
    this.cpf,
    this.rg,
  });

  Patient toEntity() {
    return Patient(
      id: id ??= 0,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      cpf: cpf,
      rg: rg,
    );
  }
}
