import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
sealed class Patient with _$Patient {
  @HiveType(typeId: 0)
  const factory Patient({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) required String phone,
    @HiveField(4) String? cpf,
    @HiveField(5) String? rg,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}
