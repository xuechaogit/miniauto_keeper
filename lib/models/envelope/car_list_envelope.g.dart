// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_list_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarListEnvelope _$CarListEnvelopeFromJson(Map<String, dynamic> json) =>
    CarListEnvelope(
      data: (json['data'] as List<dynamic>)
          .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarListEnvelopeToJson(CarListEnvelope instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
