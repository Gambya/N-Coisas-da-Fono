import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:uuid/uuid.dart';

class DoctorDto {
  late String id;
  String name;
  String email;
  String? photoUrl;
  String phone;
  String crfa;
  String specialty;
  String address;

  DoctorDto({
    this.name = "",
    this.email = "",
    this.photoUrl,
    this.phone = "",
    this.crfa = "",
    this.specialty = "Fonoaudióloga",
    this.address = "",
  }) {
    id = Uuid().v4().toString();
  }

  Doctor toEntity() {
    return Doctor(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      phone: phone,
      crfa: crfa,
      specialty: specialty,
      address: address,
    );
  }
}
