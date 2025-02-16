import 'package:lucid_validation/lucid_validation.dart';
import 'package:ncoisasdafono/domain/dtos/doctor_dto.dart';

class DoctorValidator extends LucidValidator<DoctorDto> {
  DoctorValidator() {
    ruleFor((doctor) => doctor.email, key: 'email') //
        .notEmpty(message: "É necessário o preenchimento do email")
        .validEmail(message: 'E-mail inválido');

    ruleFor((doctor) => doctor.name, key: 'name') //
        .notEmpty(message: "É necessário o preenchimento do nome")
        .minLength(3, message: 'Nome deve ter no mínimo 3 caracteres');

    ruleFor((doctor) => doctor.phone, key: 'phone') //
        .notEmpty(message: "É necessário o preenchimento do telefone/celular")
        .minLength(15, message: 'Telefone/celular inválido');

    ruleFor((doctor) => doctor.crfa, key: 'crfa') //
        .notEmpty()
        .minLength(6, message: 'CRFa deve ter no mínimo 5 caracteres');

    ruleFor((doctor) => doctor.address, key: 'address') //
        .notEmpty(message: "É necessário o preenchimento do endereço");
  }
}
