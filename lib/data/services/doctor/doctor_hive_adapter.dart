import 'package:hive_flutter/adapters.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';

class DoctorHiveAdapter extends TypeAdapter<Doctor> {
  @override
  final typeId = 1;

  @override
  Doctor read(BinaryReader reader) {
    return Doctor(
      id: reader.readString(),
      name: reader.readString(),
      email: reader.readString(),
      photoUrl: reader.readString(),
      phone: reader.readString(),
      crfa: reader.readString(),
      specialty: reader.readString(),
      address: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.photoUrl);
    writer.write(obj.phone);
    writer.write(obj.crfa);
    writer.write(obj.specialty);
    writer.write(obj.address);
  }
}
