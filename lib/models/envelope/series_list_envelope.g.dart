// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_list_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesListEnvelope _$SeriesListEnvelopeFromJson(Map<String, dynamic> json) =>
    SeriesListEnvelope(
      data: (json['data'] as List<dynamic>)
          .map((e) => Series.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesListEnvelopeToJson(SeriesListEnvelope instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
