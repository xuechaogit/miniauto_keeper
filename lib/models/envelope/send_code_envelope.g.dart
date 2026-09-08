// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_code_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendCodeEnvelope _$SendCodeEnvelopeFromJson(Map<String, dynamic> json) =>
    SendCodeEnvelope(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$SendCodeEnvelopeToJson(SendCodeEnvelope instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
