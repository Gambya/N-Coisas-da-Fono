import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ConsultationRepository {
  AsyncResult<Consultation> createConsultation(Consultation consultation);
  AsyncResult<Consultation> updateConsultation(Consultation consultation);
  AsyncResult<Unit> deleteConsultation(String id);
  AsyncResult<List<Consultation>> getConsultations();
  AsyncResult<Consultation> getConsultation(String id);
  Stream<List<Consultation>> consultationObserver();
  void dispose();
}
