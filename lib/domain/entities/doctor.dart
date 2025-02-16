import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
sealed class Doctor with _$Doctor {
  @HiveType(typeId: 0)
  const factory Doctor({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) required String? photoUrl,
    @HiveField(4) required String phone,
    @HiveField(5) required String crfa,
    @HiveField(6) required String specialty,
    @HiveField(7) required String address,
  }) = _Doctor;

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
}
