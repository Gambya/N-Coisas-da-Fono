import 'package:objectbox/objectbox.dart';

@Entity()
class Patient {
  int id;
  String name;
  String email;
  String phone;
  String? photoUrl;
  String? cpf;
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
}
