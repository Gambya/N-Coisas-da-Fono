// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsultationImpl _$$ConsultationImplFromJson(Map<String, dynamic> json) =>
    _$ConsultationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      duration: json['duration'] as String,
      status: json['status'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
    );

Map<String, dynamic> _$$ConsultationImplToJson(_$ConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateTime': instance.dateTime.toIso8601String(),
      'duration': instance.duration,
      'status': instance.status,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
    };
