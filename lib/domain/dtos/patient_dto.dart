import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:uuid/uuid.dart';

class PatientDto {
  late String id;
  String name;
  String email;
  String phone;
  String? cpf;
  String? rg;

  PatientDto({
    this.name = "",
    this.email = "",
    this.phone = "",
    this.cpf,
    this.rg,
  }) {
    id = Uuid().v4();
  }

  Patient toEntity() {
    return Patient(
      id: id,
      name: name,
      email: email,
      phone: phone,
      cpf: cpf,
      rg: rg,
    );
  }
}
