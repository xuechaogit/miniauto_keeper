// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  thumb: json['thumb'] as String? ?? '',
  price: json['price'] as String? ?? '',
  description: json['description'] as String? ?? '',
  brandId: (json['brand_id'] as num?)?.toInt() ?? 0,
  brand: json['brand'] == null
      ? const CatalogBrand()
      : CatalogBrand.fromJson(json['brand'] as Map<String, dynamic>),
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  status: (json['status'] as num?)?.toInt() ?? 1,
  createdAt: json['created_at'] as String? ?? '',
  updatedAt: json['updated_at'] as String? ?? '',
);

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumb': instance.thumb,
  'price': instance.price,
  'description': instance.description,
  'brand_id': instance.brandId,
  'brand': instance.brand.toJson(),
  'sort_order': instance.sortOrder,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
