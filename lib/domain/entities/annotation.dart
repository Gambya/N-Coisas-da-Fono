import 'package:ncoisasdafono/domain/entities/document.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Annotation {
  int id;
  String text;
  @Property(type: PropertyType.date)
  late DateTime createdAt;

  Annotation({
    this.id = 0,
    required this.text,
  }) {
    createdAt = DateTime.now();
  }

  final documents = ToMany<Document>();

  final patient = ToOne<Patient>();
}
