import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Doctor {
  int id;
  String name;
  String email;
  String? photoUrl;
  String phone;
  String crfa;
  String specialty;
  String address;

  Doctor({
    this.id = 0,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.phone,
    required this.crfa,
    required this.specialty,
    required this.address,
  });

  @Backlink('doctor')
  final consultations = ToMany<Consultation>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Doctor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      crfa: json['crfa'],
      specialty: json['specialty'],
      address: json['address'],
    );
  }
}
