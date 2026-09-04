// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_list_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandListEnvelope _$BrandListEnvelopeFromJson(Map<String, dynamic> json) =>
    BrandListEnvelope(
      data: (json['data'] as List<dynamic>)
          .map((e) => CatalogBrand.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BrandListEnvelopeToJson(BrandListEnvelope instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
