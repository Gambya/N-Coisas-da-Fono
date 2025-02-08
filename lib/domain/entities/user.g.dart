// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'runtimeType': instance.$type,
    };

_$NotLoggedUserImpl _$$NotLoggedUserImplFromJson(Map<String, dynamic> json) =>
    _$NotLoggedUserImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NotLoggedUserImplToJson(_$NotLoggedUserImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$LoggedUserImpl _$$LoggedUserImplFromJson(Map<String, dynamic> json) =>
    _$LoggedUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LoggedUserImplToJson(_$LoggedUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };
