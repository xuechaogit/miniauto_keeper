// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verification _$VerificationFromJson(Map<String, dynamic> json) => Verification(
  email: json['email'] as String?,
  expiresIn: (json['expires_in'] as num?)?.toInt(),
  code: json['code'] as String?,
);

Map<String, dynamic> _$VerificationToJson(Verification instance) =>
    <String, dynamic>{
      'email': instance.email,
      'expires_in': instance.expiresIn,
      'code': instance.code,
    };
