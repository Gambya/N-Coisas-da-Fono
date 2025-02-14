import 'package:hive_flutter/adapters.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';

class DoctorHiveAdapter extends TypeAdapter<Doctor> {
  @override
  final typeId = 1;

  @override
  Doctor read(BinaryReader reader) {
    return Doctor(
      id: reader.read(),
      name: reader.read(),
      email: reader.read(),
      photoUrl: reader.read(),
      phone: reader.read(),
      crm: reader.read(),
      specialty: reader.read(),
      address: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.photoUrl);
    writer.write(obj.phone);
    writer.write(obj.crm);
    writer.write(obj.specialty);
    writer.write(obj.address);
  }
}
