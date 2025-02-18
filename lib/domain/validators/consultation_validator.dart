import 'package:lucid_validation/lucid_validation.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_dto.dart';

class ConsultationValidator extends LucidValidator<ConsultationDto> {
  ConsultationValidator() {
    ruleFor((consultation) => consultation.title, key: 'title')
        .notEmpty(message: "É necessário o preenchimento do título")
        .minLength(3, message: "O título deve ter no mínimo 3 caracteres");

    ruleFor((consultation) => consultation.dateTime, key: 'dateTime')
        .greaterThanOrEqualTo(DateTime.now(),
            message: "Data de consulta não pode ser anterior a data atual");

    ruleFor((consultation) => consultation.duration, key: 'duration')
        .notEmpty()
        .mustHaveNumber(message: "A duração deve ser um número em minutos");

    ruleFor((consultation) => consultation.value, key: 'value')
        .notEmpty()
        .mustHaveNumber(message: "O valor deve ser um número");

    // ruleFor((consultation) => consultation.patientId, key: 'patient')
    //     .notEmpty(message: "Paciente tem que ser selecionado");
  }
}
