import 'package:lucid_validation/lucid_validation.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_dto.dart';

class ConsultationValidator extends LucidValidator<ConsultationDto> {
  ConsultationValidator() {
    ruleFor((consultation) => consultation.title, key: 'title')
        .notEmpty(message: "É necessário o preenchimento do '{PropertyName}'")
        .minLength(3,
            message: "'{PropertyName}' deve ter no mínimo 3 caracteres");

    ruleFor((consultation) => consultation.dateTime, key: 'dateTime')
        .greaterThanOrEqualTo(DateTime.now(),
            message: "'{PropertieName}' não pode ser anterior a data atual");

    ruleFor((consultation) => consultation.duration, key: 'duration')
        .min(0, message: "'{PropertieName}' não pode ser menor que 0");

    ruleFor((consultation) => consultation.patientId, key: 'patient')
        .notEmpty(message: "'{PropertieName}' tem que ser selecionado");
  }
}
