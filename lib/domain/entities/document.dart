import 'dart:typed_data';

import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Document {
  int id;
  String fileName;
  @Property(type: PropertyType.byteVector)
  Uint8List? bytes;

  Document({
    this.id = 0,
    this.fileName = "",
    required this.bytes,
  });

  final annotation = ToOne<Annotation>();
}
