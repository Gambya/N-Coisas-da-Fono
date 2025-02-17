import 'package:hive_flutter/adapters.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';

class ConsultationHiveAdapter extends TypeAdapter<Consultation> {
  @override
  final typeId = 0;

  @override
  Consultation read(BinaryReader reader) {
    return Consultation(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      dateTime: reader.read(),
      duration: reader.readInt(),
      value: reader.read(),
      status: reader.read(),
      patientId: reader.readString(),
      doctorId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Consultation obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.dateTime);
    writer.write(obj.duration);
    writer.write(obj.value);
    writer.write(obj.status);
    writer.write(obj.patientId);
    writer.write(obj.doctorId);
  }
}
