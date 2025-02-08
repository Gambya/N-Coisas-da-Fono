import 'package:hive_flutter/adapters.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';

class PatientHiveAdapter extends TypeAdapter<Patient> {
  @override
  final typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    return Patient(
      id: reader.read(),
      name: reader.read(),
      email: reader.read(),
      phone: reader.read(),
      cpf: reader.read(),
      rg: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.phone);
    writer.write(obj.cpf);
    writer.write(obj.rg);
  }
}
