import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'consultation.freezed.dart';
part 'consultation.g.dart';

@freezed
sealed class Consultation with _$Consultation {
  @HiveType(typeId: 0)
  const factory Consultation({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required DateTime dateTime,
    @HiveField(4) required int duration,
    @HiveField(5) required Decimal value,
    @HiveField(6) required ConsultationStatus status,
    @HiveField(7) required String patientId,
    @HiveField(8) required String doctorId,
  }) = _Consultation;

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);
}

enum ConsultationStatus { agendada, confirmada, realizada, cancelada }
