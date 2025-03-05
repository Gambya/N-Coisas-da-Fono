import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Patient {
  int id;
  @Unique()
  String name;
  @Unique()
  String email;
  String phone;
  String? photoUrl;
  @Unique()
  String? cpf;
  @Unique()
  String? rg;

  Patient({
    this.id = 0,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.cpf,
    this.rg,
  });

  @Backlink('patient')
  final consultations = ToMany<Consultation>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Patient && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      cpf: json['cpf'],
      rg: json['rg'],
    );
  }
}
