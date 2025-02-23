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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Doctor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
