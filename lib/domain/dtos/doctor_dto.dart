import 'package:ncoisasdafono/domain/entities/doctor.dart';

class DoctorDto {
  int? id;
  String name;
  String email;
  String? photoUrl;
  String phone;
  String crfa;
  String specialty;
  String address;

  DoctorDto({
    this.id,
    this.name = "",
    this.email = "",
    this.photoUrl,
    this.phone = "",
    this.crfa = "",
    this.specialty = "",
    this.address = "",
  });

  Doctor toEntity() {
    return Doctor(
      id: id ??= 0,
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
