// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogBrand _$CatalogBrandFromJson(Map<String, dynamic> json) => CatalogBrand(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  logoUrl: json['logo_url'] as String? ?? '',
  country: json['country'] as String? ?? '',
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CatalogBrandToJson(CatalogBrand instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'country': instance.country,
      'sort_order': instance.sortOrder,
    };
