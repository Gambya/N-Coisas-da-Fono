import 'package:lucid_validation/lucid_validation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';

class PatientValidator extends LucidValidator<Patient> {
  PatientValidator() {
    ruleFor((patient) => patient.name, key: 'name')
        .notEmpty(message: 'É necessário o preenchimento do nome')
        .minLength(3, message: 'Nome deve ter no mínimo 3 caracteres');

    ruleFor((patient) => patient.email, key: 'email')
        .notEmpty(message: 'É necessário o preenchimento do email')
        .validEmail(message: 'E-mail inválido');

    ruleFor((patient) => patient.phone, key: 'phone')
        .notEmpty(message: 'É necessário o preenchimento do telefone/celular')
        .minLength(15, message: 'Telefone/celular inválido');
  }
}
